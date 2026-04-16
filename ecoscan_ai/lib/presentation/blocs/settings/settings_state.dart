part of 'settings_cubit.dart';

class SettingsState {
  final String languageCode;
  final ThemeMode themeMode;
  final bool notificationEnabled;
  final double fontSize;
  final bool onboardingDone;

  const SettingsState({
    this.languageCode = 'vi',
    this.themeMode = ThemeMode.system,
    this.notificationEnabled = false,
    this.fontSize = 1.0,
    this.onboardingDone = false,
  });

  Locale get locale => Locale(languageCode);

  SettingsState copyWith({
    String? languageCode,
    ThemeMode? themeMode,
    bool? notificationEnabled,
    double? fontSize,
    bool? onboardingDone,
  }) =>
      SettingsState(
        languageCode: languageCode ?? this.languageCode,
        themeMode: themeMode ?? this.themeMode,
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
        fontSize: fontSize ?? this.fontSize,
        onboardingDone: onboardingDone ?? this.onboardingDone,
      );
}
