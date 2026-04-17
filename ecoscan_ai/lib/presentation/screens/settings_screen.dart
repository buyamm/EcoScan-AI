import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          _SettingsSection(
            title: 'Giao diện',
            children: [
              _SettingsTile(
                icon: Icons.language,
                title: 'Ngôn ngữ',
                subtitle: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) => Text(
                    state.languageCode == 'vi' ? 'Tiếng Việt' : 'English',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ),
                onTap: () => context.push('/settings/language'),
              ),
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Giao diện',
                subtitle: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    final label = switch (state.themeMode) {
                      ThemeMode.light => 'Sáng',
                      ThemeMode.dark => 'Tối',
                      ThemeMode.system => 'Theo hệ thống',
                    };
                    return Text(label,
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600]));
                  },
                ),
                onTap: () => context.push('/settings/theme'),
              ),
              _SettingsTile(
                icon: Icons.text_fields,
                title: 'Cỡ chữ',
                onTap: () => context.push('/settings/font'),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Thông báo',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Thông báo',
                onTap: () => context.push('/settings/notification'),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Dữ liệu & Bộ nhớ',
            children: [
              _SettingsTile(
                icon: Icons.storage_outlined,
                title: 'Bộ nhớ cache',
                onTap: () => context.push('/settings/cache'),
              ),
              _SettingsTile(
                icon: Icons.data_usage_outlined,
                title: 'Sử dụng dữ liệu',
                onTap: () => context.push('/settings/data'),
              ),
              _SettingsTile(
                icon: Icons.delete_outline,
                title: 'Xóa toàn bộ dữ liệu',
                iconColor: AppColors.danger,
                titleColor: AppColors.danger,
                onTap: () => context.push('/settings/delete-data'),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Hỗ trợ',
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Trợ giúp & FAQ',
                onTap: () => context.push('/settings/help'),
              ),
              _SettingsTile(
                icon: Icons.play_circle_outline,
                title: 'Hướng dẫn sử dụng',
                onTap: () => context.push('/settings/tutorial'),
              ),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Gửi phản hồi',
                onTap: () => context.push('/settings/feedback'),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Pháp lý',
            children: [
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Chính sách quyền riêng tư',
                onTap: () => context.push('/settings/privacy'),
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Điều khoản sử dụng',
                onTap: () => context.push('/settings/terms'),
              ),
              _SettingsTile(
                icon: Icons.code,
                title: 'Mã nguồn mở',
                onTap: () => context.push('/settings/opensource'),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Ứng dụng',
            children: [
              _SettingsTile(
                icon: Icons.security_outlined,
                title: 'Quyền ứng dụng',
                onTap: () => context.push('/settings/permissions'),
              ),
              _SettingsTile(
                icon: Icons.system_update_outlined,
                title: 'Kiểm tra cập nhật',
                onTap: () => context.push('/settings/update'),
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Về ứng dụng',
                onTap: () => context.push('/settings/about'),
              ),
              _SettingsTile(
                icon: Icons.favorite_outline,
                title: 'Credits',
                onTap: () => context.push('/settings/credits'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
