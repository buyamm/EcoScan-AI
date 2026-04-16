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
  /// Throws [ProductNotFoundException] if not found (status=0 or 404).
  /// Throws [NetworkException] on connectivity/timeout issues.
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

      if (response.statusCode == 404) {
        throw ProductNotFoundException(barcode);
      }

      if (response.statusCode != 200) {
        throw NetworkException(
            'Open Food Facts returned ${response.statusCode}');
      }

      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      // OFF returns status=0 when product is not found
      final status = json['status'];
      if (status == 0 || status == '0') {
        throw ProductNotFoundException(barcode);
      }

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

  /// Search for alternative products in the same category.
  /// Returns a list of products excluding the one with [excludeBarcode].
  Future<List<ProductModel>> searchAlternatives(
    String category,
    String excludeBarcode,
  ) async {
    if (category.isEmpty) return [];

    // Encode category for URL (e.g. "en:beverages" → safe for query param)
    final encodedCategory = Uri.encodeComponent(category);
    final uri = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl'
        '?action=process'
        '&tagtype_0=categories'
        '&tag_contains_0=contains'
        '&tag_0=$encodedCategory'
        '&sort_by=ecoscore_score'
        '&page_size=10'
        '&json=1'
        '&fields=code,product_name,brands,image_url,ingredients_text,'
        'ingredients,nutriments,labels_tags,allergens_tags,countries_tags,'
        'categories_tags,ecoscore_grade,nutriscore_grade');

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
          .take(5)
          .map((p) => ProductModel.fromJson(
                {'product': p, 'status': 1},
                p['code']?.toString() ?? '',
              ))
          .toList();

      return products;
    } catch (_) {
      // Alternatives are best-effort; swallow errors gracefully
      return [];
    }
  }
}
