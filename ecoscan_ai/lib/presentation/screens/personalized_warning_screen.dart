import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class PersonalizedWarningScreen extends StatelessWidget {
  final ProductModel product;
  final AIAnalysisModel analysis;
  final UserProfile userProfile;
  final List<String> allergenConflicts;
  final List<LifestyleOption> lifestyleConflicts;

  const PersonalizedWarningScreen({
    super.key,
    required this.product,
    required this.analysis,
    required this.userProfile,
    required this.allergenConflicts,
    required this.lifestyleConflicts,
  });

  @override
  Widget build(BuildContext context) {
    final hasAllergens = allergenConflicts.isNotEmpty;
    final hasLifestyle = lifestyleConflicts.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cảnh báo cá nhân'),
        backgroundColor: hasAllergens ? AppColors.danger : AppColors.warning,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Allergen warnings
          if (hasAllergens) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.danger, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_rounded,
                          color: AppColors.danger, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Phát hiện chất gây dị ứng!',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: allergenConflicts.map((a) => _WarningChip(
                          label: a,
                          color: AppColors.danger,
                        )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Lifestyle conflicts
          if (hasLifestyle) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline,
                          color: AppColors.warning, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Xung đột lối sống',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...lifestyleConflicts.map((l) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Text(_emojiFor(l),
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(_labelFor(l),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Product
          const SectionHeader(title: 'Sản phẩm'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined,
                  color: AppColors.primary),
              title: Text(
                product.name.isNotEmpty ? product.name : 'Sản phẩm',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle:
                  product.brand.isNotEmpty ? Text(product.brand) : null,
            ),
          ),
          const SizedBox(height: 20),

          // Actions
          if (hasAllergens)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                onPressed: () => context.push('/product/alternatives', extra: {
                  'product': product,
                  'analysis': analysis,
                }),
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Tìm sản phẩm thay thế an toàn'),
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/product/ai', extra: {
                'product': product,
                'analysis': analysis,
              }),
              child: const Text('Xem phân tích AI đầy đủ'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.push('/product/detail', extra: {
                'product': product,
                'analysis': analysis,
              }),
              child: const Text('Vẫn xem chi tiết sản phẩm'),
            ),
          ),
        ],
      ),
    );
  }

  String _emojiFor(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return '🥗';
      case LifestyleOption.vegan: return '🌿';
      case LifestyleOption.ecoConscious: return '♻️';
      case LifestyleOption.crueltyFreeOnly: return '🐾';
    }
  }

  String _labelFor(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return 'Ăn chay (Vegetarian)';
      case LifestyleOption.vegan: return 'Thuần chay (Vegan)';
      case LifestyleOption.ecoConscious: return 'Eco-conscious';
      case LifestyleOption.crueltyFreeOnly: return 'Không thử nghiệm động vật';
    }
  }
}

class _WarningChip extends StatelessWidget {
  final String label;
  final Color color;
  const _WarningChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 13, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
