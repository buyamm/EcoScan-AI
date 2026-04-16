import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ai_analysis_model.dart';
import '../../../data/models/scan_record.dart';
import '../../../data/repositories/scan_history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ScanHistoryRepository _repo;

  HistoryCubit({required ScanHistoryRepository repo})
      : _repo = repo,
        super(const HistoryState()) {
    loadHistory();
  }

  /// Load all scan records from storage.
  void loadHistory() {
    emit(state.copyWith(isLoading: true));
    final records = _repo.getAll();
    emit(state.copyWith(
      allRecords: records,
      filteredRecords: _applyFilter(records, state.searchQuery, state.filterLevel),
      isLoading: false,
    ));
  }

  /// Search records by product name.
  void search(String query) {
    final filtered = _applyFilter(state.allRecords, query, state.filterLevel);
    emit(state.copyWith(
      searchQuery: query,
      filteredRecords: filtered,
    ));
  }

  /// Filter by eco score level; pass null to clear the filter.
  void filterByLevel(EcoScoreLevel? level) {
    final filtered = _applyFilter(state.allRecords, state.searchQuery, level);
    emit(state.copyWith(
      filterLevel: level,
      filteredRecords: filtered,
    ));
  }

  /// Clear all active filters and search.
  void clearFilters() {
    emit(state.copyWith(
      searchQuery: '',
      filterLevel: null,
      filteredRecords: state.allRecords,
    ));
  }

  /// Delete a single record by id.
  Future<void> deleteRecord(String id) async {
    await _repo.delete(id);
    final updated = state.allRecords.where((r) => r.id != id).toList();
    emit(state.copyWith(
      allRecords: updated,
      filteredRecords:
          _applyFilter(updated, state.searchQuery, state.filterLevel),
    ));
  }

  /// Clear all scan history.
  Future<void> clearAll() async {
    await _repo.clearAll();
    emit(const HistoryState());
  }

  List<ScanRecord> _applyFilter(
    List<ScanRecord> records,
    String query,
    EcoScoreLevel? level,
  ) {
    var result = records;
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where((r) => r.product.name.toLowerCase().contains(q))
          .toList();
    }
    if (level != null) {
      result =
          result.where((r) => r.analysis.level == level).toList();
    }
    return result;
  }
}
