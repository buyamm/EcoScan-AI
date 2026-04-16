import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // ─── Language ────────────────────────────────────────────────────────────

  String getLanguage() =>
      _prefs.getString(AppConstants.keyAppLanguage) ?? 'vi';

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(AppConstants.keyAppLanguage, languageCode);
  }

  // ─── Theme ───────────────────────────────────────────────────────────────

  ThemeMode getThemeMode() {
    final raw = _prefs.getString(AppConstants.keyThemeMode) ?? 'system';
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final raw = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(AppConstants.keyThemeMode, raw);
  }

  // ─── Notifications ────────────────────────────────────────────────────────

  bool getNotificationEnabled() =>
      _prefs.getBool(AppConstants.keyNotificationEnabled) ?? false;

  Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.keyNotificationEnabled, enabled);
  }

  // ─── Font size ───────────────────────────────────────────────────────────

  double getFontSize() => _prefs.getDouble(AppConstants.keyFontSize) ?? 1.0;

  Future<void> setFontSize(double scale) async {
    await _prefs.setDouble(AppConstants.keyFontSize, scale);
  }

  // ─── Onboarding ──────────────────────────────────────────────────────────

  bool getOnboardingDone() =>
      _prefs.getBool(AppConstants.keyOnboardingDone) ?? false;

  Future<void> setOnboardingDone(bool done) async {
    await _prefs.setBool(AppConstants.keyOnboardingDone, done);
  }

  // ─── Clear all ───────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
