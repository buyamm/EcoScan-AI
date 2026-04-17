import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';

class CategoryBreakdownScreen extends StatelessWidget {
  const CategoryBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final categoryMap = _buildCategoryMap(state.allRecords);

        return Scaffold(
          appBar: AppBar(title: const Text('Phân tích theo danh mục')),
          body: categoryMap.isEmpty
              ? Center(
                  child: Text('Chưa có dữ liệu.',
                      style: TextStyle(color: Colors.grey[500])),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: categoryMap.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final entry =
                        categoryMap.entries.elementAt(index);
                    final category = entry.key;
                    final stats = entry.value;
                    return _CategoryCard(
                        category: category, stats: stats);
                  },
                ),
        );
      },
    );
  }

  Map<String, _CategoryStats> _buildCategoryMap(records) {
    final map = <String, _CategoryStats>{};
    for (final r in records) {
      final cat = r.product.category?.isNotEmpty == true
          ? _cleanCategory(r.product.category!)
          : 'Khác';
      map.putIfAbsent(cat, () => _CategoryStats());
      map[cat]!.total++;
      switch (r.analysis.level) {
        case EcoScoreLevel.green:
          map[cat]!.green++;
          break;
        case EcoScoreLevel.yellow:
          map[cat]!.yellow++;
          break;
        case EcoScoreLevel.red:
          map[cat]!.red++;
          break;
      }
      map[cat]!.totalScore += r.analysis.overallScore as int;
    }
    // Sort by total descending
    final sorted = Map.fromEntries(map.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total)));
    return sorted;
  }

  String _cleanCategory(String raw) {
    // e.g. "en:beverages" → "Beverages"
    final parts = raw.split(':');
    final clean = parts.last.replaceAll('-', ' ');
    return clean[0].toUpperCase() + clean.substring(1);
  }
}

class _CategoryStats {
  int total = 0;
  int green = 0;
  int yellow = 0;
  int red = 0;
  int totalScore = 0;

  int get avgScore => total > 0 ? (totalScore / total).round() : 0;
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final _CategoryStats stats;

  const _CategoryCard({required this.category, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(category,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Text('${stats.total} sản phẩm',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _ScoreDot(
                    color: AppColors.primary,
                    label: '🟢 ${stats.green}'),
                const SizedBox(width: 12),
                _ScoreDot(
                    color: AppColors.warning,
                    label: '🟡 ${stats.yellow}'),
                const SizedBox(width: 12),
                _ScoreDot(
                    color: AppColors.danger,
                    label: '🔴 ${stats.red}'),
                const Spacer(),
                Text('TB: ${stats.avgScore}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreDot extends StatelessWidget {
  final Color color;
  final String label;

  const _ScoreDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
                color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
