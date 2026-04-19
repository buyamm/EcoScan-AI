import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/settings/settings_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    _Language('vi', '🇻🇳'),
    _Language('en', '🇬🇧'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.language)),
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
                    const Icon(Icons.translate, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.languageHint,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ..._languages.map((lang) {
                final selected = state.languageCode == lang.code;
                final name = lang.code == 'vi' ? l10n.vietnamese : l10n.english;
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
                      name,
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
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        );
      },
    );
  }
}

class _Language {
  final String code;
  final String flag;

  const _Language(this.code, this.flag);
}
