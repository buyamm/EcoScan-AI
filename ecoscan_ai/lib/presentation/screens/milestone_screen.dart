import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';

class MilestoneScreen extends StatelessWidget {
  const MilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final total = state.allRecords.length;
        final greenCount = state.allRecords
            .where((r) => r.analysis.level == EcoScoreLevel.green)
            .length;
        final milestones = _buildMilestones(total, greenCount);

        return Scaffold(
          appBar: AppBar(title: const Text('Cột mốc')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Hành trình tiêu dùng có trách nhiệm của bạn',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ...milestones.asMap().entries.map((entry) {
                final index = entry.key;
                final milestone = entry.value;
                return _MilestoneItem(
                  milestone: milestone,
                  isLast: index == milestones.length - 1,
                );
              }),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push('/achievements'),
                icon: const Icon(Icons.emoji_events_outlined),
                label: const Text('Xem tất cả thành tích'),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        );
      },
    );
  }

  List<_Milestone> _buildMilestones(int total, int greenCount) {
    return [
      _Milestone(
        title: 'Lần quét đầu tiên',
        description: 'Bắt đầu hành trình xanh',
        emoji: '🌱',
        reached: total >= 1,
        target: 1,
        current: total,
      ),
      _Milestone(
        title: '10 lần quét',
        description: 'Người khám phá',
        emoji: '🔍',
        reached: total >= 10,
        target: 10,
        current: total,
      ),
      _Milestone(
        title: '5 sản phẩm xanh',
        description: 'Người tiêu dùng có ý thức',
        emoji: '🌿',
        reached: greenCount >= 5,
        target: 5,
        current: greenCount,
      ),
      _Milestone(
        title: '50 lần quét',
        description: 'Chuyên gia EcoScan',
        emoji: '🏆',
        reached: total >= 50,
        target: 50,
        current: total,
      ),
      _Milestone(
        title: '20 sản phẩm xanh',
        description: 'Chiến binh môi trường',
        emoji: '🌍',
        reached: greenCount >= 20,
        target: 20,
        current: greenCount,
      ),
    ];
  }
}

class _Milestone {
  final String title;
  final String description;
  final String emoji;
  final bool reached;
  final int target;
  final int current;

  const _Milestone({
    required this.title,
    required this.description,
    required this.emoji,
    required this.reached,
    required this.target,
    required this.current,
  });
}

class _MilestoneItem extends StatelessWidget {
  final _Milestone milestone;
  final bool isLast;

  const _MilestoneItem(
      {required this.milestone, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color =
        milestone.reached ? AppColors.primary : Colors.grey[300]!;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: milestone.reached
                      ? AppColors.primary
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(milestone.emoji,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    milestone.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: milestone.reached
                          ? null
                          : Colors.grey[500],
                    ),
                  ),
                  Text(
                    milestone.description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500]),
                  ),
                  if (!milestone.reached) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (milestone.current / milestone.target)
                            .clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[200],
                        color: AppColors.secondary,
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${milestone.current}/${milestone.target}',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
