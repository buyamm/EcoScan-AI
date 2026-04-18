import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/scan_record.dart';
import '../blocs/history/history_cubit.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  int? _touchedSpotIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final weekData = _buildWeekData(state.allRecords);
        final hasData = weekData.any((w) => w.count > 0);

        return Scaffold(
          appBar: AppBar(title: const Text('Báo cáo tháng')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Điểm trung bình theo tuần (4 tuần gần nhất)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 240,
                child: !hasData
                    ? Center(
                        child: Text(
                          'Chưa có dữ liệu để hiển thị',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14),
                        ),
                      )
                    : LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (_) => Colors.black87,
                              getTooltipItems: (spots) {
                                return spots.map((spot) {
                                  final idx = spot.spotIndex;
                                  final w = weekData[idx];
                                  return LineTooltipItem(
                                    '${w.label}\nĐiểm TB: ${w.avgScore}\n${w.count} lần quét',
                                    const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  );
                                }).toList();
                              },
                            ),
                            touchCallback: (event, response) {
                              setState(() {
                                _touchedSpotIndex = response
                                    ?.lineBarSpots?.first.spotIndex;
                              });
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: weekData.asMap().entries.map((e) {
                                return FlSpot(
                                  e.key.toDouble(),
                                  e.value.avgScore.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primary.withOpacity(0.12),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  final isTouched =
                                      _touchedSpotIndex == index;
                                  return FlDotCirclePainter(
                                    radius: isTouched ? 7 : 5,
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                          minY: 0,
                          maxY: 100,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= weekData.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      weekData[idx].shortLabel,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 25,
                                getTitlesWidget: (v, meta) {
                                  if (v == meta.max) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    v.toInt().toString(),
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
              const SizedBox(height: 24),
              const Text('4 tuần gần nhất',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _WeekTable(weekData: weekData),
            ],
          ),
        );
      },
    );
  }

  /// Builds data for the last 4 weeks (week 0 = oldest, week 3 = current).
  List<_WeekData> _buildWeekData(List<ScanRecord> records) {
    final now = DateTime.now();
    return List.generate(4, (i) {
      // week 0 = 3 weeks ago, week 3 = current week
      final weeksAgo = 3 - i;
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + weeksAgo * 7));
      final weekEnd = weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final weekRecords = records.where((r) {
        return r.scannedAt.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
            r.scannedAt.isBefore(weekEnd.add(const Duration(seconds: 1)));
      }).toList();

      final count = weekRecords.length;
      final avgScore = count > 0
          ? (weekRecords
                      .map((r) => r.analysis.overallScore)
                      .reduce((a, b) => a + b) /
                  count)
              .round()
          : 0;

      final label =
          '${weekStart.day}/${weekStart.month} - ${weekEnd.day}/${weekEnd.month}';
      final shortLabel = 'T${i + 1}';

      return _WeekData(
        label: label,
        shortLabel: shortLabel,
        count: count,
        avgScore: avgScore,
      );
    });
  }
}

class _WeekData {
  final String label;
  final String shortLabel;
  final int count;
  final int avgScore;

  const _WeekData({
    required this.label,
    required this.shortLabel,
    required this.count,
    required this.avgScore,
  });
}

class _WeekTable extends StatelessWidget {
  final List<_WeekData> weekData;

  const _WeekTable({required this.weekData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: weekData.asMap().entries.map((e) {
        final w = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  w.shortLabel,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(w.label,
                    style: const TextStyle(fontSize: 13)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${w.count} lần quét',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                  Text('Điểm TB: ${w.avgScore}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
