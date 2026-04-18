import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileRepository _repo;

  ProfileCubit({required UserProfileRepository repo})
      : _repo = repo,
        super(ProfileState(profile: repo.getProfile()));

  /// Reload profile from storage.
  void loadProfile() {
    emit(state.copyWith(profile: _repo.getProfile()));
  }

  /// Update and persist the entire profile.
  Future<void> saveProfile(UserProfile profile) async {
    emit(state.copyWith(isSaving: true));
    await _repo.saveProfile(profile);
    emit(ProfileState(profile: profile, isSaving: false));
  }

  /// Toggle a standard allergen on/off.
  Future<void> toggleAllergen(String allergen) async {
    final current = state.profile.allergies.toList();
    if (current.contains(allergen)) {
      current.remove(allergen);
    } else {
      current.add(allergen);
    }
    await saveProfile(state.profile.copyWith(allergies: current));
  }

  /// Add a custom allergen string.
  Future<void> addCustomAllergen(String allergen) async {
    final trimmed = allergen.trim();
    if (trimmed.isEmpty) return;
    final current = state.profile.customAllergies.toList();
    if (!current.contains(trimmed)) {
      current.add(trimmed);
      await saveProfile(state.profile.copyWith(customAllergies: current));
    }
  }

  /// Remove a custom allergen string.
  Future<void> removeCustomAllergen(String allergen) async {
    final current = state.profile.customAllergies.toList()..remove(allergen);
    await saveProfile(state.profile.copyWith(customAllergies: current));
  }

  /// Toggle a lifestyle option on/off.
  Future<void> toggleLifestyle(LifestyleOption option) async {
    final current = state.profile.lifestyle.toList();
    if (current.contains(option)) {
      current.remove(option);
    } else {
      current.add(option);
    }
    await saveProfile(state.profile.copyWith(lifestyle: current));
  }

  /// Update display name.
  Future<void> updateDisplayName(String name) async {
    await saveProfile(state.profile.copyWith(displayName: name.trim()));
  }

  /// Toggle a dietary preference on/off.
  Future<void> toggleDietaryPreference(DietaryPreference pref) async {
    final current = state.profile.dietaryPreferences.toList();
    if (current.contains(pref)) {
      current.remove(pref);
    } else {
      current.add(pref);
    }
    await saveProfile(state.profile.copyWith(dietaryPreferences: current));
  }

  /// Replace the full list of dietary preferences.
  Future<void> updateDietaryPreferences(
      List<DietaryPreference> preferences) async {
    await saveProfile(
        state.profile.copyWith(dietaryPreferences: preferences));
  }

  /// Returns true if the product's allergens conflict with user profile.
  bool hasAllergenConflict(List<String> productAllergens) {
    final userAllergies = state.profile.allAllergies
        .map((a) => a.toLowerCase())
        .toList();
    return productAllergens
        .any((a) => userAllergies.any((u) => a.toLowerCase().contains(u)));
  }

  /// Returns lifestyle options that conflict with the product analysis.
  List<LifestyleOption> lifestyleConflicts({
    required bool? productIsVegan,
    required bool? productIsVegetarian,
    required bool? productIsCrueltyFree,
  }) {
    final conflicts = <LifestyleOption>[];
    final lifestyle = state.profile.lifestyle;

    if (lifestyle.contains(LifestyleOption.vegan) &&
        productIsVegan == false) {
      conflicts.add(LifestyleOption.vegan);
    }
    if (lifestyle.contains(LifestyleOption.vegetarian) &&
        productIsVegetarian == false) {
      conflicts.add(LifestyleOption.vegetarian);
    }
    if (lifestyle.contains(LifestyleOption.crueltyFreeOnly) &&
        productIsCrueltyFree == false) {
      conflicts.add(LifestyleOption.crueltyFreeOnly);
    }
    return conflicts;
  }

  /// Delete profile and reset to empty.
  Future<void> clearProfile() async {
    await _repo.clearProfile();
    emit(ProfileState(profile: UserProfile()));
  }
}
