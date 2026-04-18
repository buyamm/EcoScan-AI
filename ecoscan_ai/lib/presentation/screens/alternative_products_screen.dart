import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/groq_service.dart';
import '../../data/services/open_food_facts_service.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/profile/profile_cubit.dart';
import '../widgets/widgets.dart';

class AlternativeProductsScreen extends StatefulWidget {
  final ProductModel product;
  final AIAnalysisModel analysis;

  const AlternativeProductsScreen({
    super.key,
    required this.product,
    required this.analysis,
  });

  @override
  State<AlternativeProductsScreen> createState() =>
      _AlternativeProductsScreenState();
}

class _AlternativeProductsScreenState
    extends State<AlternativeProductsScreen> {
  final _offService = OpenFoodFactsService();
  final _groqService = GroqService();

  List<ProductModel> _alternatives = [];
  List<String> _aiKeywords = [];
  bool _loading = true;
  String? _error;
  String _statusMessage = 'Đang hỏi AI về sản phẩm thay thế...';

  @override
  void initState() {
    super.initState();
    _loadAlternatives();
  }

  Future<void> _loadAlternatives() async {
    setState(() {
      _loading = true;
      _error = null;
      _aiKeywords = [];
      _statusMessage = 'Đang hỏi AI về sản phẩm thay thế...';
    });

    try {
      final profile = context.read<ProfileCubit>().state.profile;

      // Step 1: Ask AI for generic alternative keywords
      final keywords = await _groqService.suggestAlternativeKeywords(
        widget.product,
        profile,
      );

      if (!mounted) return;
      setState(() {
        _aiKeywords = keywords;
        _statusMessage = keywords.isNotEmpty
            ? 'Đang tìm: ${keywords.take(3).join(', ')}...'
            : 'Đang tìm sản phẩm thay thế...';
      });

      // Step 2: Search OFF for each keyword, collect unique results
      List<ProductModel> results = [];
      final seenBarcodes = <String>{widget.product.barcode};

      if (keywords.isNotEmpty) {
        final searchFutures = keywords
            .take(3)
            .map((kw) => _offService.searchByKeyword(
                  kw,
                  excludeBarcode: widget.product.barcode,
                  limit: 5,
                ));

        final searchResults = await Future.wait(searchFutures);
        for (final batch in searchResults) {
          for (final p in batch) {
            if (seenBarcodes.add(p.barcode)) {
              results.add(p);
            }
          }
        }
      }

      // Fallback: category-based search if AI/OFF returned nothing
      if (results.isEmpty) {
        results = await _offService.searchAlternatives(
          widget.product.category ?? '',
          widget.product.barcode,
          fallbackTag:
              widget.product.labels.isNotEmpty ? widget.product.labels.first : '',
          allCategories: widget.product.categories,
        );
      }

      // Filter out allergen-conflicting products
      final userAllergens =
          profile.allAllergies.map((a) => a.toLowerCase()).toList();

      final filtered = results.where((p) {
        if (userAllergens.isEmpty) return true;
        final pa = p.allergens.map((a) => a.toLowerCase()).toList();
        return !pa.any((a) => userAllergens.any((u) => a.contains(u)));
      }).toList();

      // Suitable products first
      filtered.sort((a, b) {
        final as_ = _isSuitableProduct(a, userAllergens) ? 0 : 1;
        final bs_ = _isSuitableProduct(b, userAllergens) ? 0 : 1;
        return as_.compareTo(bs_);
      });

      if (mounted) {
        setState(() {
          _alternatives = filtered.take(6).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Không thể tải sản phẩm thay thế.';
          _loading = false;
        });
      }
    }
  }

  bool _isSuitableProduct(ProductModel product, List<String> userAllergens) {
    if (userAllergens.isEmpty) return false;
    final pa = product.allergens.map((a) => a.toLowerCase()).toList();
    return !pa.any((a) => userAllergens.any((u) => a.contains(u)));
  }

  bool _isSuitable(ProductModel product) {
    final profile = context.read<ProfileCubit>().state.profile;
    final userAllergens =
        profile.allAllergies.map((a) => a.toLowerCase()).toList();
    return _isSuitableProduct(product, userAllergens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm thay thế')),
      body: Column(
        children: [
          Container(
            color: AppColors.warning.withOpacity(0.08),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                EcoScoreChip(level: widget.analysis.level),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.product.name.isNotEmpty
                        ? widget.product.name
                        : 'Sản phẩm hiện tại',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (_aiKeywords.isNotEmpty && !_loading)
            Container(
              width: double.infinity,
              color: AppColors.primary.withOpacity(0.05),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text('AI gợi ý: ',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ..._aiKeywords.map((kw) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(kw,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.primary)),
                      )),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(_statusMessage,
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      );
    }

    if (_error != null) {
      return ErrorStateWidget(message: _error!, onRetry: _loadAlternatives);
    }

    if (_alternatives.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.swap_horiz_outlined,
        title: 'Chưa tìm thấy sản phẩm thay thế',
        description: 'Thử lại sau hoặc tìm kiếm thủ công trong cửa hàng.',
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Tìm thấy ${_alternatives.length} sản phẩm thay thế',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        ..._alternatives.map((alt) => _AlternativeTile(
              product: alt,
              isSuitable: _isSuitable(alt),
              onTap: () =>
                  context.go('/product/alternatives/detail', extra: alt),
            )),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Gợi ý bởi AI · Dữ liệu từ Open Food Facts',
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _AlternativeTile extends StatelessWidget {
  final ProductModel product;
  final bool isSuitable;
  final VoidCallback? onTap;

  const _AlternativeTile({
    required this.product,
    required this.isSuitable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductListTile.fromProduct(product, onTap: onTap),
        if (isSuitable)
          Positioned(
            top: 8,
            right: 48,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Phù hợp với bạn ✓',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}
