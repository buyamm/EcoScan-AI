import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/settings/settings_cubit.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class NotificationPreferenceScreen extends StatefulWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  State<NotificationPreferenceScreen> createState() =>
      _NotificationPreferenceScreenState();
}

class _NotificationPreferenceScreenState
    extends State<NotificationPreferenceScreen> {
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Tùy chọn thông báo')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Thông báo nhắc nhở bạn kiểm tra sản phẩm mới. Tất cả dữ liệu xử lý cục bộ.',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const SectionHeader(title: 'Cài đặt thông báo'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Bật thông báo nhắc nhở'),
                      subtitle: Text(
                        state.notificationEnabled
                            ? 'Đang bật'
                            : 'Đang tắt',
                        style: TextStyle(
                          color: state.notificationEnabled
                              ? AppColors.primary
                              : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      secondary: const Icon(Icons.notifications_active_outlined),
                      value: state.notificationEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (v) =>
                          context.read<SettingsCubit>().setNotificationEnabled(v),
                    ),
                    if (state.notificationEnabled) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.access_time_outlined),
                        title: const Text('Giờ nhắc nhở'),
                        subtitle: const Text('Nhắc nhở hàng ngày'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _reminderTime.format(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: _pickTime,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Notification types
              const SectionHeader(title: 'Loại thông báo'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      _NotifRow(
                        icon: Icons.qr_code_scanner,
                        title: 'Nhắc quét sản phẩm',
                        subtitle: 'Nhắc nhở kiểm tra sản phẩm mới',
                        enabled: state.notificationEnabled,
                      ),
                      const Divider(height: 16),
                      _NotifRow(
                        icon: Icons.warning_amber_outlined,
                        title: 'Cảnh báo dị ứng',
                        subtitle: 'Luôn bật — phát hiện ngay khi quét',
                        enabled: true,
                        locked: true,
                      ),
                      const Divider(height: 16),
                      _NotifRow(
                        icon: Icons.emoji_events_outlined,
                        title: 'Huy hiệu thành tích',
                        subtitle: 'Khi đạt được cột mốc mới',
                        enabled: state.notificationEnabled,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Privacy note
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lock_outline, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Thông báo được xử lý cục bộ. Không có dữ liệu nào được gửi đến server.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
            ],
          ),
        );
      },
    );
  }
}

class _NotifRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final bool locked;

  const _NotifRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            color: enabled ? AppColors.primary : Colors.grey[400], size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: enabled ? null : Colors.grey[500])),
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ),
        if (locked)
          Icon(Icons.lock_outline, color: Colors.grey[400], size: 18)
        else
          Icon(
            enabled ? Icons.check_circle : Icons.circle_outlined,
            color: enabled ? AppColors.primary : Colors.grey[400],
            size: 20,
          ),
      ],
    );
  }
}
