import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/scan_record.dart';
import '../blocs/history/history_cubit.dart';

class EcoTrendScreen extends StatelessWidget {
  const EcoTrendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        final spots = _buildTrendSpots(records);

        return Scaffold(
          appBar: AppBar(title: const Text('Xu hướng xanh')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Điểm Eco trung bình theo thời gian (30 lần quét gần nhất)',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              if (spots.length < 2)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    'Cần ít nhất 2 lần quét để hiển thị xu hướng',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: LineChart(
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
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, pct, bar, idx) =>
                                FlDotCirclePainter(
                              radius: 3,
                              color: AppColors.primary,
                              strokeWidth: 0,
                            ),
                          ),
                        ),
                        // Threshold lines
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 70),
                            FlSpot(spots.last.x, 70)
                          ],
                          color: AppColors.primary.withOpacity(0.3),
                          barWidth: 1,
                          dashArray: [4, 4],
                          dotData: const FlDotData(show: false),
                        ),
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 40),
                            FlSpot(spots.last.x, 40)
                          ],
                          color: AppColors.danger.withOpacity(0.3),
                          barWidth: 1,
                          dashArray: [4, 4],
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      minY: 0,
                      maxY: 100,
                      titlesData: FlTitlesData(
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
                        bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
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
              _TrendLegend(),
              const SizedBox(height: 20),
              _TrendInsight(records: records),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
            ],
          ),
        );
      },
    );
  }

  List<FlSpot> _buildTrendSpots(List<ScanRecord> records) {
    final recent = records.take(30).toList().reversed.toList();
    return recent.asMap().entries
        .map((e) =>
            FlSpot(e.key.toDouble(), e.value.analysis.overallScore.toDouble()))
        .toList();
  }
}

class _TrendLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendItem(
            color: AppColors.primary.withOpacity(0.4),
            label: '≥70: Tốt'),
        const SizedBox(width: 16),
        _LegendItem(
            color: AppColors.danger.withOpacity(0.4),
            label: '<40: Kém'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 2,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(label,
            style:
                TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

class _TrendInsight extends StatelessWidget {
  final List<ScanRecord> records;

  const _TrendInsight({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.length < 5) return const SizedBox.shrink();

    final recent5 = records.take(5).toList();
    final older5 = records.skip(5).take(5).toList();
    if (older5.isEmpty) return const SizedBox.shrink();

    final recentAvg =
        recent5.map((r) => r.analysis.overallScore).reduce((a, b) => a + b) /
            5;
    final olderAvg =
        older5.map((r) => r.analysis.overallScore).reduce((a, b) => a + b) /
            5;
    final diff = (recentAvg - olderAvg).round();
    final improving = diff > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (improving ? AppColors.primary : AppColors.warning)
            .withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (improving ? AppColors.primary : AppColors.warning)
              .withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(improving ? '📈' : '📉',
              style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              improving
                  ? 'Xu hướng cải thiện! Điểm tăng ${diff.abs()} điểm so với trước.'
                  : 'Điểm giảm ${diff.abs()} điểm so với trước. Hãy chú ý hơn.',
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
