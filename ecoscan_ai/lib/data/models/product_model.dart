import 'package:hive_flutter/hive_flutter.dart';
import 'nutrition_model.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String brand;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String countries;

  @HiveField(5)
  final List<String> ingredients;

  @HiveField(6)
  final String ingredientsText;

  @HiveField(7)
  final NutritionModel? nutrition;

  @HiveField(8)
  final List<String> labels;

  @HiveField(9)
  final List<String> allergens;

  @HiveField(10)
  final String? ecoScore;

  @HiveField(11)
  final String? nutriScore;

  @HiveField(12)
  final String? category;

  ProductModel({
    required this.barcode,
    required this.name,
    required this.brand,
    this.imageUrl = '',
    this.countries = '',
    this.ingredients = const [],
    this.ingredientsText = '',
    this.nutrition,
    this.labels = const [],
    this.allergens = const [],
    this.ecoScore,
    this.nutriScore,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String barcode) {
    final product = json['product'] as Map<String, dynamic>? ?? json;

    List<String> parseStringList(dynamic val) {
      if (val == null) return [];
      if (val is List) return val.map((e) => e.toString()).toList();
      return [];
    }

    List<String> parseIngredients(dynamic val) {
      if (val == null) return [];
      if (val is List) {
        return val
            .map((e) => (e as Map<String, dynamic>?)?['text']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return [];
    }

    final nutriments = product['nutriments'];
    return ProductModel(
      barcode: barcode,
      name: product['product_name']?.toString() ?? '',
      brand: product['brands']?.toString() ?? '',
      imageUrl: product['image_url']?.toString() ?? '',
      countries: parseStringList(product['countries_tags']).join(', '),
      ingredients: parseIngredients(product['ingredients']),
      ingredientsText: product['ingredients_text']?.toString() ?? '',
      nutrition: nutriments != null
          ? NutritionModel.fromJson(nutriments as Map<String, dynamic>)
          : null,
      labels: parseStringList(product['labels_tags']),
      allergens: parseStringList(product['allergens_tags']),
      ecoScore: product['ecoscore_grade']?.toString(),
      nutriScore: product['nutriscore_grade']?.toString(),
      category: parseStringList(product['categories_tags']).isNotEmpty
          ? parseStringList(product['categories_tags']).first
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'name': name,
        'brand': brand,
        'imageUrl': imageUrl,
        'countries': countries,
        'ingredients': ingredients,
        'ingredientsText': ingredientsText,
        'nutrition': nutrition?.toJson(),
        'labels': labels,
        'allergens': allergens,
        'ecoScore': ecoScore,
        'nutriScore': nutriScore,
        'category': category,
      };

  /// Creates a minimal placeholder used for deep-link navigation before data loads.
  factory ProductModel.empty({String barcode = ''}) => ProductModel(
        barcode: barcode,
        name: '',
        brand: '',
      );

  factory ProductModel.fromStoredJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      countries: json['countries'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      ingredientsText: json['ingredientsText'] ?? '',
      nutrition: json['nutrition'] != null
          ? NutritionModel.fromJson(json['nutrition'])
          : null,
      labels: List<String>.from(json['labels'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
      ecoScore: json['ecoScore'],
      nutriScore: json['nutriScore'],
      category: json['category'],
    );
  }
}
