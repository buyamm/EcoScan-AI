import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/history/history_cubit.dart';
import '../widgets/eco_score_chip.dart';

class WorstProductsScreen extends StatelessWidget {
  const WorstProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final sorted = [...state.allRecords]
          ..sort((a, b) =>
              a.analysis.overallScore.compareTo(b.analysis.overallScore));
        final worst = sorted.take(5).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Sản phẩm kém nhất')),
          body: worst.isEmpty
              ? Center(
                  child: Text('Chưa có dữ liệu.',
                      style: TextStyle(color: Colors.grey[500])),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.warning.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Text('⚠️', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Những sản phẩm này có điểm thấp nhất. Hãy xem xét lựa chọn thay thế.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        itemCount: worst.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final r = worst[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.danger.withOpacity(0.1),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
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
                                    fontSize: 12,
                                    color: Colors.grey[600]),
                              ),
                              trailing: EcoScoreChip(
                                level: r.analysis.level,
                                score: r.analysis.overallScore,
                                showScore: true,
                              ),
                              onTap: () => context
                                  .push('/history/detail', extra: r),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
