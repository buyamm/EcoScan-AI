import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'achievement_list_screen.dart';

class AchievementDetailScreen extends StatelessWidget {
  final Achievement achievement;

  const AchievementDetailScreen({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết thành tích')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: achievement.unlocked
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: achievement.unlocked
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    achievement.emoji,
                    style: TextStyle(
                      fontSize: 52,
                      color: achievement.unlocked ? null : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                achievement.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                achievement.description,
                style: TextStyle(
                    fontSize: 15, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (achievement.unlocked) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Đã đạt được',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline,
                          color: Colors.grey[500], size: 18),
                      const SizedBox(width: 8),
                      Text(
                        achievement.progress != null
                            ? 'Tiến độ: ${achievement.progress}'
                            : 'Chưa đạt được',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
