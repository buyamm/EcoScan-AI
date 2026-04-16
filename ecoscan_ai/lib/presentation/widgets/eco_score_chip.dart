import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';

/// Displays a colored chip with emoji + label based on EcoScoreLevel or raw score.
class EcoScoreChip extends StatelessWidget {
  final EcoScoreLevel? level;
  final int? score;
  final bool showScore;

  const EcoScoreChip({
    super.key,
    this.level,
    this.score,
    this.showScore = false,
  }) : assert(level != null || score != null,
            'Either level or score must be provided');

  EcoScoreLevel get _resolvedLevel {
    if (level != null) return level!;
    final s = score!;
    if (s >= 70) return EcoScoreLevel.green;
    if (s >= 40) return EcoScoreLevel.yellow;
    return EcoScoreLevel.red;
  }

  @override
  Widget build(BuildContext context) {
    final lvl = _resolvedLevel;
    final color = _colorFor(lvl);
    final emoji = _emojiFor(lvl);
    final label = _labelFor(lvl);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            showScore && score != null ? '$label ($score)' : label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  static Color _colorFor(EcoScoreLevel level) {
    switch (level) {
      case EcoScoreLevel.green:
        return AppColors.primary;
      case EcoScoreLevel.yellow:
        return AppColors.warning;
      case EcoScoreLevel.red:
        return AppColors.danger;
    }
  }

  static String _emojiFor(EcoScoreLevel level) {
    switch (level) {
      case EcoScoreLevel.green:
        return '🟢';
      case EcoScoreLevel.yellow:
        return '🟡';
      case EcoScoreLevel.red:
        return '🔴';
    }
  }

  static String _labelFor(EcoScoreLevel level) {
    switch (level) {
      case EcoScoreLevel.green:
        return 'Tốt';
      case EcoScoreLevel.yellow:
        return 'Trung bình';
      case EcoScoreLevel.red:
        return 'Kém';
    }
  }
}
