import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../blocs/history/history_cubit.dart';
import '../widgets/eco_score_chip.dart';

class PersonalImpactScreen extends StatelessWidget {
  const PersonalImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state.isEmpty) {
          return const ImpactEmptyScreen(embedded: true);
        }
        final records = state.allRecords;
        final total = records.length;
        final greenCount =
            records.where((r) => r.analysis.level == EcoScoreLevel.green).length;
        final yellowCount =
            records.where((r) => r.analysis.level == EcoScoreLevel.yellow).length;
        final redCount =
            records.where((r) => r.analysis.level == EcoScoreLevel.red).length;
        final avgScore = total > 0
            ? (records.map((r) => r.analysis.overallScore).reduce((a, b) => a + b) /
                total)
                .round()
            : 0;

        // Green streak: consecutive most-recent green records
        int streak = 0;
        for (final r in records) {
          if (r.analysis.level == EcoScoreLevel.green) {
            streak++;
          } else {
            break;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tác động cá nhân'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () => context.push('/impact/share', extra: {
                  'total': total,
                  'green': greenCount,
                  'yellow': yellowCount,
                  'red': redCount,
                  'avgScore': avgScore,
                }),
                tooltip: 'Chia sẻ',
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => context.read<HistoryCubit>().loadHistory(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary banner
                _SummaryBanner(
                    total: total, avgScore: avgScore, streak: streak),
                const SizedBox(height: 16),
                // Score distribution
                const Text('Phân bổ Eco Score',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _StatCard(
                        value: '$greenCount',
                        label: '🟢 Tốt',
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    _StatCard(
                        value: '$yellowCount',
                        label: '🟡 Trung bình',
                        color: AppColors.warning),
                    const SizedBox(width: 8),
                    _StatCard(
                        value: '$redCount',
                        label: '🔴 Kém',
                        color: AppColors.danger),
                  ],
                ),
                const SizedBox(height: 16),
                // Navigation to detailed charts
                const Text('Phân tích chi tiết',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                _NavTile(
                  icon: Icons.bar_chart,
                  title: 'Báo cáo theo tuần',
                  subtitle: 'Biểu đồ cột xu hướng quét',
                  onTap: () => context.push('/impact/weekly'),
                ),
                _NavTile(
                  icon: Icons.show_chart,
                  title: 'Báo cáo theo tháng',
                  subtitle: 'Xu hướng điểm số theo tháng',
                  onTap: () => context.push('/impact/monthly'),
                ),
                _NavTile(
                  icon: Icons.pie_chart_outline,
                  title: 'Biểu đồ phân bổ',
                  subtitle: 'Tỷ lệ sản phẩm theo điểm số',
                  onTap: () => context.push('/impact/chart', extra: {
                    'green': greenCount,
                    'yellow': yellowCount,
                    'red': redCount,
                  }),
                ),
                _NavTile(
                  icon: Icons.category_outlined,
                  title: 'Phân tích theo danh mục',
                  subtitle: 'Sản phẩm theo nhóm loại',
                  onTap: () => context.push('/impact/category'),
                ),
                _NavTile(
                  icon: Icons.trending_up,
                  title: 'Xu hướng xanh',
                  subtitle: 'Lộ trình cải thiện tiêu dùng',
                  onTap: () => context.push('/impact/trend'),
                ),
                _NavTile(
                  icon: Icons.history_toggle_off,
                  title: 'Lịch sử điểm số',
                  subtitle: 'Điểm từng lần quét',
                  onTap: () => context.push('/impact/scores'),
                ),
                _NavTile(
                  icon: Icons.star_outline,
                  title: 'Top sản phẩm tốt nhất',
                  subtitle: 'Top 5 sản phẩm điểm cao nhất',
                  onTap: () => context.push('/impact/top'),
                ),
                _NavTile(
                  icon: Icons.warning_amber_outlined,
                  title: 'Sản phẩm kém nhất',
                  subtitle: 'Top 5 sản phẩm cần chú ý',
                  onTap: () => context.push('/impact/worst'),
                ),
                _NavTile(
                  icon: Icons.emoji_events_outlined,
                  title: 'Thành tích',
                  subtitle: 'Huy hiệu và cột mốc đạt được',
                  onTap: () => context.push('/achievements'),
                ),
                _NavTile(
                  icon: Icons.download_outlined,
                  title: 'Xuất dữ liệu',
                  subtitle: 'Tải lịch sử về thiết bị',
                  onTap: () => context.push('/impact/export'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int total;
  final int avgScore;
  final int streak;

  const _SummaryBanner(
      {required this.total,
      required this.avgScore,
      required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text('🌿 Tác động của bạn',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            children: [
              _BannerStat(
                  value: '$total', label: 'Đã quét'),
              _divider(),
              _BannerStat(
                  value: '$avgScore', label: 'Điểm TB'),
              _divider(),
              _BannerStat(
                  value: '${streak}🔥',
                  label: 'Streak xanh'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
      height: 36, width: 1, color: Colors.white30,
      margin: const EdgeInsets.symmetric(horizontal: 16));
}

class _BannerStat extends StatelessWidget {
  final String value;
  final String label;

  const _BannerStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color)),
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

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
