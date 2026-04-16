import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../../core/constants/app_constants.dart';

class UserProfileRepository {
  final SharedPreferences _prefs;

  UserProfileRepository(this._prefs);

  /// Returns the stored [UserProfile], or an empty profile if none exists.
  UserProfile getProfile() {
    final raw = _prefs.getString(AppConstants.keyUserProfile);
    if (raw == null) return UserProfile();
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UserProfile();
    }
  }

  /// Persists [profile] to SharedPreferences.
  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(
        AppConstants.keyUserProfile, jsonEncode(profile.toJson()));
  }

  /// Deletes the stored profile.
  Future<void> clearProfile() async {
    await _prefs.remove(AppConstants.keyUserProfile);
  }
}
