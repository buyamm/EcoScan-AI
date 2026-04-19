import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../blocs/history/history_cubit.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class PersonalInsightScreen extends StatelessWidget {
  const PersonalInsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        return BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, historyState) {
            final profile = profileState.profile;
            final records = historyState.allRecords;
            final insights = _generateInsights(profile, records);

            return Scaffold(
              appBar: AppBar(title: const Text('Insight cá nhân')),
              body: records.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.insights_outlined,
                      title: 'Chưa có đủ dữ liệu',
                      description:
                          'Quét một số sản phẩm để xem insight cá nhân của bạn',
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💡',
                                  style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              Text(
                                profile.displayName.isNotEmpty
                                    ? 'Insight của ${profile.displayName}'
                                    : 'Insight của bạn',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Dựa trên ${records.length} sản phẩm đã quét',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Insights
                        const SectionHeader(title: 'Phân tích hành vi'),
                        ...insights
                            .map((i) => _InsightCard(insight: i))
                            .toList(),
                        const SizedBox(height: 16),

                        // Quick stats
                        const SectionHeader(title: 'Thống kê nhanh'),
                        _QuickStatsGrid(records: records, profile: profile),
                        const SizedBox(height: 20),

                        // Actions
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                context.push('/profile/recommendations'),
                            icon: const Icon(Icons.thumb_up_outlined),
                            label: const Text('Xem gợi ý cải thiện'),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  List<_Insight> _generateInsights(
      dynamic profile, List<dynamic> records) {
    if (records.isEmpty) return [];
    final insights = <_Insight>[];

    final greenCount =
        records.where((r) => r.analysis.level == EcoScoreLevel.green).length;
    final greenPct = greenCount / records.length;

    if (greenPct >= 0.7) {
      insights.add(_Insight(
        emoji: '🌟',
        title: 'Bạn đang tiêu dùng rất có ý thức!',
        detail: '${(greenPct * 100).round()}% sản phẩm bạn chọn đạt mức Tốt.',
        color: AppColors.primary,
      ));
    } else if (greenPct < 0.3) {
      insights.add(_Insight(
        emoji: '📈',
        title: 'Có nhiều chỗ để cải thiện',
        detail:
            'Chỉ ${(greenPct * 100).round()}% sản phẩm đạt mức Tốt. Hãy thử tìm sản phẩm thay thế.',
        color: AppColors.warning,
      ));
    }

    // Allergen insight
    if (profile.allAllergies.isNotEmpty) {
      final allergenWarnings = records.where((r) {
        final ingredientNames =
            r.analysis.ingredients.map((i) => i.name.toLowerCase()).join(' ');
        return profile.allAllergies
            .any((a) => ingredientNames.contains(a.toLowerCase()));
      }).length;
      if (allergenWarnings > 0) {
        insights.add(_Insight(
          emoji: '⚠️',
          title: '$allergenWarnings sản phẩm có chứa chất dị ứng của bạn',
          detail: 'Hãy kiểm tra kỹ các sản phẩm này và tìm lựa chọn thay thế.',
          color: AppColors.danger,
        ));
      }
    }

    // Frequency insight
    insights.add(_Insight(
      emoji: '📊',
      title: 'Bạn đã quét ${records.length} sản phẩm',
      detail: records.length >= 10
          ? 'Tuyệt vời! Bạn đang xây dựng thói quen tiêu dùng có ý thức.'
          : 'Hãy tiếp tục quét để có insight chính xác hơn.',
      color: AppColors.primary,
    ));

    return insights;
  }
}

class _Insight {
  final String emoji;
  final String title;
  final String detail;
  final Color color;

  const _Insight({
    required this.emoji,
    required this.title,
    required this.detail,
    required this.color,
  });
}

class _InsightCard extends StatelessWidget {
  final _Insight insight;
  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: insight.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(insight.emoji,
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(insight.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(insight.detail,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsGrid extends StatelessWidget {
  final List records;
  final dynamic profile;

  const _QuickStatsGrid({required this.records, required this.profile});

  @override
  Widget build(BuildContext context) {
    final avgScore = records.isEmpty
        ? 0
        : records.fold<int>(0, (s, r) => s + (r.analysis.overallScore as int)) ~/
            records.length;
    final greenCount = records
        .where((r) => r.analysis.level == EcoScoreLevel.green)
        .length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        _MiniStat(
            label: 'Điểm TB', value: '$avgScore', color: AppColors.primary),
        _MiniStat(
            label: '🟢 Tốt', value: '$greenCount', color: AppColors.primary),
        _MiniStat(
            label: 'Dị ứng',
            value: '${profile.allAllergies.length}',
            color: AppColors.danger),
        _MiniStat(
            label: 'Lối sống',
            value: '${profile.lifestyle.length}',
            color: AppColors.secondary),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
