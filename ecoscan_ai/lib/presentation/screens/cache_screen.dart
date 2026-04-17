import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CacheScreen extends StatefulWidget {
  const CacheScreen({super.key});

  @override
  State<CacheScreen> createState() => _CacheScreenState();
}

class _CacheScreenState extends State<CacheScreen> {
  bool _clearing = false;

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa cache sản phẩm'),
        content: const Text(
            'Xóa toàn bộ cache? Lần quét tiếp theo sẽ tải dữ liệu mới từ mạng.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _clearing = true);
    // Cache clear will be wired to ProductCacheRepository when router provides it (task 10)
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _clearing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa cache sản phẩm'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _purgeExpired() async {
    setState(() => _clearing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _clearing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa cache hết hạn'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cache count will be wired once router provides ProductCacheRepository (task 10)
    const count = 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý cache')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cache info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: AppColors.primary, size: 32),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count sản phẩm',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text('đang được cache',
                        style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Về cache sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _InfoRow(
                      icon: Icons.speed_outlined,
                      text: 'Cache giúp tải sản phẩm đã quét nhanh hơn'),
                  const SizedBox(height: 6),
                  _InfoRow(
                      icon: Icons.timer_outlined,
                      text: 'Tự động hết hạn sau 7 ngày'),
                  const SizedBox(height: 6),
                  _InfoRow(
                      icon: Icons.wifi_off_outlined,
                      text: 'Cho phép xem thông tin sản phẩm offline'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Thao tác',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined,
                      color: AppColors.primary),
                  title: const Text('Xóa cache hết hạn'),
                  subtitle: const Text('Chỉ xóa dữ liệu quá 7 ngày'),
                  trailing: _clearing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.chevron_right, size: 18),
                  onTap: _clearing ? null : _purgeExpired,
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.delete_outline, color: AppColors.danger),
                  title: const Text('Xóa toàn bộ cache',
                      style: TextStyle(color: AppColors.danger)),
                  subtitle: Text(
                    count == 0
                        ? 'Không có dữ liệu để xóa'
                        : 'Xóa $count sản phẩm đã lưu',
                  ),
                  trailing: _clearing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.chevron_right, size: 18),
                  onTap: (count == 0 || _clearing) ? null : _clearCache,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ),
      ],
    );
  }
}
