import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/history/history_cubit.dart';

class DataUsageScreen extends StatelessWidget {
  const DataUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<HistoryCubit>().state;
    const cacheCount = 0; // Wired to ProductCacheRepository in task 10
    final historyCount = historyState.allRecords.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Sử dụng dữ liệu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.secondary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.storage, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Bộ nhớ cục bộ',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _StatBox(
                        label: 'Lịch sử quét',
                        value: '$historyCount',
                        unit: 'bản ghi'),
                    const SizedBox(width: 12),
                    _StatBox(
                        label: 'Sản phẩm cache',
                        value: '$cacheCount',
                        unit: 'sản phẩm'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Chi tiết',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 10),

          _UsageRow(
            icon: Icons.history,
            title: 'Lịch sử quét',
            value: '$historyCount / 500 bản ghi',
            progress: historyCount / 500,
          ),
          const SizedBox(height: 10),
          _UsageRow(
            icon: Icons.inventory_2_outlined,
            title: 'Cache sản phẩm',
            subtitle: 'Hết hạn sau 7 ngày',
            value: '$cacheCount sản phẩm',
            progress: null,
          ),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ghi chú',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _Note(
                    icon: Icons.lock_outline,
                    text: 'Tất cả dữ liệu chỉ lưu trên thiết bị của bạn.',
                  ),
                  const SizedBox(height: 6),
                  _Note(
                    icon: Icons.cloud_off_outlined,
                    text: 'Không có dữ liệu nào được đồng bộ lên cloud.',
                  ),
                  const SizedBox(height: 6),
                  _Note(
                    icon: Icons.delete_sweep_outlined,
                    text: 'Cache tự động xóa sau 7 ngày không sử dụng.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatBox(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary),
            ),
            Text(unit,
                style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String value;
  final double? progress;

  const _UsageRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      if (subtitle != null)
                        Text(subtitle!,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 13),
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                backgroundColor: Colors.grey[200],
                color: progress! > 0.8 ? AppColors.warning : AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Note({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ),
      ],
    );
  }
}
