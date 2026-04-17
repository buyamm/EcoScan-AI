import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Về ứng dụng')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App logo & version
          Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 16),
                const Text(
                  'EcoScan AI',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Phiên bản 1.0.0',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Build 2026.04.17',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Mission
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.eco, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Sứ mệnh',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'EcoScan AI hỗ trợ người tiêu dùng Việt Nam đưa ra quyết định mua sắm thông minh và có trách nhiệm hơn, hướng đến SDG 12 — Tiêu dùng có trách nhiệm.',
                    style: TextStyle(
                        fontSize: 13, height: 1.6, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Team info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.people_outline, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Nhóm phát triển',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _TeamMember(name: 'EcoScan Team', role: 'Phát triển & Thiết kế'),
                  const Divider(height: 16),
                  Text(
                    'Được xây dựng với Flutter & Dart',
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Links
          Card(
            child: Column(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.code, color: AppColors.primary),
                  title: const Text('Mã nguồn mở (GitHub)'),
                  trailing: const Icon(Icons.open_in_new, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined,
                      color: AppColors.primary),
                  title: const Text('Điều khoản sử dụng'),
                  trailing:
                      const Icon(Icons.chevron_right, size: 18),
                  onTap: () => context.push('/settings/terms'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined,
                      color: AppColors.primary),
                  title: const Text('Chính sách quyền riêng tư'),
                  trailing:
                      const Icon(Icons.chevron_right, size: 18),
                  onTap: () => context.push('/settings/privacy'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite_outline,
                      color: AppColors.primary),
                  title: const Text('Credits & Acknowledgements'),
                  trailing:
                      const Icon(Icons.chevron_right, size: 18),
                  onTap: () => context.push('/settings/credits'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© 2026 EcoScan AI Team\nMade with 💚 for the planet',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12, color: Colors.grey[500], height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String role;

  const _TeamMember({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary.withOpacity(0.15),
          child: Text(
            name[0],
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            Text(role,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}
