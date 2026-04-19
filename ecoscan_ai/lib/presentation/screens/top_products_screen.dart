import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/history/history_cubit.dart';
import '../widgets/eco_score_chip.dart';

class TopProductsScreen extends StatelessWidget {
  const TopProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final sorted = [...state.allRecords]
          ..sort((a, b) => b.analysis.overallScore
              .compareTo(a.analysis.overallScore));
        final top = sorted.take(5).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Top sản phẩm tốt nhất')),
          body: top.isEmpty
              ? Center(
                  child: Text('Chưa có dữ liệu.',
                      style: TextStyle(color: Colors.grey[500])),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                    left: 16, right: 16, top: 16,
                    bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  itemCount: top.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final r = top[index];
                    return Card(
                      child: ListTile(
                        leading: _RankBadge(rank: index + 1),
                        title: Text(
                          r.product.name.isNotEmpty
                              ? r.product.name
                              : 'Sản phẩm không tên',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          r.product.brand.isNotEmpty
                              ? r.product.brand
                              : '',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        trailing: EcoScoreChip(
                          level: r.analysis.level,
                          score: r.analysis.overallScore,
                          showScore: true,
                        ),
                        onTap: () =>
                            context.push('/history/detail', extra: r),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;

  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    const medals = ['🥇', '🥈', '🥉'];
    return CircleAvatar(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Text(
        rank <= 3 ? medals[rank - 1] : '$rank',
        style: TextStyle(
          fontSize: rank <= 3 ? 20 : 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
