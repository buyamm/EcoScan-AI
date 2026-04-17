import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    _Language('vi', 'Tiếng Việt', '🇻🇳'),
    _Language('en', 'English', '🇬🇧'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Ngôn ngữ')),
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
                    Icon(Icons.translate, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Ngôn ngữ sẽ được thay đổi ngay lập tức, không cần khởi động lại.',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ..._languages.map((lang) {
                final selected = state.languageCode == lang.code;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(lang.flag,
                        style: const TextStyle(fontSize: 28)),
                    title: Text(
                      lang.name,
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
                        context.read<SettingsCubit>().changeLanguage(lang.code),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _Language {
  final String code;
  final String name;
  final String flag;

  const _Language(this.code, this.name, this.flag);
}
