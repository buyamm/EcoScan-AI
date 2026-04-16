import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/history/history_cubit.dart';
import '../../data/models/scan_record.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final spots = _buildMonthlySpots(state.allRecords);
        return Scaffold(
          appBar: AppBar(title: const Text('Báo cáo tháng')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Điểm trung bình theo ngày trong tháng này',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: spots.isEmpty
                    ? Center(
                        child: Text(
                          'Chưa có dữ liệu tháng này',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14),
                        ),
                      )
                    : LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 2.5,
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primary.withOpacity(0.1),
                              ),
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                          minY: 0,
                          maxY: 100,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 7,
                                getTitlesWidget: (v, meta) => Text(
                                  'N${v.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: 25,
                                getTitlesWidget: (v, meta) => Text(
                                  v.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(
                              show: true, drawVerticalLine: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              _MonthStats(records: state.allRecords),
            ],
          ),
        );
      },
    );
  }

  List<FlSpot> _buildMonthlySpots(List<ScanRecord> records) {
    final now = DateTime.now();
    // Group records by day of the current month, compute avg score per day
    final Map<int, List<int>> dayScores = {};
    for (final r in records) {
      if (r.scannedAt.year == now.year && r.scannedAt.month == now.month) {
        dayScores.putIfAbsent(r.scannedAt.day, () => []);
        dayScores[r.scannedAt.day]!.add(r.analysis.overallScore);
      }
    }
    if (dayScores.isEmpty) return [];
    return dayScores.entries.map((e) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return FlSpot(e.key.toDouble(), avg);
    }).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }
}

class _MonthStats extends StatelessWidget {
  final List<ScanRecord> records;

  const _MonthStats({required this.records});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final thisMonth = records
        .where((r) =>
            r.scannedAt.year == now.year &&
            r.scannedAt.month == now.month)
        .toList();
    final total = thisMonth.length;
    final avg = total > 0
        ? (thisMonth
                    .map((r) => r.analysis.overallScore)
                    .reduce((a, b) => a + b) /
                total)
            .round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tháng này',
            style:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            _Chip(value: '$total', label: 'Lần quét'),
            const SizedBox(width: 10),
            _Chip(value: '$avg', label: 'Điểm TB'),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String value;
  final String label;

  const _Chip({required this.value, required this.label});

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
                style:
                    TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
