import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/history/history_cubit.dart';
import '../blocs/settings/settings_cubit.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/ai_analysis_model.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _tabs = ['/home/dashboard', '/scan', '/history', '/profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
          context.go(_tabs[i]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: Icon(Icons.qr_code_scanner),
            label: 'Quét',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
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
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => context.read<HistoryCubit>().loadHistory(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome banner
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
                    settingsState.onboardingDone
                        ? 'Chào mừng trở lại! 🌿'
                        : 'Chào mừng đến EcoScan AI! 🌿',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Quét sản phẩm để biết mức độ bền vững',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/scan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: const Text('Quét ngay'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Quick stats
            if (totalScans > 0) ...[
              const Text(
                'Thống kê nhanh',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatCard(
                    label: 'Đã quét',
                    value: '$totalScans',
                    icon: Icons.qr_code_2,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: '🟢 Tốt',
                    value: '$greenScans',
                    icon: Icons.eco,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: '🔴 Kém',
                    value: '$redScans',
                    icon: Icons.warning_amber,
                    color: AppColors.danger,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _StatCard(
                label: '🟡 Trung bình',
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
            // Recent scans
            if (historyState.allRecords.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quét gần đây',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => context.go('/history'),
                    child: const Text('Xem tất cả'),
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
                      r.product.name.isNotEmpty
                          ? r.product.name
                          : 'Sản phẩm không tên',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      r.product.brand.isNotEmpty ? r.product.brand : 'N/A',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () =>
                        context.go('/history/detail', extra: r),
                  )),
            ],
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
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );

    return fullWidth ? card : Expanded(child: card);
  }
}

class _EmptyStatsBanner extends StatelessWidget {
  final VoidCallback onScan;

  const _EmptyStatsBanner({required this.onScan});

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Chưa có sản phẩm nào được quét',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            'Quét sản phẩm đầu tiên để xem thống kê',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onScan,
            child: const Text('Quét ngay'),
          ),
        ],
      ),
    );
  }
}
