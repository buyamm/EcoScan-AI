import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../blocs/history/history_cubit.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        return BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, historyState) {
            final profile = profileState.profile;
            final records = historyState.allRecords;
            final recommendations =
                _buildRecommendations(profile, records);

            return Scaffold(
              appBar: AppBar(title: const Text('Gợi ý cải thiện')),
              body: records.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.tips_and_updates_outlined,
                      title: 'Chưa có gợi ý',
                      description:
                          'Quét một số sản phẩm để nhận gợi ý cải thiện từ AI',
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text('🤖',
                                  style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Gợi ý dựa trên ${records.length} sản phẩm đã quét và hồ sơ của bạn',
                                  style: const TextStyle(
                                      fontSize: 13, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SectionHeader(title: 'Gợi ý cho bạn'),
                        ...recommendations.map((r) => _RecCard(rec: r)),
                        const SizedBox(height: 16),
                        ..._buildWorstSection(context, records),
                        SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildWorstSection(BuildContext context, List records) {
    final worstProducts = records
        .where((r) => r.analysis.level == EcoScoreLevel.red)
        .take(3)
        .toList();
    if (worstProducts.isEmpty) return [];
    return [
      const SectionHeader(title: 'Sản phẩm cần thay thế'),
      ...worstProducts.map((r) => ProductListTile.fromScanRecord(
            r,
            onTap: () => context.push('/history/detail', extra: r),
          )),
    ];
  }

  List<_Recommendation> _buildRecommendations(
      dynamic profile, List records) {
    final recs = <_Recommendation>[];
    if (records.isEmpty) return recs;

    final greenCount =
        records.where((r) => r.analysis.level == EcoScoreLevel.green).length;
    final greenPct = greenCount / records.length;

    if (greenPct < 0.5) {
      recs.add(const _Recommendation(
        emoji: '🔄',
        title: 'Thay thế sản phẩm kém bền vững',
        detail:
            'Hơn 50% sản phẩm bạn dùng không đạt mức Tốt. Hãy xem gợi ý sản phẩm thay thế khi quét.',
        action: 'Xem sản phẩm thay thế',
        route: '/scan',
      ));
    }

    if (profile.lifestyle.isEmpty) {
      recs.add(const _Recommendation(
        emoji: '🌿',
        title: 'Thiết lập lối sống',
        detail:
            'Khai báo lối sống để nhận phân tích cá nhân hóa tốt hơn từ AI.',
        action: 'Cập nhật lối sống',
        route: '/profile/lifestyle',
      ));
    }

    recs.add(const _Recommendation(
      emoji: '📖',
      title: 'Đọc thành phần trước khi mua',
      detail:
          'Chú ý đặc biệt đến các thành phần đánh giá "Cần tránh" trong phân tích AI.',
      action: 'Xem hướng dẫn',
      route: '/settings/help',
    ));

    recs.add(const _Recommendation(
      emoji: '🏆',
      title: 'Ưu tiên sản phẩm có chứng nhận',
      detail:
          'Tìm các nhãn chứng nhận uy tín như EU Ecolabel, Fair Trade, Organic khi mua sắm.',
      action: null,
      route: null,
    ));

    return recs;
  }
}

class _Recommendation {
  final String emoji;
  final String title;
  final String detail;
  final String? action;
  final String? route;

  const _Recommendation({
    required this.emoji,
    required this.title,
    required this.detail,
    required this.action,
    required this.route,
  });
}

class _RecCard extends StatelessWidget {
  final _Recommendation rec;
  const _RecCard({required this.rec});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(rec.emoji,
                          style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rec.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(rec.detail,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
            if (rec.action != null && rec.route != null) ...[
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6)),
                onPressed: () => context.push(rec.route!),
                child: Text(rec.action!,
                    style: const TextStyle(fontSize: 13)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
