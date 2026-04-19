import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class AlternativeDetailScreen extends StatelessWidget {
  final ProductModel product;

  const AlternativeDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm thay thế')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: product.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name.isNotEmpty ? product.name : 'Sản phẩm không tên',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        if (product.brand.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(product.brand,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600])),
                        ],
                        if (product.countries.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 13, color: Colors.grey[500]),
                              const SizedBox(width: 3),
                              Text(product.countries,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500])),
                            ],
                          ),
                        ],
                        if (product.ecoScore != null) ...[
                          const SizedBox(height: 8),
                          _EcoScoreTag(grade: product.ecoScore!),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ingredients
          if (product.ingredientsText.isNotEmpty) ...[
            const SectionHeader(title: 'Thành phần'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  product.ingredientsText,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[700], height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Allergens
          if (product.allergens.isNotEmpty) ...[
            AllergenWarningBanner(allergens: product.allergens),
            const SizedBox(height: 16),
          ],

          // Labels
          if (product.labels.isNotEmpty) ...[
            const SectionHeader(title: 'Nhãn & chứng nhận'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.labels
                      .map((l) => _LabelChip(label: _formatLabel(l)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Scan this product button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/scan/manual'),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Quét sản phẩm này'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 32),
    );
  }

  String _formatLabel(String label) {
    return label
        .replaceAll('en:', '')
        .replaceAll('fr:', '')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}

class _EcoScoreTag extends StatelessWidget {
  final String grade;

  const _EcoScoreTag({required this.grade});

  @override
  Widget build(BuildContext context) {
    final color = _colorForGrade(grade.toLowerCase());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        'Eco Score: ${grade.toUpperCase()}',
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _colorForGrade(String grade) {
    switch (grade) {
      case 'a':
      case 'b':
        return AppColors.primary;
      case 'c':
        return AppColors.warning;
      default:
        return AppColors.danger;
    }
  }
}

class _LabelChip extends StatelessWidget {
  final String label;

  const _LabelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
      ),
    );
  }
}
