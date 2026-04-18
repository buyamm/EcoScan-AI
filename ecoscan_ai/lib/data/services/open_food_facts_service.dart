import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../core/constants/app_constants.dart';

/// Custom exceptions for OpenFoodFacts API errors
class ProductNotFoundException implements Exception {
  final String barcode;
  const ProductNotFoundException(this.barcode);
  @override
  String toString() => 'Product not found for barcode: $barcode';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  @override
  String toString() => message;
}

class OpenFoodFactsService {
  final http.Client _client;

  OpenFoodFactsService({http.Client? client})
      : _client = client ?? http.Client();

  /// Fetch a product by barcode from Open Food Facts API.
  Future<ProductModel> getProduct(String barcode) async {
    final uri = Uri.parse(
        '${AppConstants.offBaseUrl}/product/$barcode.json'
        '?fields=product_name,brands,image_url,ingredients_text,ingredients,'
        'nutriments,labels_tags,allergens_tags,countries_tags,'
        'categories_tags,ecoscore_grade,nutriscore_grade');

    try {
      final response = await _client
          .get(uri, headers: {'User-Agent': 'EcoScanAI/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 404) throw ProductNotFoundException(barcode);
      if (response.statusCode != 200) {
        throw NetworkException(
            'Open Food Facts returned ${response.statusCode}');
      }

      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      final status = json['status'];
      if (status == 0 || status == '0') throw ProductNotFoundException(barcode);

      return ProductModel.fromJson(json, barcode);
    } on ProductNotFoundException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException('Không có kết nối mạng: ${e.message}');
    } on HttpException catch (e) {
      throw NetworkException('Lỗi HTTP: ${e.message}');
    } on FormatException catch (e) {
      throw NetworkException('Lỗi phân tích dữ liệu sản phẩm: ${e.message}');
    } catch (e) {
      throw NetworkException('Lỗi không xác định: $e');
    }
  }

  /// Search products by free-text keyword (AI-suggested).
  /// Primary method for finding alternatives.
  Future<List<ProductModel>> searchByKeyword(
    String keyword, {
    String excludeBarcode = '',
    int limit = 5,
  }) async {
    if (keyword.trim().isEmpty) return [];

    final uri = Uri(
      scheme: 'https',
      host: 'world.openfoodfacts.org',
      path: '/cgi/search.pl',
      queryParameters: {
        'action': 'process',
        'search_terms': keyword.trim(),
        'search_simple': '1',
        'json': '1',
        'page_size': '20',
        'fields': 'code,product_name,brands,image_url,ingredients_text,'
            'ingredients,nutriments,labels_tags,allergens_tags,countries_tags,'
            'categories_tags,ecoscore_grade,nutriscore_grade',
      },
    );

    try {
      final response = await _client
          .get(uri, headers: {'User-Agent': 'EcoScanAI/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      final products = (json['products'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .where((p) => (p['code']?.toString() ?? '') != excludeBarcode)
          .where((p) => (p['product_name']?.toString() ?? '').isNotEmpty)
          .toList()
        ..sort((a, b) => _nutriscoreIndex(a).compareTo(_nutriscoreIndex(b)));

      return products
          .take(limit)
          .map((p) => ProductModel.fromJson(
                {'product': p, 'status': 1},
                p['code']?.toString() ?? '',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fallback: search by category tags when AI/keyword search returns nothing.
  Future<List<ProductModel>> searchAlternatives(
    String category,
    String excludeBarcode, {
    String fallbackTag = '',
    List<String> allCategories = const [],
  }) async {
    const genericTags = {
      'en:beverages',
      'en:foods',
      'en:plant-based-foods',
      'en:plant-based-foods-and-beverages',
      'en:groceries',
    };

    final candidates = <String>[
      if (category.isNotEmpty) category,
      ...allCategories.reversed
          .where((c) => c != category && !genericTags.contains(c)),
      if (fallbackTag.isNotEmpty) fallbackTag,
    ];

    if (candidates.isEmpty) return [];

    for (final tag in candidates) {
      final results = await _fetchByCategory(tag, excludeBarcode);
      if (results.isNotEmpty) return results;
    }

    return [];
  }

  Future<List<ProductModel>> _fetchByCategory(
    String tag,
    String excludeBarcode,
  ) async {
    final uri = Uri(
      scheme: 'https',
      host: 'world.openfoodfacts.org',
      path: '/cgi/search.pl',
      queryParameters: {
        'action': 'process',
        'tagtype_0': 'categories',
        'tag_contains_0': 'contains',
        'tag_0': tag,
        'json': '1',
        'page_size': '20',
        'fields': 'code,product_name,brands,image_url,ingredients_text,'
            'ingredients,nutriments,labels_tags,allergens_tags,countries_tags,'
            'categories_tags,ecoscore_grade,nutriscore_grade',
      },
    );

    try {
      final response = await _client
          .get(uri, headers: {'User-Agent': 'EcoScanAI/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      final tagSuffix = tag.split(':').last;
      final products = (json['products'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .where((p) => (p['code']?.toString() ?? '') != excludeBarcode)
          .where((p) => (p['product_name']?.toString() ?? '').isNotEmpty)
          .where((p) {
            final cats = (p['categories_tags'] as List? ?? [])
                .map((c) => c.toString())
                .toList();
            return cats.any((c) => c == tag || c.contains(tagSuffix));
          })
          .toList()
        ..sort((a, b) => _nutriscoreIndex(a).compareTo(_nutriscoreIndex(b)));

      return products
          .take(5)
          .map((p) => ProductModel.fromJson(
                {'product': p, 'status': 1},
                p['code']?.toString() ?? '',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  int _nutriscoreIndex(Map<String, dynamic> p) {
    const order = ['a', 'b', 'c', 'd', 'e'];
    final grade = p['nutriscore_grade']?.toString().toLowerCase() ?? '';
    final idx = order.indexOf(grade);
    return idx == -1 ? 99 : idx;
  }
}
