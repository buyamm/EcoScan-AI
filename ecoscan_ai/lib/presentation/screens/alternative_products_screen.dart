import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/open_food_facts_service.dart';
import '../../core/theme/app_theme.dart';
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
  final _service = OpenFoodFactsService();
  List<ProductModel> _alternatives = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlternatives();
  }

  Future<void> _loadAlternatives() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final category = widget.product.category ?? '';
      final results = await _service.searchAlternatives(
        category,
        widget.product.barcode,
      );
      if (mounted) {
        setState(() {
          _alternatives = results;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm thay thế')),
      body: Column(
        children: [
          // Current product summary
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
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tìm sản phẩm thay thế...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return ErrorStateWidget(
        message: _error!,
        onRetry: _loadAlternatives,
      );
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
        ..._alternatives.map((alt) => ProductListTile.fromProduct(
              alt,
              onTap: () => context.go('/product/alternatives/detail', extra: alt),
            )),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Dữ liệu từ Open Food Facts. Eco Score là ước tính từ AI.',
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
