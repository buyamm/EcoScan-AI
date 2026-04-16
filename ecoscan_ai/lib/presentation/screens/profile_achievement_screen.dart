import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/history/history_cubit.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class ProfileAchievementScreen extends StatelessWidget {
  const ProfileAchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        final achievements = _buildAchievements(records);
        final earned = achievements.where((a) => a.earned).length;

        return Scaffold(
          appBar: AppBar(title: const Text('Huy hiệu thành tích')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Progress header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '$earned / ${achievements.length}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text('Huy hiệu đã đạt',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: achievements.isEmpty
                              ? 0
                              : earned / achievements.length,
                          minHeight: 8,
                          backgroundColor:
                              AppColors.primary.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Earned achievements
              if (achievements.any((a) => a.earned)) ...[
                const SectionHeader(title: '✅ Đã đạt được'),
                ...achievements
                    .where((a) => a.earned)
                    .map((a) => _AchievementCard(achievement: a)),
                const SizedBox(height: 16),
              ],

              // Locked achievements
              if (achievements.any((a) => !a.earned)) ...[
                const SectionHeader(title: '🔒 Chưa đạt được'),
                ...achievements
                    .where((a) => !a.earned)
                    .map((a) => _AchievementCard(achievement: a)),
              ],
            ],
          ),
        );
      },
    );
  }

  List<_Achievement> _buildAchievements(List records) {
    final total = records.length;
    final greenCount = records
        .where((r) => r.analysis.level == EcoScoreLevel.green)
        .length;

    return [
      _Achievement(
        emoji: '🌱',
        title: 'Bắt đầu hành trình',
        description: 'Quét sản phẩm đầu tiên',
        earned: total >= 1,
        progress: total >= 1 ? 1.0 : total / 1,
        progressLabel: '$total/1',
      ),
      _Achievement(
        emoji: '🔍',
        title: 'Nhà nghiên cứu',
        description: 'Quét 10 sản phẩm',
        earned: total >= 10,
        progress: (total / 10).clamp(0.0, 1.0),
        progressLabel: '$total/10',
      ),
      _Achievement(
        emoji: '🏆',
        title: 'Chuyên gia tiêu dùng',
        description: 'Quét 50 sản phẩm',
        earned: total >= 50,
        progress: (total / 50).clamp(0.0, 1.0),
        progressLabel: '$total/50',
      ),
      _Achievement(
        emoji: '🌿',
        title: 'Lựa chọn xanh đầu tiên',
        description: 'Quét 1 sản phẩm đạt mức 🟢 Tốt',
        earned: greenCount >= 1,
        progress: greenCount >= 1 ? 1.0 : 0.0,
        progressLabel: '$greenCount/1',
      ),
      _Achievement(
        emoji: '♻️',
        title: 'Người tiêu dùng có ý thức',
        description: 'Quét 10 sản phẩm đạt mức 🟢 Tốt',
        earned: greenCount >= 10,
        progress: (greenCount / 10).clamp(0.0, 1.0),
        progressLabel: '$greenCount/10',
      ),
      _Achievement(
        emoji: '🌍',
        title: 'Chiến binh môi trường',
        description: '50% trở lên sản phẩm đạt mức Tốt (tối thiểu 20 lần quét)',
        earned: total >= 20 && greenCount / total >= 0.5,
        progress: total < 20
            ? total / 20
            : (greenCount / total / 0.5).clamp(0.0, 1.0),
        progressLabel: total < 20
            ? '$total/20 quét'
            : '${(greenCount / total * 100).round()}%/50%',
      ),
      _Achievement(
        emoji: '🔬',
        title: 'Thám tử thành phần',
        description: 'Quét 5 sản phẩm bằng OCR',
        earned: records
                .where((r) => r.scanMethod == 'ocr')
                .length >=
            5,
        progress: (records
                    .where((r) => r.scanMethod == 'ocr')
                    .length /
                5)
            .clamp(0.0, 1.0),
        progressLabel:
            '${records.where((r) => r.scanMethod == 'ocr').length}/5',
      ),
    ];
  }
}

class _Achievement {
  final String emoji;
  final String title;
  final String description;
  final bool earned;
  final double progress;
  final String progressLabel;

  const _Achievement({
    required this.emoji,
    required this.title,
    required this.description,
    required this.earned,
    required this.progress,
    required this.progressLabel,
  });
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final color =
        achievement.earned ? AppColors.primary : Colors.grey[400]!;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: achievement.earned
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  achievement.earned ? achievement.emoji : '🔒',
                  style: TextStyle(
                      fontSize: 24,
                      color: achievement.earned ? null : Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(achievement.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: achievement.earned ? null : Colors.grey[500],
                            )),
                      ),
                      if (achievement.earned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Đạt được',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(achievement.description,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                  if (!achievement.earned) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: achievement.progress,
                              minHeight: 4,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(achievement.progressLabel,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
