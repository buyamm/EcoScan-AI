import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  static const _permissions = [
    _Permission(
      icon: Icons.camera_alt_outlined,
      name: 'Camera',
      purpose: 'Quét mã vạch và OCR nhãn sản phẩm',
      required: true,
      status: _PermStatus.granted,
    ),
    _Permission(
      icon: Icons.photo_library_outlined,
      name: 'Thư viện ảnh',
      purpose: 'Chọn ảnh từ máy để OCR (tùy chọn)',
      required: false,
      status: _PermStatus.optional,
    ),
    _Permission(
      icon: Icons.notifications_outlined,
      name: 'Thông báo',
      purpose: 'Nhắc nhở quét sản phẩm và cảnh báo',
      required: false,
      status: _PermStatus.optional,
    ),
    _Permission(
      icon: Icons.wifi_outlined,
      name: 'Internet',
      purpose: 'Tra cứu Open Food Facts và phân tích AI',
      required: true,
      status: _PermStatus.granted,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quyền ứng dụng')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.security_outlined, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'EcoScan AI chỉ yêu cầu các quyền tối thiểu cần thiết để hoạt động. Không có quyền truy cập vào danh bạ, tin nhắn, hay định vị.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._permissions.map((p) => _PermissionCard(permission: p)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quản lý quyền',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    'Để thay đổi quyền, vào Cài đặt hệ thống → Ứng dụng → EcoScan AI → Quyền.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5),
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

class _PermissionCard extends StatelessWidget {
  final _Permission permission;

  const _PermissionCard({required this.permission});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (permission.status) {
      _PermStatus.granted => AppColors.primary,
      _PermStatus.denied => AppColors.danger,
      _PermStatus.optional => Colors.grey,
    };

    final statusLabel = switch (permission.status) {
      _PermStatus.granted => 'Đã cấp',
      _PermStatus.denied => 'Bị từ chối',
      _PermStatus.optional => 'Tùy chọn',
    };

    final statusIcon = switch (permission.status) {
      _PermStatus.granted => Icons.check_circle,
      _PermStatus.denied => Icons.cancel,
      _PermStatus.optional => Icons.info_outline,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(permission.icon,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(permission.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(width: 8),
                      if (permission.required)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Bắt buộc',
                            style: TextStyle(
                                fontSize: 9,
                                color: AppColors.danger,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(permission.purpose,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(height: 2),
                Text(statusLabel,
                    style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _PermStatus { granted, denied, optional }

class _Permission {
  final IconData icon;
  final String name;
  final String purpose;
  final bool required;
  final _PermStatus status;

  const _Permission({
    required this.icon,
    required this.name,
    required this.purpose,
    required this.required,
    required this.status,
  });
}
