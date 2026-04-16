import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';

/// Card displaying a single ingredient with safety indicator and AI explanation.
class IngredientCard extends StatelessWidget {
  final IngredientAnalysis ingredient;
  final VoidCallback? onTap;

  const IngredientCard({
    super.key,
    required this.ingredient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(ingredient.safety);
    final icon = _iconFor(ingredient.safety);
    final label = _labelFor(ingredient.safety);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Safety indicator dot
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, size: 12, color: color),
                              const SizedBox(width: 3),
                              Text(
                                label,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (ingredient.explanation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        ingredient.explanation,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
            ],
          ),
        ),
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
        return 'Cẩn thận';
      case IngredientSafety.avoid:
        return 'Tránh dùng';
    }
  }
}
