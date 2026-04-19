import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/scan_record.dart';
import '../blocs/history/history_cubit.dart';

class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final dayData = _buildDayData(state.allRecords);
        return Scaffold(
          appBar: AppBar(title: const Text('Báo cáo tuần')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '7 ngày gần nhất',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 240,
                child: BarChart(
                  BarChartData(
                    maxY: _maxY(dayData),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) =>
                            Colors.black87,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final d = dayData[group.x];
                          final total = d.green + d.yellow + d.red;
                          final avg = total > 0
                              ? (d.scores.reduce((a, b) => a + b) / total)
                                  .round()
                              : 0;
                          return BarTooltipItem(
                            '${d.label}\n$total lần quét\nĐiểm TB: $avg',
                            const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedIndex =
                              response?.spot?.touchedBarGroupIndex;
                        });
                      },
                    ),
                    barGroups: dayData.asMap().entries.map((e) {
                      final i = e.key;
                      final d = e.value;
                      final isTouched = _touchedIndex == i;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (d.green + d.yellow + d.red).toDouble(),
                            width: isTouched ? 22 : 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                            rodStackItems: [
                              BarChartRodStackItem(
                                  0,
                                  d.red.toDouble(),
                                  AppColors.danger),
                              BarChartRodStackItem(
                                  d.red.toDouble(),
                                  (d.red + d.yellow).toDouble(),
                                  AppColors.warning),
                              BarChartRodStackItem(
                                  (d.red + d.yellow).toDouble(),
                                  (d.red + d.yellow + d.green).toDouble(),
                                  AppColors.primary),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= dayData.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                dayData[idx].shortLabel,
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.max) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
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
              const SizedBox(height: 16),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: AppColors.primary, label: '🟢 Tốt'),
                  const SizedBox(width: 16),
                  _LegendDot(color: AppColors.warning, label: '🟡 TB'),
                  const SizedBox(width: 16),
                  _LegendDot(color: AppColors.danger, label: '🔴 Kém'),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Tổng tuần này',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _WeekSummary(dayData: dayData),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
            ],
          ),
        );
      },
    );
  }

  /// Builds per-day data for the last 7 days (today = day 6).
  List<_DayData> _buildDayData(List<ScanRecord> records) {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final dayRecords = records.where((r) {
        return r.scannedAt.year == day.year &&
            r.scannedAt.month == day.month &&
            r.scannedAt.day == day.day;
      }).toList();

      final green = dayRecords
          .where((r) => r.analysis.level == EcoScoreLevel.green)
          .length;
      final yellow = dayRecords
          .where((r) => r.analysis.level == EcoScoreLevel.yellow)
          .length;
      final red = dayRecords
          .where((r) => r.analysis.level == EcoScoreLevel.red)
          .length;
      final scores =
          dayRecords.map((r) => r.analysis.overallScore).toList();

      const weekdayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      final shortLabel = weekdayLabels[day.weekday - 1];
      final label =
          '${day.day}/${day.month}';

      return _DayData(
        label: label,
        shortLabel: shortLabel,
        green: green,
        yellow: yellow,
        red: red,
        scores: scores,
      );
    });
  }

  double _maxY(List<_DayData> data) {
    final max = data.isEmpty
        ? 1
        : data
            .map((d) => d.green + d.yellow + d.red)
            .reduce((a, b) => a > b ? a : b);
    return (max + 2).toDouble();
  }
}

class _DayData {
  final String label;
  final String shortLabel;
  final int green;
  final int yellow;
  final int red;
  final List<int> scores;

  const _DayData({
    required this.label,
    required this.shortLabel,
    required this.green,
    required this.yellow,
    required this.red,
    required this.scores,
  });
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _WeekSummary extends StatelessWidget {
  final List<_DayData> dayData;

  const _WeekSummary({required this.dayData});

  @override
  Widget build(BuildContext context) {
    final total =
        dayData.fold(0, (sum, d) => sum + d.green + d.yellow + d.red);
    final allScores =
        dayData.expand((d) => d.scores).toList();
    final avg = allScores.isNotEmpty
        ? (allScores.reduce((a, b) => a + b) / allScores.length).round()
        : 0;
    final best = dayData
        .map((d) => d.green + d.yellow + d.red)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      children: [
        _SummaryChip(label: 'Tổng quét', value: '$total'),
        const SizedBox(width: 10),
        _SummaryChip(label: 'Điểm TB', value: '$avg'),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
