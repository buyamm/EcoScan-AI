import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';

class IngredientDetailScreen extends StatelessWidget {
  final IngredientAnalysis ingredient;

  const IngredientDetailScreen({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(ingredient.safety);
    final icon = _iconFor(ingredient.safety);
    final label = _labelFor(ingredient.safety);

    return Scaffold(
      appBar: AppBar(title: Text(ingredient.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Safety badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Ingredient name
          Text(
            ingredient.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // AI explanation
          _SectionCard(
            icon: Icons.psychology_outlined,
            title: 'Phân tích AI',
            child: Text(
              ingredient.explanation.isNotEmpty
                  ? ingredient.explanation
                  : 'Không có thông tin phân tích cho thành phần này.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Context card
          _SectionCard(
            icon: Icons.info_outline,
            title: 'Mức độ an toàn',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SafetyRow(safety: ingredient.safety),
                const SizedBox(height: 8),
                Text(
                  _contextFor(ingredient.safety),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_outlined, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Thông tin này được tạo bởi AI và chỉ mang tính tham khảo. Hãy tham khảo chuyên gia y tế nếu có lo ngại về sức khỏe.',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500], height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _colorFor(IngredientSafety safety) {
    switch (safety) {
      case IngredientSafety.safe:
        return AppColors.primary;
      case IngredientSafety.caution:
        return AppColors.warning;
      case IngredientSafety.avoid:
        return AppColors.danger;
    }
  }

  static IconData _iconFor(IngredientSafety safety) {
    switch (safety) {
      case IngredientSafety.safe:
        return Icons.check_circle_outline;
      case IngredientSafety.caution:
        return Icons.warning_amber_outlined;
      case IngredientSafety.avoid:
        return Icons.cancel_outlined;
    }
  }

  static String _labelFor(IngredientSafety safety) {
    switch (safety) {
      case IngredientSafety.safe:
        return 'An toàn';
      case IngredientSafety.caution:
        return 'Cần cẩn thận';
      case IngredientSafety.avoid:
        return 'Nên tránh dùng';
    }
  }

  static String _contextFor(IngredientSafety safety) {
    switch (safety) {
      case IngredientSafety.safe:
        return 'Thành phần này được đánh giá là an toàn cho hầu hết mọi người. Tuy nhiên, phản ứng cá nhân có thể khác nhau.';
      case IngredientSafety.caution:
        return 'Thành phần này có thể gây lo ngại với một số đối tượng nhất định. Người có tiền sử dị ứng hoặc nhạy cảm nên thận trọng.';
      case IngredientSafety.avoid:
        return 'Thành phần này có thể gây hại hoặc kích ứng. Hạn chế sử dụng sản phẩm chứa thành phần này nếu có thể.';
    }
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _SafetyRow extends StatelessWidget {
  final IngredientSafety safety;

  const _SafetyRow({required this.safety});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: IngredientSafety.values.map((s) {
        final isActive = s == safety;
        final color = _color(s);
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _color(IngredientSafety s) {
    switch (s) {
      case IngredientSafety.safe:
        return AppColors.primary;
      case IngredientSafety.caution:
        return AppColors.warning;
      case IngredientSafety.avoid:
        return AppColors.danger;
    }
  }
}
