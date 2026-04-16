import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_record.dart';
import '../../core/constants/app_constants.dart';

class ScanHistoryRepository {
  Box<ScanRecord> get _box => Hive.box<ScanRecord>(AppConstants.scanHistoryBox);

  /// Returns all records sorted by newest first.
  List<ScanRecord> getAll() {
    final records = _box.values.toList();
    records.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return records;
  }

  /// Saves a record, enforcing FIFO limit of [AppConstants.maxScanHistory].
  Future<void> save(ScanRecord record) async {
    await _box.put(record.id, record);
    await _enforceSizeLimit();
  }

  /// Deletes a record by its id.
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Clears all scan history.
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// Returns a single record by id, or null if not found.
  ScanRecord? getById(String id) => _box.get(id);

  /// Searches records whose product name contains [query] (case-insensitive).
  List<ScanRecord> search(String query) {
    final q = query.toLowerCase();
    return getAll()
        .where((r) => r.product.name.toLowerCase().contains(q))
        .toList();
  }

  // Removes oldest records when over the max limit (FIFO).
  Future<void> _enforceSizeLimit() async {
    if (_box.length <= AppConstants.maxScanHistory) return;
    final records = _box.values.toList()
      ..sort((a, b) => a.scannedAt.compareTo(b.scannedAt));
    final toRemove =
        records.take(_box.length - AppConstants.maxScanHistory).toList();
    for (final r in toRemove) {
      await _box.delete(r.id);
    }
  }
}
