import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_cubit.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  static const _options = [
    _ThemeOption(ThemeMode.light, 'Sáng', Icons.light_mode_outlined),
    _ThemeOption(ThemeMode.dark, 'Tối', Icons.dark_mode_outlined),
    _ThemeOption(ThemeMode.system, 'Theo hệ thống', Icons.brightness_auto),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Giao diện')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              ..._options.map((opt) {
                final selected = state.themeMode == opt.mode;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          selected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.12)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        opt.icon,
                        color:
                            selected ? AppColors.primary : Colors.grey[600],
                      ),
                    ),
                    title: Text(
                      opt.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.primary : null,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primary)
                        : null,
                    onTap: () =>
                        context.read<SettingsCubit>().changeTheme(opt.mode),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.primary, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '"Theo hệ thống" sẽ tự động chuyển đổi dựa trên cài đặt của thiết bị.',
                        style: TextStyle(fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final String label;
  final IconData icon;

  const _ThemeOption(this.mode, this.label, this.icon);
}
