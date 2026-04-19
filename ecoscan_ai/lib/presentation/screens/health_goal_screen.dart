import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/history/history_cubit.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class HealthGoalScreen extends StatelessWidget {
  const HealthGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        final avgHealth = records.isEmpty
            ? 0
            : (records.fold<int>(0, (sum, r) => sum + r.analysis.health.score) ~/
                records.length);

        return Scaffold(
          appBar: AppBar(title: const Text('Mục tiêu sức khỏe')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[700]!, Colors.orange[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('❤️', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    const Text(
                      'Mục tiêu sức khỏe',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Theo dõi và cải thiện điểm sức khỏe của các sản phẩm bạn tiêu dùng',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Current stats
              const SectionHeader(title: 'Trạng thái hiện tại'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ScoreGauge(score: avgHealth, size: 80, label: 'Sức khỏe'),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Điểm sức khỏe trung bình',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 6),
                            Text(
                              records.isEmpty
                                  ? 'Chưa có dữ liệu — hãy quét sản phẩm đầu tiên'
                                  : 'Dựa trên ${records.length} sản phẩm đã quét',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Goals
              const SectionHeader(title: 'Mục tiêu gợi ý'),
              _GoalCard(
                emoji: '🎯',
                title: 'Điểm sức khỏe ≥ 70',
                description:
                    'Cố gắng chọn sản phẩm có điểm sức khỏe từ 70 trở lên',
                progress: avgHealth / 70,
                current: '$avgHealth',
                target: '70',
              ),
              _GoalCard(
                emoji: '🚫',
                title: 'Tránh thành phần nguy hiểm',
                description:
                    'Hạn chế sản phẩm có thành phần đánh giá "Cần tránh"',
                progress: records.isEmpty
                    ? 0
                    : 1 -
                        (records
                            .where((r) => r.analysis.ingredients.any(
                                (i) => i.safety == IngredientSafety.avoid))
                            .length /
                        records.length),
                current:
                    '${records.isEmpty ? 0 : records.where((r) => !r.analysis.ingredients.any((i) => i.safety == IngredientSafety.avoid)).length}',
                target: '${records.length}',
              ),
              const SizedBox(height: 20),

              // Tips
              const SectionHeader(title: 'Lời khuyên'),
              Card(
                color: AppColors.primary.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      '🥤 Ưu tiên sản phẩm ít phụ gia và chất bảo quản',
                      '🌾 Chọn nguyên liệu tự nhiên, ít qua chế biến',
                      '📋 Đọc kỹ thành phần trước khi mua',
                      '🔍 So sánh sản phẩm cùng loại để chọn lành mạnh hơn',
                    ]
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.split(' ')[0],
                                      style:
                                          const TextStyle(fontSize: 16)),
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
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Quét sản phẩm ngay'),
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

class _GoalCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final double progress;
  final String current;
  final String target;

  const _GoalCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.progress,
    required this.current,
    required this.target,
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
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14))),
                Text('$current/$target',
                    style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
