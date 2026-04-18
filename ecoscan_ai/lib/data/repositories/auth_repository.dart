import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import 'user_profile_repository.dart';
import '../../core/constants/app_constants.dart';

/// Holds basic Google account info after sign-in.
class GoogleUser {
  final String displayName;
  final String email;
  final String? photoUrl;

  const GoogleUser({
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
      };

  factory GoogleUser.fromJson(Map<String, dynamic> json) => GoogleUser(
        displayName: json['displayName']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        photoUrl: json['photoUrl']?.toString(),
      );
}

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _prefs;
  final UserProfileRepository _profileRepo;

  static const _keyGoogleUser = 'google_user';

  AuthRepository({
    required SharedPreferences prefs,
    required UserProfileRepository profileRepo,
    GoogleSignIn? googleSignIn,
  })  : _prefs = prefs,
        _profileRepo = profileRepo,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(scopes: ['email', 'profile']);

  /// Returns the cached [GoogleUser] if previously signed in, else null.
  GoogleUser? getCurrentUser() {
    final raw = _prefs.getString(_keyGoogleUser);
    if (raw == null) return null;
    try {
      return GoogleUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Initiates Google Sign-In flow.
  /// Returns [GoogleUser] on success, null if user cancelled.
  /// Throws on network/auth errors.
  Future<GoogleUser?> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null; // user cancelled

    final user = GoogleUser(
      displayName: account.displayName ?? account.email.split('@').first,
      email: account.email,
      photoUrl: account.photoUrl,
    );

    // Persist Google user info
    await _prefs.setString(_keyGoogleUser, jsonEncode(user.toJson()));

    // Merge into UserProfile (preserve existing allergies/lifestyle)
    final existing = _profileRepo.getProfile();
    await _profileRepo.saveProfile(existing.copyWith(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
    ));

    return user;
  }

  /// Signs out from Google and clears cached user info.
  /// Does NOT clear scan history or profile allergies/lifestyle.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _prefs.remove(_keyGoogleUser);

    // Clear only auth fields from profile, keep allergies/lifestyle
    final existing = _profileRepo.getProfile();
    await _profileRepo.saveProfile(existing.copyWith(
      displayName: '',
      email: null,
      photoUrl: null,
    ));
  }

  /// Whether the user is currently signed in with Google.
  bool get isSignedIn => getCurrentUser() != null;
}
