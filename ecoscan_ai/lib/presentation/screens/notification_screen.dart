import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Thông báo')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined,
                      color: AppColors.primary),
                  title: const Text('Bật thông báo nhắc nhở',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    state.notificationEnabled ? 'Đang bật' : 'Đang tắt',
                    style: TextStyle(
                      color: state.notificationEnabled
                          ? AppColors.primary
                          : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  value: state.notificationEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (v) =>
                      context.read<SettingsCubit>().setNotificationEnabled(v),
                ),
              ),
              if (state.notificationEnabled) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.access_time,
                        color: AppColors.primary),
                    title: const Text('Giờ nhắc nhở hàng ngày'),
                    trailing: Text(
                      _reminderTime.format(context),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 15,
                      ),
                    ),
                    onTap: _pickTime,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Loại thông báo',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 12),
                        _TypeRow(
                          icon: Icons.qr_code_scanner,
                          title: 'Nhắc quét sản phẩm mới',
                          subtitle: 'Nhắc nhở theo lịch cài đặt',
                          color: AppColors.primary,
                        ),
                        const Divider(height: 20),
                        _TypeRow(
                          icon: Icons.emoji_events_outlined,
                          title: 'Huy hiệu thành tích',
                          subtitle: 'Khi đạt được cột mốc mới',
                          color: AppColors.warning,
                        ),
                        const Divider(height: 20),
                        _TypeRow(
                          icon: Icons.warning_amber_outlined,
                          title: 'Cảnh báo dị ứng',
                          subtitle: 'Luôn bật khi phát hiện',
                          color: AppColors.danger,
                          locked: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline,
                        color: Colors.grey[500], size: 18),
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
            ],
          ),
        );
      },
    );
  }
}

class _TypeRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool locked;

  const _TypeRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
              Text(subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
        if (locked)
          Icon(Icons.lock_outline, color: Colors.grey[400], size: 16)
        else
          Icon(Icons.check_circle, color: color, size: 18),
      ],
    );
  }
}
