import 'package:hive_flutter/hive_flutter.dart';

part 'nutrition_model.g.dart';

@HiveType(typeId: 0)
class NutritionModel extends HiveObject {
  @HiveField(0)
  final double? energyKcal;

  @HiveField(1)
  final double? fat;

  @HiveField(2)
  final double? saturatedFat;

  @HiveField(3)
  final double? carbohydrates;

  @HiveField(4)
  final double? sugars;

  @HiveField(5)
  final double? fiber;

  @HiveField(6)
  final double? proteins;

  @HiveField(7)
  final double? salt;

  @HiveField(8)
  final double? sodium;

  NutritionModel({
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.carbohydrates,
    this.sugars,
    this.fiber,
    this.proteins,
    this.salt,
    this.sodium,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    double? parseNum(dynamic v) =>
        v == null ? null : double.tryParse(v.toString());
    return NutritionModel(
      energyKcal: parseNum(json['energy-kcal_100g']),
      fat: parseNum(json['fat_100g']),
      saturatedFat: parseNum(json['saturated-fat_100g']),
      carbohydrates: parseNum(json['carbohydrates_100g']),
      sugars: parseNum(json['sugars_100g']),
      fiber: parseNum(json['fiber_100g']),
      proteins: parseNum(json['proteins_100g']),
      salt: parseNum(json['salt_100g']),
      sodium: parseNum(json['sodium_100g']),
    );
  }

  Map<String, dynamic> toJson() => {
        'energy-kcal_100g': energyKcal,
        'fat_100g': fat,
        'saturated-fat_100g': saturatedFat,
        'carbohydrates_100g': carbohydrates,
        'sugars_100g': sugars,
        'fiber_100g': fiber,
        'proteins_100g': proteins,
        'salt_100g': salt,
        'sodium_100g': sodium,
      };
}
