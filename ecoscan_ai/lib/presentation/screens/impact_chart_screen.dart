import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';
import 'impact_empty_screen.dart';

class ImpactChartScreen extends StatefulWidget {
  const ImpactChartScreen({super.key});

  @override
  State<ImpactChartScreen> createState() => _ImpactChartScreenState();
}

class _ImpactChartScreenState extends State<ImpactChartScreen> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;

        // Requirement 14.5: fewer than 3 records → show empty screen
        if (records.length < 3) {
          return const ImpactEmptyScreen();
        }

        final green = records
            .where((r) => r.analysis.level == EcoScoreLevel.green)
            .length;
        final yellow = records
            .where((r) => r.analysis.level == EcoScoreLevel.yellow)
            .length;
        final red = records
            .where((r) => r.analysis.level == EcoScoreLevel.red)
            .length;
        final total = records.length;

        final sections = <_PieSection>[
          _PieSection(
              label: '🟢 Tốt',
              count: green,
              color: AppColors.primary),
          _PieSection(
              label: '🟡 Trung bình',
              count: yellow,
              color: AppColors.warning),
          _PieSection(
              label: '🔴 Kém',
              count: red,
              color: AppColors.danger),
        ].where((s) => s.count > 0).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Biểu đồ phân bổ')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Tỷ lệ sản phẩm theo Eco Score (tổng $total sản phẩm)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 260,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedIndex =
                              response?.touchedSection?.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: sections.asMap().entries.map((e) {
                      final i = e.key;
                      final s = e.value;
                      final isTouched = _touchedIndex == i;
                      final pct = (s.count / total * 100).round();
                      return PieChartSectionData(
                        value: s.count.toDouble(),
                        color: s.color,
                        title: isTouched ? '$pct%' : '${s.count}',
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: isTouched ? 16 : 13,
                        ),
                        radius: isTouched ? 90 : 80,
                        badgeWidget: isTouched
                            ? _TooltipBadge(
                                label: s.label,
                                count: s.count,
                                pct: pct,
                              )
                            : null,
                        badgePositionPercentageOffset: 1.3,
                      );
                    }).toList(),
                    sectionsSpace: 3,
                    centerSpaceRadius: 48,
                    centerSpaceColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Phân bổ chi tiết',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...sections.map((s) => _LegendRow(
                    color: s.color,
                    label: s.label,
                    count: s.count,
                    total: total,
                  )),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
            ],
          ),
        );
      },
    );
  }
}

class _PieSection {
  final String label;
  final int count;
  final Color color;

  const _PieSection(
      {required this.label, required this.count, required this.color});
}

class _TooltipBadge extends StatelessWidget {
  final String label;
  final int count;
  final int pct;

  const _TooltipBadge(
      {required this.label, required this.count, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label\n$count sp ($pct%)',
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 11, height: 1.4),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int total;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (count / total * 100).round() : 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 10),
          ),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(
            '$count sản phẩm  •  $pct%',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color),
          ),
        ],
      ),
    );
  }
}
