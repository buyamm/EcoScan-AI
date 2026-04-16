import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class AllergenWarningScreen extends StatelessWidget {
  final ProductModel product;
  final AIAnalysisModel analysis;
  final List<String> detectedAllergens;

  const AllergenWarningScreen({
    super.key,
    required this.product,
    required this.analysis,
    required this.detectedAllergens,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cảnh báo dị ứng'),
        backgroundColor: AppColors.danger,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Big warning
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.danger, width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.warning_rounded,
                    color: AppColors.danger, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Cảnh báo dị ứng!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sản phẩm này chứa các thành phần có thể gây dị ứng cho bạn.',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey[700], height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Product info
          const SectionHeader(title: 'Sản phẩm'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                product.name.isNotEmpty ? product.name : 'Sản phẩm không tên',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Detected allergens list
          const SectionHeader(title: 'Chất gây dị ứng phát hiện'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: detectedAllergens.map((allergen) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_outlined,
                            color: AppColors.danger, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatAllergen(allergen),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Flagged ingredients from AI
          if (analysis.ingredients.any(
              (i) => i.safety == IngredientSafety.avoid)) ...[
            const SectionHeader(title: 'Thành phần cần tránh'),
            ...analysis.ingredients
                .where((i) => i.safety == IngredientSafety.avoid)
                .map((i) => IngredientCard(ingredient: i)),
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
              onPressed: () => context.go('/product/detail', extra: {
                'product': product,
                'analysis': analysis,
              }),
              child: const Text('Vẫn xem chi tiết sản phẩm'),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: AppColors.danger.withOpacity(0.04),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.medical_information_outlined,
                      color: AppColors.danger, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nếu bạn có phản ứng dị ứng nghiêm trọng, hãy liên hệ dịch vụ y tế ngay lập tức.',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
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

  String _formatAllergen(String allergen) {
    return allergen
        .replaceAll('en:', '')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}
