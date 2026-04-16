import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Red warning banner listing allergens detected in a product.
class AllergenWarningBanner extends StatelessWidget {
  final List<String> allergens;
  final VoidCallback? onDismiss;

  const AllergenWarningBanner({
    super.key,
    required this.allergens,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (allergens.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded, color: AppColors.danger, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cảnh báo dị ứng',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sản phẩm chứa: ${allergens.join(', ')}',
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, color: AppColors.danger, size: 18),
            ),
        ],
      ),
    );
  }
}
