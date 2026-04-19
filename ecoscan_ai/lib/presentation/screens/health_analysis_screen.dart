import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class HealthAnalysisScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const HealthAnalysisScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final health = analysis.health;

    return Scaffold(
      appBar: AppBar(title: const Text('Phân tích sức khỏe')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Score gauge
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ScoreGauge(score: health.score, label: 'Sức khỏe', size: 120),
                  const SizedBox(height: 8),
                  Text(
                    _scoreDesc(health.score),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Positives
          if (health.positives.isNotEmpty) ...[
            const SectionHeader(title: 'Điểm tích cực'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: health.positives
                      .map((p) => _ItemRow(text: p, color: AppColors.primary,
                          icon: Icons.check_circle_outline))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Concerns
          if (health.concerns.isNotEmpty) ...[
            const SectionHeader(title: 'Điểm lo ngại'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: health.concerns
                      .map((c) => _ItemRow(text: c, color: AppColors.danger,
                          icon: Icons.warning_amber_outlined))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Ingredients flagged
          if (analysis.ingredients.any((i) =>
              i.safety == IngredientSafety.caution ||
              i.safety == IngredientSafety.avoid)) ...[
            const SectionHeader(title: 'Thành phần cần lưu ý'),
            ...analysis.ingredients
                .where((i) =>
                    i.safety == IngredientSafety.caution ||
                    i.safety == IngredientSafety.avoid)
                .map((i) => IngredientCard(ingredient: i)),
          ],
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
        ],
      ),
    );
  }

  String _scoreDesc(int score) {
    if (score >= 70) return 'Sản phẩm có thành phần an toàn, ít lo ngại về sức khỏe.';
    if (score >= 40) return 'Sản phẩm có một số thành phần cần chú ý.';
    return 'Sản phẩm chứa nhiều thành phần đáng lo ngại về sức khỏe.';
  }
}

class _ItemRow extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _ItemRow({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5)),
          ),
        ],
      ),
    );
  }
}
