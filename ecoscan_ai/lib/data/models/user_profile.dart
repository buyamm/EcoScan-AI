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

  UserProfile({
    this.displayName = '',
    this.allergies = const [],
    this.lifestyle = const [],
    this.customAllergies = const [],
  });

  List<String> get allAllergies => [...allergies, ...customAllergies];

  UserProfile copyWith({
    String? displayName,
    List<String>? allergies,
    List<LifestyleOption>? lifestyle,
    List<String>? customAllergies,
  }) =>
      UserProfile(
        displayName: displayName ?? this.displayName,
        allergies: allergies ?? this.allergies,
        lifestyle: lifestyle ?? this.lifestyle,
        customAllergies: customAllergies ?? this.customAllergies,
      );

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'allergies': allergies,
        'lifestyle': lifestyle.map((e) => e.name).toList(),
        'customAllergies': customAllergies,
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
