import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/history/history_cubit.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class EcoGoalScreen extends StatelessWidget {
  const EcoGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        final greenCount = records
            .where((r) => r.analysis.level == EcoScoreLevel.green)
            .length;
        final greenPct =
            records.isEmpty ? 0.0 : greenCount / records.length;
        final avgEnv = records.isEmpty
            ? 0
            : records.fold<int>(
                    0, (s, r) => s + r.analysis.environment.score) ~/
                records.length;

        return Scaffold(
          appBar: AppBar(title: const Text('Mục tiêu môi trường')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🌍', style: TextStyle(fontSize: 36)),
                    SizedBox(height: 8),
                    Text(
                      'Mục tiêu môi trường',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Theo dõi tác động môi trường của thói quen tiêu dùng',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      emoji: '🟢',
                      label: 'Sản phẩm xanh',
                      value: '$greenCount',
                      subtitle: records.isEmpty
                          ? '-'
                          : '${(greenPct * 100).round()}% tổng quét',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      emoji: '🌿',
                      label: 'Điểm môi trường TB',
                      value: '$avgEnv',
                      subtitle: 'Trên thang 100',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: 'Mục tiêu'),
              _GoalProgress(
                emoji: '🎯',
                title: '50% sản phẩm xanh',
                desc: 'Hướng đến 50% sản phẩm đạt mức 🟢 Tốt',
                progress: greenPct / 0.5,
                label: '${(greenPct * 100).round()}% / 50%',
              ),
              _GoalProgress(
                emoji: '📈',
                title: 'Điểm môi trường ≥ 60',
                desc: 'Nâng điểm môi trường trung bình lên 60+',
                progress: avgEnv / 60,
                label: '$avgEnv / 60',
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: 'Cách cải thiện'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      '♻️ Ưu tiên sản phẩm có bao bì tái chế được',
                      '🌱 Chọn thành phần phân hủy sinh học',
                      '🚫 Tránh sản phẩm chứa vi nhựa (microbeads)',
                      '🏷️ Tìm chứng nhận eco (FSC, EU Ecolabel,...)',
                      '🔄 So sánh sản phẩm thay thế eco hơn',
                    ]
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.split(' ')[0],
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      t.substring(t.indexOf(' ') + 1),
                                      style: const TextStyle(
                                          fontSize: 13, height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/scan'),
                  icon: const Icon(Icons.eco_outlined),
                  label: const Text('Quét sản phẩm'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            Text(label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class _GoalProgress extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;
  final double progress;
  final String label;

  const _GoalProgress({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.progress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final color = clamped >= 1.0
        ? AppColors.primary
        : clamped >= 0.5
            ? AppColors.warning
            : AppColors.danger;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14))),
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: clamped,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
