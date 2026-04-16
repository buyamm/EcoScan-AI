import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repo;

  SettingsCubit({required SettingsRepository repo})
      : _repo = repo,
        super(SettingsState(
          languageCode: repo.getLanguage(),
          themeMode: repo.getThemeMode(),
          notificationEnabled: repo.getNotificationEnabled(),
          fontSize: repo.getFontSize(),
          onboardingDone: repo.getOnboardingDone(),
        ));

  /// Switch app language and persist. Rebuilds locale immediately.
  Future<void> changeLanguage(String languageCode) async {
    await _repo.setLanguage(languageCode);
    emit(state.copyWith(languageCode: languageCode));
  }

  /// Switch theme mode and persist.
  Future<void> changeTheme(ThemeMode mode) async {
    await _repo.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  /// Toggle notification enabled state.
  Future<void> setNotificationEnabled(bool enabled) async {
    await _repo.setNotificationEnabled(enabled);
    emit(state.copyWith(notificationEnabled: enabled));
  }

  /// Update font scale factor.
  Future<void> setFontSize(double scale) async {
    await _repo.setFontSize(scale);
    emit(state.copyWith(fontSize: scale));
  }

  /// Mark onboarding as complete.
  Future<void> completeOnboarding() async {
    await _repo.setOnboardingDone(true);
    emit(state.copyWith(onboardingDone: true));
  }

  /// Wipe all settings (called from delete data flow).
  Future<void> clearAll() async {
    await _repo.clearAll();
    emit(const SettingsState());
  }
}
