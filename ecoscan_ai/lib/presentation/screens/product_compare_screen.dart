import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class ProductCompareScreen extends StatelessWidget {
  final ProductModel productA;
  final AIAnalysisModel analysisA;
  final ProductModel productB;
  final AIAnalysisModel? analysisB;

  const ProductCompareScreen({
    super.key,
    required this.productA,
    required this.analysisA,
    required this.productB,
    this.analysisB,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('So sánh sản phẩm')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header row with both products
          Row(
            children: [
              Expanded(child: _ProductHeader(product: productA)),
              Container(
                width: 1,
                height: 90,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(child: _ProductHeader(product: productB)),
            ],
          ),
          const SizedBox(height: 20),

          // Eco Score comparison
          const SectionHeader(title: 'Eco Score tổng hợp'),
          _CompareRow(
            label: 'Điểm tổng',
            valueA: '${analysisA.overallScore}/100',
            valueB: analysisB != null ? '${analysisB!.overallScore}/100' : 'N/A',
            scoreA: analysisA.overallScore,
            scoreB: analysisB?.overallScore,
            higherIsBetter: true,
          ),
          _CompareRow(
            label: 'Mức độ',
            widgetA: EcoScoreChip(level: analysisA.level),
            widgetB: analysisB != null
                ? EcoScoreChip(level: analysisB!.level)
                : const Text('N/A', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 16),

          // Sub-scores
          const SectionHeader(title: 'Điểm chi tiết'),
          _CompareRow(
            label: 'Sức khỏe',
            valueA: '${analysisA.health.score}',
            valueB: analysisB != null ? '${analysisB!.health.score}' : 'N/A',
            scoreA: analysisA.health.score,
            scoreB: analysisB?.health.score,
            higherIsBetter: true,
          ),
          _CompareRow(
            label: 'Môi trường',
            valueA: '${analysisA.environment.score}',
            valueB: analysisB != null ? '${analysisB!.environment.score}' : 'N/A',
            scoreA: analysisA.environment.score,
            scoreB: analysisB?.environment.score,
            higherIsBetter: true,
          ),
          _CompareRow(
            label: 'Đạo đức',
            valueA: '${analysisA.ethics.score}',
            valueB: analysisB != null ? '${analysisB!.ethics.score}' : 'N/A',
            scoreA: analysisA.ethics.score,
            scoreB: analysisB?.ethics.score,
            higherIsBetter: true,
          ),
          const SizedBox(height: 16),

          // Nutri-Score
          const SectionHeader(title: 'Nutri-Score'),
          _CompareRow(
            label: 'Nutri-Score',
            widgetA: _NutriScoreTag(grade: productA.nutriScore),
            widgetB: _NutriScoreTag(grade: productB.nutriScore),
            scoreA: _nutriScoreValue(productA.nutriScore),
            scoreB: _nutriScoreValue(productB.nutriScore),
            higherIsBetter: false, // lower letter = better (a < b < c...)
          ),
          const SizedBox(height: 16),

          // Ingredients count
          const SectionHeader(title: 'Thành phần'),
          _CompareRow(
            label: 'Số thành phần',
            valueA: '${productA.ingredients.length}',
            valueB: '${productB.ingredients.length}',
            scoreA: productA.ingredients.length,
            scoreB: productB.ingredients.length,
            higherIsBetter: false,
          ),
          _CompareRow(
            label: 'Thành phần cần tránh',
            valueA: '${_avoidCount(analysisA)}',
            valueB: analysisB != null
                ? '${_avoidCount(analysisB!)}'
                : '${productB.ingredients.length}',
            scoreA: _avoidCount(analysisA),
            scoreB: analysisB != null ? _avoidCount(analysisB!) : null,
            higherIsBetter: false,
          ),
          const SizedBox(height: 16),

          // Greenwashing
          const SectionHeader(title: 'Greenwashing'),
          _CompareRow(
            label: 'Trạng thái',
            widgetA: GreenwashingBadge(
                level: analysisA.greenwashing.level, compact: true),
            widgetB: analysisB != null
                ? GreenwashingBadge(
                    level: analysisB!.greenwashing.level, compact: true)
                : const Text('N/A', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 24),

          // Recommendation
          _Recommendation(
            analysisA: analysisA,
            analysisB: analysisB,
            nameA: productA.name,
            nameB: productB.name,
          ),
          const SizedBox(height: 16),

          // "Chọn sản phẩm này" button for the alternative (productB)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  context.push('/product/alternatives/detail', extra: productB),
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                productB.name.isNotEmpty
                    ? 'Chọn "${productB.name}"'
                    : 'Chọn sản phẩm này',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }

  int _avoidCount(AIAnalysisModel analysis) =>
      analysis.ingredients
          .where((i) => i.safety == IngredientSafety.avoid)
          .length;

  /// Maps nutriscore letter to a numeric value for comparison (lower = better).
  int _nutriScoreValue(String? grade) {
    const order = ['a', 'b', 'c', 'd', 'e'];
    final idx = order.indexOf(grade?.toLowerCase() ?? '');
    return idx == -1 ? 99 : idx;
  }
}

class _ProductHeader extends StatelessWidget {
  final ProductModel product;

  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: product.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
        const SizedBox(height: 8),
        Text(
          product.name.isNotEmpty ? product.name : 'Sản phẩm',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (product.brand.isNotEmpty)
          Text(
            product.brand,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
    );
  }
}

class _CompareRow extends StatelessWidget {
  final String label;
  final String? valueA;
  final String? valueB;
  final Widget? widgetA;
  final Widget? widgetB;
  final int? scoreA;
  final int? scoreB;
  final bool higherIsBetter;

  const _CompareRow({
    required this.label,
    this.valueA,
    this.valueB,
    this.widgetA,
    this.widgetB,
    this.scoreA,
    this.scoreB,
    this.higherIsBetter = true,
  });

  @override
  Widget build(BuildContext context) {
    final aWins = scoreA != null && scoreB != null
        ? higherIsBetter
            ? scoreA! > scoreB!
            : scoreA! < scoreB!
        : false;
    final bWins = scoreA != null && scoreB != null
        ? higherIsBetter
            ? scoreB! > scoreA!
            : scoreB! < scoreA!
        : false;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ValueCell(
              value: valueA,
              child: widgetA,
              highlight: aWins,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: _ValueCell(
              value: valueB,
              child: widgetB,
              highlight: bWins,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String? value;
  final Widget? child;
  final bool highlight;

  const _ValueCell({this.value, this.child, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: highlight
          ? BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Center(
        child: child ??
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                color: highlight ? AppColors.primary : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}

class _Recommendation extends StatelessWidget {
  final AIAnalysisModel analysisA;
  final AIAnalysisModel? analysisB;
  final String nameA;
  final String nameB;

  const _Recommendation({
    required this.analysisA,
    required this.analysisB,
    required this.nameA,
    required this.nameB,
  });

  @override
  Widget build(BuildContext context) {
    if (analysisB == null) return const SizedBox.shrink();

    final aScore = analysisA.overallScore;
    final bScore = analysisB!.overallScore;
    final winner = aScore >= bScore ? nameA : nameB;
    final diff = (aScore - bScore).abs();

    return Card(
      color: AppColors.primary.withOpacity(0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.emoji_events_outlined,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Khuyến nghị',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    diff < 5
                        ? 'Hai sản phẩm có chất lượng tương đương nhau.'
                        : '${winner.isNotEmpty ? winner : "Sản phẩm A"} là lựa chọn tốt hơn với điểm cao hơn $diff điểm.',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[700], height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutriScoreTag extends StatelessWidget {
  final String? grade;

  const _NutriScoreTag({this.grade});

  @override
  Widget build(BuildContext context) {
    if (grade == null || grade!.isEmpty) {
      return Text('N/A', style: TextStyle(color: Colors.grey[500], fontSize: 13));
    }
    final color = _colorForGrade(grade!.toLowerCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        grade!.toUpperCase(),
        style: TextStyle(
            fontSize: 13, color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  Color _colorForGrade(String g) {
    switch (g) {
      case 'a':
        return AppColors.primary;
      case 'b':
        return const Color(0xFF558B2F);
      case 'c':
        return AppColors.warning;
      case 'd':
        return const Color(0xFFE65100);
      default:
        return AppColors.danger;
    }
  }
}
