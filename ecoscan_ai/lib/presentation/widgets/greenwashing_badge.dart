import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';

/// Badge displaying greenwashing detection level with 3 tiers.
class GreenwashingBadge extends StatelessWidget {
  final GreenwashingLevel level;
  final bool compact;

  const GreenwashingBadge({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _configFor(level);

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: config.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: config.color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(config.icon, size: 12, color: config.color),
            const SizedBox(width: 4),
            Text(
              config.shortLabel,
              style: TextStyle(
                color: config.color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 18, color: config.color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                config.shortLabel,
                style: TextStyle(
                  color: config.color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                config.description,
                style: TextStyle(
                  color: config.color.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static _BadgeConfig _configFor(GreenwashingLevel level) {
    switch (level) {
      case GreenwashingLevel.none:
        return _BadgeConfig(
          color: AppColors.primary,
          icon: Icons.verified_outlined,
          shortLabel: 'Không phát hiện',
          description: 'Không có tuyên bố đáng ngờ',
        );
      case GreenwashingLevel.suspected:
        return _BadgeConfig(
          color: AppColors.warning,
          icon: Icons.help_outline,
          shortLabel: 'Nghi ngờ',
          description: 'Có thể có greenwashing',
        );
      case GreenwashingLevel.confirmed:
        return _BadgeConfig(
          color: AppColors.danger,
          icon: Icons.gpp_bad_outlined,
          shortLabel: 'Xác nhận Greenwashing',
          description: 'Tuyên bố không trung thực',
        );
    }
  }
}

class _BadgeConfig {
  final Color color;
  final IconData icon;
  final String shortLabel;
  final String description;

  const _BadgeConfig({
    required this.color,
    required this.icon,
    required this.shortLabel,
    required this.description,
  });
}
