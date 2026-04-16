import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';

class AchievementListScreen extends StatelessWidget {
  const AchievementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        final achievements = _buildAchievements(records);

        return Scaffold(
          appBar: AppBar(title: const Text('Thành tích')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${achievements.where((a) => a.unlocked).length}/${achievements.length} huy hiệu đã đạt',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),
              ...achievements.map((a) => _AchievementTile(
                    achievement: a,
                    onTap: () => context.push('/achievements/detail',
                        extra: a),
                  )),
            ],
          ),
        );
      },
    );
  }

  List<Achievement> _buildAchievements(records) {
    final total = records.length;
    final greenCount = records
        .where((r) => r.analysis.level == EcoScoreLevel.green)
        .length;

    return [
      Achievement(
        id: 'first_scan',
        title: 'Bước đầu tiên',
        description: 'Quét sản phẩm đầu tiên',
        emoji: '🌱',
        unlocked: total >= 1,
      ),
      Achievement(
        id: 'scan_10',
        title: 'Người khám phá',
        description: 'Quét 10 sản phẩm',
        emoji: '🔍',
        unlocked: total >= 10,
        progress: total < 10 ? '$total/10' : null,
      ),
      Achievement(
        id: 'scan_50',
        title: 'Chuyên gia quét',
        description: 'Quét 50 sản phẩm',
        emoji: '🏆',
        unlocked: total >= 50,
        progress: total < 50 ? '$total/50' : null,
      ),
      Achievement(
        id: 'first_green',
        title: 'Sản phẩm xanh đầu tiên',
        description: 'Tìm thấy sản phẩm với điểm ≥70',
        emoji: '🟢',
        unlocked: greenCount >= 1,
      ),
      Achievement(
        id: 'green_5',
        title: 'Người tiêu dùng xanh',
        description: 'Quét 5 sản phẩm tốt (🟢)',
        emoji: '🌿',
        unlocked: greenCount >= 5,
        progress: greenCount < 5 ? '$greenCount/5' : null,
      ),
      Achievement(
        id: 'green_20',
        title: 'Chiến binh eco',
        description: 'Quét 20 sản phẩm tốt (🟢)',
        emoji: '🌍',
        unlocked: greenCount >= 20,
        progress: greenCount < 20 ? '$greenCount/20' : null,
      ),
    ];
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final bool unlocked;
  final String? progress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.unlocked,
    this.progress,
  });
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onTap;

  const _AchievementTile(
      {required this.achievement, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: achievement.unlocked
                ? AppColors.primary.withOpacity(0.12)
                : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              achievement.emoji,
              style: TextStyle(
                  fontSize: 22,
                  color: achievement.unlocked ? null : null),
            ),
          ),
        ),
        title: Text(
          achievement.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: achievement.unlocked ? null : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              style: TextStyle(
                  fontSize: 12,
                  color: achievement.unlocked
                      ? Colors.grey[600]
                      : Colors.grey[400]),
            ),
            if (achievement.progress != null && !achievement.unlocked) ...[
              const SizedBox(height: 4),
              Text(
                achievement.progress!,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
        trailing: achievement.unlocked
            ? const Icon(Icons.check_circle,
                color: AppColors.primary, size: 22)
            : Icon(Icons.lock_outline,
                color: Colors.grey[400], size: 20),
        onTap: onTap,
      ),
    );
  }
}
