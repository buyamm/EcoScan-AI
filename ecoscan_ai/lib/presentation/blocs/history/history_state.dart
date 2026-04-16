part of 'history_cubit.dart';

class HistoryState {
  final List<ScanRecord> allRecords;
  final List<ScanRecord> filteredRecords;
  final String searchQuery;
  final EcoScoreLevel? filterLevel;
  final bool isLoading;

  const HistoryState({
    this.allRecords = const [],
    this.filteredRecords = const [],
    this.searchQuery = '',
    this.filterLevel,
    this.isLoading = false,
  });

  bool get isEmpty => allRecords.isEmpty;

  HistoryState copyWith({
    List<ScanRecord>? allRecords,
    List<ScanRecord>? filteredRecords,
    String? searchQuery,
    Object? filterLevel = _sentinel,
    bool? isLoading,
  }) =>
      HistoryState(
        allRecords: allRecords ?? this.allRecords,
        filteredRecords: filteredRecords ?? this.filteredRecords,
        searchQuery: searchQuery ?? this.searchQuery,
        filterLevel:
            filterLevel == _sentinel ? this.filterLevel : filterLevel as EcoScoreLevel?,
        isLoading: isLoading ?? this.isLoading,
      );
}

const _sentinel = Object();
