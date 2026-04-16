import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final weeklyData = _buildWeeklyData(state.allRecords);
        return Scaffold(
          appBar: AppBar(title: const Text('Báo cáo tuần')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Số lần quét theo ngày trong tuần này',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: _maxY(weeklyData),
                    barGroups: weeklyData.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.toDouble(),
                            color: AppColors.primary,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'
                            ];
                            return Text(
                              days[value.toInt() % 7],
                              style: const TextStyle(fontSize: 11),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(
                        show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Tổng tuần này',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _WeekSummaryRow(data: weeklyData),
            ],
          ),
        );
      },
    );
  }

  // Returns scan counts per day of the current week [Mon..Sun]
  List<int> _buildWeeklyData(records) {
    final now = DateTime.now();
    final startOfWeek =
        now.subtract(Duration(days: now.weekday - 1));
    final counts = List<int>.filled(7, 0);
    for (final r in records) {
      final diff =
          r.scannedAt.difference(startOfWeek).inDays;
      if (diff >= 0 && diff < 7) {
        counts[diff]++;
      }
    }
    return counts;
  }

  double _maxY(List<int> data) {
    final max = data.isEmpty ? 1 : data.reduce((a, b) => a > b ? a : b);
    return (max + 2).toDouble();
  }
}

class _WeekSummaryRow extends StatelessWidget {
  final List<int> data;

  const _WeekSummaryRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.reduce((a, b) => a + b);
    final best = data.reduce((a, b) => a > b ? a : b);
    return Row(
      children: [
        _SummaryChip(label: 'Tổng quét', value: '$total'),
        const SizedBox(width: 10),
        _SummaryChip(label: 'Ngày nhiều nhất', value: '$best'),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
