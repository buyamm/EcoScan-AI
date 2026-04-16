import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class SuitableAudienceScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const SuitableAudienceScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final suitable = analysis.suitableFor;
    final notSuitable = analysis.notSuitableFor;
    final isEmpty = suitable.isEmpty && notSuitable.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Đối tượng phù hợp')),
      body: isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 56, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Không có thông tin về đối tượng phù hợp',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (product != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              product!.name.isNotEmpty
                                  ? 'Phân tích cho: ${product!.name}'
                                  : 'Phân tích đối tượng sử dụng',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (product != null) const SizedBox(height: 16),

                if (suitable.isNotEmpty) ...[
                  const SectionHeader(title: 'Phù hợp với'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: suitable
                                .map((s) => _AudienceChip(
                                      label: s,
                                      suitable: true,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (notSuitable.isNotEmpty) ...[
                  const SectionHeader(title: 'Không phù hợp với'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: notSuitable
                                .map((s) => _AudienceChip(
                                      label: s,
                                      suitable: false,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Allergen warning if applicable
                if (analysis.ingredients.any(
                    (i) => i.safety == IngredientSafety.avoid)) ...[
                  const SectionHeader(title: 'Cảnh báo thành phần'),
                  AllergenWarningBanner(
                    allergens: analysis.ingredients
                        .where((i) => i.safety == IngredientSafety.avoid)
                        .map((i) => i.name)
                        .toList(),
                  ),
                ],

                const SizedBox(height: 8),
                Card(
                  color: AppColors.primary.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.medical_information_outlined,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Thông tin này chỉ mang tính tham khảo. Hãy tham khảo ý kiến chuyên gia y tế nếu bạn có lo ngại sức khỏe cụ thể.',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _AudienceChip extends StatelessWidget {
  final String label;
  final bool suitable;

  const _AudienceChip({required this.label, required this.suitable});

  @override
  Widget build(BuildContext context) {
    final color = suitable ? AppColors.primary : AppColors.danger;
    final icon = suitable ? Icons.check_circle_outline : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
