import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/ai_analysis_model.dart';
import '../../core/constants/app_constants.dart';

/// Caches [AIAnalysisModel] results keyed by product barcode.
/// Cache key for OCR scans (no barcode) is the SHA-like hash of the
/// ingredients text — callers should pass a stable key.
class AIAnalysisCacheRepository {
  Box<String> get _box =>
      Hive.box<String>(AppConstants.aiAnalysisCacheBox);

  /// Returns a cached [AIAnalysisModel] for [key], or null if expired / missing.
  AIAnalysisModel? get(String key) {
    if (key.isEmpty) return null;
    final raw = _box.get(key);
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(map['_cachedAt'] as String);
      if (DateTime.now().difference(cachedAt).inDays >=
          AppConstants.aiAnalysisCacheDays) {
        _box.delete(key);
        return null;
      }
      return AIAnalysisModel.fromJson(map);
    } catch (_) {
      _box.delete(key);
      return null;
    }
  }

  /// Stores [analysis] in cache under [key] with current timestamp.
  Future<void> put(String key, AIAnalysisModel analysis) async {
    if (key.isEmpty) return;
    final map = analysis.toJson();
    map['_cachedAt'] = DateTime.now().toIso8601String();
    await _box.put(key, jsonEncode(map));
  }

  /// Removes a single cached entry.
  Future<void> remove(String key) async => _box.delete(key);

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
            AppConstants.aiAnalysisCacheDays) {
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

  /// Clears all cached analyses.
  Future<void> clearAll() async => _box.clear();

  int get cacheSize => _box.length;
}
