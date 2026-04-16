import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_cache_repository.dart';
import '../../../data/services/open_food_facts_service.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final OpenFoodFactsService _offService;
  final ProductCacheRepository _cacheRepo;

  /// Keeps the last barcode for retry support.
  String? _lastBarcode;

  ScanBloc({
    required OpenFoodFactsService offService,
    required ProductCacheRepository cacheRepo,
  })  : _offService = offService,
        _cacheRepo = cacheRepo,
        super(ScanInitial()) {
    on<StartScan>(_onStartScan);
    on<BarcodeScanned>(_onBarcodeScanned);
    on<ManualBarcodeEntered>(_onManualBarcodeEntered);
    on<RetryFetch>(_onRetryFetch);
  }

  void _onStartScan(StartScan event, Emitter<ScanState> emit) {
    emit(ScanActive());
  }

  Future<void> _onBarcodeScanned(
      BarcodeScanned event, Emitter<ScanState> emit) async {
    // Avoid re-fetching if same barcode already in progress or succeeded
    if (state is ScanLoading || state is ScanSuccess) return;
    await _fetchProduct(event.barcode, emit);
  }

  Future<void> _onManualBarcodeEntered(
      ManualBarcodeEntered event, Emitter<ScanState> emit) async {
    await _fetchProduct(event.barcode, emit);
  }

  Future<void> _onRetryFetch(
      RetryFetch event, Emitter<ScanState> emit) async {
    if (_lastBarcode == null) return;
    await _fetchProduct(_lastBarcode!, emit);
  }

  Future<void> _fetchProduct(
      String barcode, Emitter<ScanState> emit) async {
    _lastBarcode = barcode;
    emit(BarcodeDetected(barcode));

    // Check cache first
    final cached = _cacheRepo.get(barcode);
    if (cached != null) {
      emit(ScanSuccess(cached, fromCache: true));
      return;
    }

    emit(ScanLoading(barcode));

    try {
      final product = await _offService.getProduct(barcode);
      // Store in cache for future lookups
      await _cacheRepo.put(product);
      emit(ScanSuccess(product));
    } on ProductNotFoundException {
      emit(ScanError(
        message: 'Không tìm thấy sản phẩm với mã vạch $barcode.',
        type: ScanErrorType.productNotFound,
        barcode: barcode,
      ));
    } on NetworkException catch (e) {
      emit(ScanError(
        message: e.message,
        type: ScanErrorType.networkError,
        barcode: barcode,
      ));
    } catch (e) {
      emit(ScanError(
        message: 'Lỗi không xác định: $e',
        type: ScanErrorType.unknown,
        barcode: barcode,
      ));
    }
  }
}
