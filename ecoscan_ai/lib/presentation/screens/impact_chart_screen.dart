import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';

class ImpactChartScreen extends StatelessWidget {
  const ImpactChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        final green =
            records.where((r) => r.analysis.level == EcoScoreLevel.green).length;
        final yellow =
            records.where((r) => r.analysis.level == EcoScoreLevel.yellow).length;
        final red =
            records.where((r) => r.analysis.level == EcoScoreLevel.red).length;
        final total = records.length;

        return Scaffold(
          appBar: AppBar(title: const Text('Biểu đồ phân bổ')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Tỷ lệ sản phẩm theo Eco Score',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              if (total == 0)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('Chưa có dữ liệu để hiển thị.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                )
              else ...[
                SizedBox(
                  height: 240,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        if (green > 0)
                          PieChartSectionData(
                            value: green.toDouble(),
                            color: AppColors.primary,
                            title: '$green',
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                            radius: 80,
                          ),
                        if (yellow > 0)
                          PieChartSectionData(
                            value: yellow.toDouble(),
                            color: AppColors.warning,
                            title: '$yellow',
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                            radius: 80,
                          ),
                        if (red > 0)
                          PieChartSectionData(
                            value: red.toDouble(),
                            color: AppColors.danger,
                            title: '$red',
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                            radius: 80,
                          ),
                      ],
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Legend
                _LegendRow(
                    color: AppColors.primary,
                    label: '🟢 Tốt',
                    count: green,
                    total: total),
                const SizedBox(height: 8),
                _LegendRow(
                    color: AppColors.warning,
                    label: '🟡 Trung bình',
                    count: yellow,
                    total: total),
                const SizedBox(height: 8),
                _LegendRow(
                    color: AppColors.danger,
                    label: '🔴 Kém',
                    count: red,
                    total: total),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int total;

  const _LegendRow(
      {required this.color,
      required this.label,
      required this.count,
      required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (count / total * 100).round() : 0;
    return Row(
      children: [
        Container(
            width: 14, height: 14, color: color,
            margin: const EdgeInsets.only(right: 10)),
        Text(label, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text('$count sản phẩm ($pct%)',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
