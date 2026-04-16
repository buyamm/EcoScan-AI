import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../../core/constants/app_constants.dart';

class ProductCacheRepository {
  // Hive box stores raw JSON strings to avoid nested Hive adapter complexity.
  Box<String> get _box =>
      Hive.box<String>(AppConstants.cachedProductsBox);

  /// Returns a cached [ProductModel] for [barcode], or null if expired / missing.
  ProductModel? get(String barcode) {
    final raw = _box.get(barcode);
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(map['_cachedAt'] as String);
      if (DateTime.now().difference(cachedAt).inDays >=
          AppConstants.productCacheDays) {
        _box.delete(barcode);
        return null;
      }
      return ProductModel.fromStoredJson(map);
    } catch (_) {
      _box.delete(barcode);
      return null;
    }
  }

  /// Stores [product] in cache with current timestamp.
  Future<void> put(ProductModel product) async {
    final map = product.toJson();
    map['_cachedAt'] = DateTime.now().toIso8601String();
    await _box.put(product.barcode, jsonEncode(map));
  }

  /// Removes a single cached entry.
  Future<void> remove(String barcode) async {
    await _box.delete(barcode);
  }

  /// Removes all expired entries.
  Future<void> purgeExpired() async {
    final expiredKeys = <String>[];
    for (final key in _box.keys) {
      final raw = _box.get(key as String);
      if (raw == null) continue;
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final cachedAt = DateTime.parse(map['_cachedAt'] as String);
        if (DateTime.now().difference(cachedAt).inDays >=
            AppConstants.productCacheDays) {
          expiredKeys.add(key);
        }
      } catch (_) {
        expiredKeys.add(key);
      }
    }
    for (final k in expiredKeys) {
      await _box.delete(k);
    }
  }

  /// Clears all cached products.
  Future<void> clearAll() async {
    await _box.clear();
  }

  int get cacheSize => _box.length;
}
