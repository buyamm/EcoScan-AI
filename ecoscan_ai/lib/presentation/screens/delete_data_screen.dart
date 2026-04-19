import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class DeleteDataScreen extends StatelessWidget {
  const DeleteDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xóa dữ liệu'),
        backgroundColor: AppColors.danger,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Warning banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.danger.withOpacity(0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: AppColors.danger, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hành động không thể hoàn tác',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.danger,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Toàn bộ dữ liệu cục bộ sẽ bị xóa vĩnh viễn khỏi thiết bị.',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Dữ liệu sẽ bị xóa',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),

          _DataItem(
            icon: Icons.history,
            title: 'Lịch sử quét',
            description: 'Tất cả các sản phẩm đã quét (tối đa 500 bản ghi)',
          ),
          _DataItem(
            icon: Icons.person_outline,
            title: 'Hồ sơ cá nhân',
            description: 'Tên hiển thị, danh sách dị ứng, lối sống',
          ),
          _DataItem(
            icon: Icons.inventory_2_outlined,
            title: 'Cache sản phẩm',
            description: 'Dữ liệu sản phẩm đã lưu tạm thời',
          ),
          _DataItem(
            icon: Icons.settings_outlined,
            title: 'Cài đặt ứng dụng',
            description: 'Ngôn ngữ, giao diện, thông báo sẽ trở về mặc định',
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline,
                    color: Colors.grey[500], size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dữ liệu này chỉ tồn tại trên thiết bị của bạn. Xóa ứng dụng cũng sẽ xóa tất cả.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () => context.push('/settings/delete-confirm'),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Tiếp tục xóa dữ liệu'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Hủy'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
        ],
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _DataItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.danger, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(description,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
