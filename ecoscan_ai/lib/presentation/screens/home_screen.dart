import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/history/history_cubit.dart';
import '../blocs/settings/settings_cubit.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _tabs = ['/home', '/scan', '/history', '/profile'];

  int _indexForLocation(String location) {
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: const Icon(Icons.qr_code_scanner),
            label: l10n.scan,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsState = context.watch<SettingsCubit>().state;
    final historyState = context.watch<HistoryCubit>().state;

    final totalScans = historyState.allRecords.length;
    final greenScans = historyState.allRecords
        .where((r) => r.analysis.level == EcoScoreLevel.green)
        .length;
    final yellowScans = historyState.allRecords
        .where((r) => r.analysis.level == EcoScoreLevel.yellow)
        .length;
    final redScans = historyState.allRecords
        .where((r) => r.analysis.level == EcoScoreLevel.red)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoScan AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => context.read<HistoryCubit>().loadHistory(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
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
                  Text(
                    '${l10n.homeWelcome} 🌿',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeSubtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/scan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: Text(l10n.homeScanNow),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (totalScans > 0) ...[
              Text(
                l10n.homeQuickStats,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatCard(
                    label: l10n.totalScans,
                    value: '$totalScans',
                    icon: Icons.qr_code_2,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: '🟢 ${l10n.good}',
                    value: '$greenScans',
                    icon: Icons.eco,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: '🔴 ${l10n.poor}',
                    value: '$redScans',
                    icon: Icons.warning_amber,
                    color: AppColors.danger,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _StatCard(
                label: '🟡 ${l10n.average}',
                value: '$yellowScans',
                icon: Icons.remove_circle_outline,
                color: AppColors.warning,
                fullWidth: true,
              ),
              const SizedBox(height: 20),
            ] else ...[
              _EmptyStatsBanner(onScan: () => context.go('/scan')),
              const SizedBox(height: 20),
            ],
            _ImpactShortcut(
              totalScans: totalScans,
              onTap: () => context.push('/impact'),
            ),
            const SizedBox(height: 20),
            if (historyState.allRecords.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.homeRecentScans,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => context.go('/history'),
                    child: Text(l10n.seeAll),
                  ),
                ],
              ),
              ...historyState.allRecords.take(3).map((r) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        r.analysis.level == EcoScoreLevel.green
                            ? '🟢'
                            : r.analysis.level == EcoScoreLevel.yellow
                                ? '🟡'
                                : '🔴',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    title: Text(
                      r.product.name.isNotEmpty ? r.product.name : l10n.noData,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      r.product.brand.isNotEmpty ? r.product.brand : 'N/A',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => context.push('/history/detail', extra: r),
                  )),
            ],
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
    return fullWidth ? card : Expanded(child: card);
  }
}

class _ImpactShortcut extends StatelessWidget {
  final int totalScans;
  final VoidCallback onTap;

  const _ImpactShortcut({required this.totalScans, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bar_chart,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.personalImpact,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(
                    totalScans > 0 ? l10n.impactChart : l10n.impactEmptyHint,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _EmptyStatsBanner extends StatelessWidget {
  final VoidCallback onScan;

  const _EmptyStatsBanner({required this.onScan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('🛒', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            l10n.historyEmpty,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.historyEmptyHint,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onScan,
            child: Text(l10n.homeScanNow),
          ),
        ],
      ),
    );
  }
}
