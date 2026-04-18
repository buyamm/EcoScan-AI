import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';

class HistoryFilterScreen extends StatefulWidget {
  const HistoryFilterScreen({super.key});

  @override
  State<HistoryFilterScreen> createState() => _HistoryFilterScreenState();
}

class _HistoryFilterScreenState extends State<HistoryFilterScreen> {
  EcoScoreLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = context.read<HistoryCubit>().state.filterLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lọc lịch sử'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _selectedLevel = null);
              context.read<HistoryCubit>().clearFilters();
              context.pop();
            },
            child: const Text('Xóa lọc',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theo mức Eco Score',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _LevelFilterTile(
              emoji: '🟢',
              label: 'Tốt (≥70 điểm)',
              level: EcoScoreLevel.green,
              selected: _selectedLevel == EcoScoreLevel.green,
              color: AppColors.primary,
              onTap: () => setState(
                  () => _selectedLevel = _selectedLevel == EcoScoreLevel.green
                      ? null
                      : EcoScoreLevel.green),
            ),
            const SizedBox(height: 8),
            _LevelFilterTile(
              emoji: '🟡',
              label: 'Trung bình (40–69 điểm)',
              level: EcoScoreLevel.yellow,
              selected: _selectedLevel == EcoScoreLevel.yellow,
              color: AppColors.warning,
              onTap: () => setState(
                  () => _selectedLevel = _selectedLevel == EcoScoreLevel.yellow
                      ? null
                      : EcoScoreLevel.yellow),
            ),
            const SizedBox(height: 8),
            _LevelFilterTile(
              emoji: '🔴',
              label: 'Kém (<40 điểm)',
              level: EcoScoreLevel.red,
              selected: _selectedLevel == EcoScoreLevel.red,
              color: AppColors.danger,
              onTap: () => setState(
                  () => _selectedLevel = _selectedLevel == EcoScoreLevel.red
                      ? null
                      : EcoScoreLevel.red),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<HistoryCubit>()
                      .filterByLevel(_selectedLevel);
                  context.pop();
                },
                child: const Text('Áp dụng'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}

class _LevelFilterTile extends StatelessWidget {
  final String emoji;
  final String label;
  final EcoScoreLevel level;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _LevelFilterTile({
    required this.emoji,
    required this.label,
    required this.level,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.normal,
                  color: selected ? color : null,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
