part of 'profile_cubit.dart';

class ProfileState {
  final UserProfile profile;
  final bool isSaving;

  const ProfileState({
    required this.profile,
    this.isSaving = false,
  });

  ProfileState copyWith({UserProfile? profile, bool? isSaving}) => ProfileState(
        profile: profile ?? this.profile,
        isSaving: isSaving ?? this.isSaving,
      );
}
