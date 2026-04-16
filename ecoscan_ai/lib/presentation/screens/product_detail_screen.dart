import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/ai/ai_bloc.dart';
import '../../data/models/product_model.dart';
import '../../data/models/ai_analysis_model.dart';
import '../widgets/eco_score_chip.dart';
import '../../core/theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final AIAnalysisModel? analysis;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          if (analysis == null)
            TextButton(
              onPressed: () {
                context.read<AIBloc>().add(AnalyzeProduct(product));
                context.go('/ai/loading');
              },
              child: const Text(
                'Phân tích AI',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: ListView(
        children: [
          // Product image
          if (product.imageUrl.isNotEmpty)
            GestureDetector(
              onTap: () => context.go(
                '/product/image',
                extra: product.imageUrl,
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.inventory_2_outlined,
                      size: 80, color: Colors.grey),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & brand
                Text(
                  product.name.isNotEmpty
                      ? product.name
                      : 'Tên chưa xác định',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                if (product.brand.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(product.brand,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[600])),
                ],
                const SizedBox(height: 12),
                // Eco score chip
                if (analysis != null)
                  EcoScoreChip(
                      level: analysis!.level,
                      score: analysis!.overallScore,
                      showScore: true),
                const SizedBox(height: 16),
                const Divider(),
                // Info rows
                _InfoRow(
                    icon: Icons.qr_code,
                    label: 'Mã vạch',
                    value: product.barcode),
                if (product.countries.isNotEmpty)
                  _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Xuất xứ',
                      value: product.countries),
                if (product.ecoScore != null)
                  _InfoRow(
                      icon: Icons.eco_outlined,
                      label: 'Eco Score (OFF)',
                      value: product.ecoScore!.toUpperCase()),
                if (product.nutriScore != null)
                  _InfoRow(
                      icon: Icons.health_and_safety_outlined,
                      label: 'Nutri-Score',
                      value: product.nutriScore!.toUpperCase()),
                const Divider(),
                const SizedBox(height: 8),
                // Nutrition summary
                if (product.nutrition != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dinh dưỡng',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () => context.go(
                          '/product/nutrition',
                          extra: product,
                        ),
                        child: const Text('Xem đầy đủ'),
                      ),
                    ],
                  ),
                  _NutritionSummaryRow(product: product),
                ],
                const SizedBox(height: 12),
                // Ingredient preview
                if (product.ingredientsText.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thành phần',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      if (analysis != null)
                        TextButton(
                          onPressed: () => context.go(
                            '/product/ingredients',
                            extra: {
                              'product': product,
                              'analysis': analysis,
                            },
                          ),
                          child: const Text('Xem chi tiết'),
                        ),
                    ],
                  ),
                  Text(
                    product.ingredientsText,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                // Action buttons
                if (analysis != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go(
                        '/product/score',
                        extra: {
                          'product': product,
                          'analysis': analysis,
                        },
                      ),
                      icon: const Icon(Icons.bar_chart),
                      label: const Text('Xem phân tích điểm số'),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<AIBloc>()
                            .add(AnalyzeProduct(product));
                        context.go('/ai/loading');
                      },
                      icon: const Icon(Icons.psychology),
                      label: const Text('Phân tích AI'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionSummaryRow extends StatelessWidget {
  final ProductModel product;

  const _NutritionSummaryRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final n = product.nutrition;
    if (n == null) return const SizedBox.shrink();

    return Row(
      children: [
        _NutriBadge(
            label: 'Calo',
            value: '${n.energyKcal?.toStringAsFixed(0) ?? '-'} kcal'),
        const SizedBox(width: 8),
        _NutriBadge(
            label: 'Protein',
            value: '${n.proteins?.toStringAsFixed(1) ?? '-'} g'),
        const SizedBox(width: 8),
        _NutriBadge(
            label: 'Carbs',
            value:
                '${n.carbohydrates?.toStringAsFixed(1) ?? '-'} g'),
      ],
    );
  }
}

class _NutriBadge extends StatelessWidget {
  final String label;
  final String value;

  const _NutriBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
            ),
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
