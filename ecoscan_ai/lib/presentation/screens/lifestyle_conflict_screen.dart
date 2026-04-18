import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class LifestyleConflictScreen extends StatelessWidget {
  final ProductModel product;
  final AIAnalysisModel analysis;
  final UserProfile userProfile;

  const LifestyleConflictScreen({
    super.key,
    required this.product,
    required this.analysis,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final conflicts = _detectConflicts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xung đột lối sống'),
        backgroundColor: AppColors.warning,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Warning header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warning, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.warning, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Xung đột lối sống',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sản phẩm này có thể không phù hợp với lối sống của bạn.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[700], height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Product info
          const SectionHeader(title: 'Sản phẩm'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined,
                  color: AppColors.primary),
              title: Text(
                product.name.isNotEmpty ? product.name : 'Sản phẩm',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: product.brand.isNotEmpty ? Text(product.brand) : null,
            ),
          ),
          const SizedBox(height: 16),

          // Conflicts list
          if (conflicts.isNotEmpty) ...[
            const SectionHeader(title: 'Xung đột phát hiện'),
            ...conflicts.map((c) => _ConflictCard(conflict: c)),
            const SizedBox(height: 16),
          ],

          // Conflicting ingredients from AI analysis
          if (analysis.ingredients.any(
              (i) => i.safety == IngredientSafety.avoid)) ...[
            const SectionHeader(title: 'Thành phần xung đột'),
            ...analysis.ingredients
                .where((i) => i.safety == IngredientSafety.avoid)
                .map((i) => IngredientCard(ingredient: i)),
            const SizedBox(height: 16),
          ],

          // Not suitable for
          if (analysis.notSuitableFor.isNotEmpty) ...[
            const SectionHeader(title: 'Sản phẩm không phù hợp với'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: analysis.notSuitableFor
                      .map((s) => _LifestyleChip(label: s, suitable: false))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/product/alternatives', extra: {
                'product': product,
                'analysis': analysis,
              }),
              child: const Text('Xem sản phẩm thay thế'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Quay lại'),
            ),
          ),
        ],
      ),
    );
  }

  List<_ConflictItem> _detectConflicts() {
    final conflicts = <_ConflictItem>[];
    final lifestyle = userProfile.lifestyle;

    for (final option in lifestyle) {
      switch (option) {
        case LifestyleOption.vegan:
          if (analysis.ethics.vegan == false ||
              analysis.notSuitableFor
                  .any((s) => s.toLowerCase().contains('vegan') ||
                      s.toLowerCase().contains('thuần chay'))) {
            conflicts.add(_ConflictItem(
              lifestyle: 'Thuần chay (Vegan)',
              reason: 'Sản phẩm có thể chứa thành phần từ động vật.',
              icon: Icons.grass_outlined,
            ));
          }
          break;
        case LifestyleOption.vegetarian:
          if (analysis.notSuitableFor.any((s) =>
              s.toLowerCase().contains('vegetarian') ||
              s.toLowerCase().contains('ăn chay'))) {
            conflicts.add(_ConflictItem(
              lifestyle: 'Ăn chay (Vegetarian)',
              reason: 'Sản phẩm có thể không phù hợp với chế độ ăn chay.',
              icon: Icons.eco_outlined,
            ));
          }
          break;
        case LifestyleOption.crueltyFreeOnly:
          if (analysis.ethics.crueltyFree == false) {
            conflicts.add(_ConflictItem(
              lifestyle: 'Không thử nghiệm động vật',
              reason: 'Sản phẩm có thể được thử nghiệm trên động vật.',
              icon: Icons.pets_outlined,
            ));
          }
          break;
        case LifestyleOption.ecoConscious:
          if (analysis.environment.score < 40) {
            conflicts.add(_ConflictItem(
              lifestyle: 'Eco-conscious',
              reason:
                  'Sản phẩm có điểm môi trường thấp (${analysis.environment.score}/100).',
              icon: Icons.eco_outlined,
            ));
          }
          break;
      }
    }

    return conflicts;
  }
}

class _ConflictItem {
  final String lifestyle;
  final String reason;
  final IconData icon;

  const _ConflictItem({
    required this.lifestyle,
    required this.reason,
    required this.icon,
  });
}

class _ConflictCard extends StatelessWidget {
  final _ConflictItem conflict;

  const _ConflictCard({required this.conflict});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(conflict.icon, color: AppColors.warning, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conflict.lifestyle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conflict.reason,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
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

class _LifestyleChip extends StatelessWidget {
  final String label;
  final bool suitable;

  const _LifestyleChip({required this.label, required this.suitable});

  @override
  Widget build(BuildContext context) {
    final color = suitable ? AppColors.primary : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
