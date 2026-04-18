import 'package:hive_flutter/hive_flutter.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 13)
enum LifestyleOption {
  @HiveField(0)
  vegetarian,
  @HiveField(1)
  vegan,
  @HiveField(2)
  ecoConscious,
  @HiveField(3)
  crueltyFreeOnly,
}

@HiveType(typeId: 15)
enum DietaryPreference {
  @HiveField(0)
  glutenFree,
  @HiveField(1)
  lactoseFree,
  @HiveField(2)
  lowSugar,
  @HiveField(3)
  lowSalt,
  @HiveField(4)
  keto,
  @HiveField(5)
  paleo,
}

@HiveType(typeId: 14)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String displayName;

  @HiveField(1)
  final List<String> allergies;

  @HiveField(2)
  final List<LifestyleOption> lifestyle;

  @HiveField(3)
  final List<String> customAllergies;

  @HiveField(4)
  final List<DietaryPreference> dietaryPreferences;

  // Stored only in JSON via SharedPreferences (not in Hive box).
  final String? email;
  final String? photoUrl;

  UserProfile({
    this.displayName = '',
    this.allergies = const [],
    this.lifestyle = const [],
    this.customAllergies = const [],
    this.dietaryPreferences = const [],
    this.email,
    this.photoUrl,
  });

  List<String> get allAllergies => [...allergies, ...customAllergies];

  bool get isGoogleSignedIn => email != null && email!.isNotEmpty;

  UserProfile copyWith({
    String? displayName,
    List<String>? allergies,
    List<LifestyleOption>? lifestyle,
    List<String>? customAllergies,
    List<DietaryPreference>? dietaryPreferences,
    String? email,
    String? photoUrl,
  }) =>
      UserProfile(
        displayName: displayName ?? this.displayName,
        allergies: allergies ?? this.allergies,
        lifestyle: lifestyle ?? this.lifestyle,
        customAllergies: customAllergies ?? this.customAllergies,
        dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
      );

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'allergies': allergies,
        'lifestyle': lifestyle.map((e) => e.name).toList(),
        'customAllergies': customAllergies,
        'dietaryPreferences': dietaryPreferences.map((e) => e.name).toList(),
        'email': email,
        'photoUrl': photoUrl,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        displayName: json['displayName']?.toString() ?? '',
        allergies: List<String>.from(json['allergies'] ?? []),
        lifestyle: (json['lifestyle'] as List? ?? [])
            .map((e) => LifestyleOption.values.firstWhere(
                  (v) => v.name == e.toString(),
                  orElse: () => LifestyleOption.ecoConscious,
                ))
            .toList(),
        customAllergies: List<String>.from(json['customAllergies'] ?? []),
        dietaryPreferences: (json['dietaryPreferences'] as List? ?? [])
            .map((e) => DietaryPreference.values.firstWhere(
                  (v) => v.name == e.toString(),
                  orElse: () => DietaryPreference.glutenFree,
                ))
            .toList(),
        email: json['email']?.toString(),
        photoUrl: json['photoUrl']?.toString(),
      );

  static const List<String> standardAllergens = [
    'gluten',
    'lactose',
    'nuts',
    'paraben',
    'sulfate',
    'soy',
    'eggs',
    'shellfish',
    'pollen',
  ];
}
