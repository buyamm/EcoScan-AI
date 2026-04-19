import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';
import '../widgets/eco_score_chip.dart';

class ScoreHistoryScreen extends StatelessWidget {
  const ScoreHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final records = state.allRecords;
        return Scaffold(
          appBar: AppBar(title: const Text('Lịch sử điểm số')),
          body: records.isEmpty
              ? Center(
                  child: Text('Chưa có lịch sử.',
                      style: TextStyle(color: Colors.grey[500])),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  itemCount: records.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final r = records[index];
                    final color = _colorFor(r.analysis.level);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.15),
                        child: Text(
                          '${r.analysis.overallScore}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      title: Text(
                        r.product.name.isNotEmpty
                            ? r.product.name
                            : 'Sản phẩm không tên',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _formatDate(r.scannedAt),
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[500]),
                      ),
                      trailing: EcoScoreChip(level: r.analysis.level),
                      onTap: () =>
                          context.push('/history/detail', extra: r),
                    );
                  },
                ),
        );
      },
    );
  }

  Color _colorFor(EcoScoreLevel level) {
    switch (level) {
      case EcoScoreLevel.green:
        return AppColors.primary;
      case EcoScoreLevel.yellow:
        return AppColors.warning;
      case EcoScoreLevel.red:
        return AppColors.danger;
    }
  }

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}
