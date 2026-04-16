part of 'scan_bloc.dart';

abstract class ScanState {}

/// Initial idle state before scanning starts.
class ScanInitial extends ScanState {}

/// Camera is active and listening for barcodes.
class ScanActive extends ScanState {}

/// A valid barcode has been detected; about to fetch product.
class BarcodeDetected extends ScanState {
  final String barcode;
  BarcodeDetected(this.barcode);
}

/// Fetching product data from API / cache.
class ScanLoading extends ScanState {
  final String barcode;
  ScanLoading(this.barcode);
}

/// Product data successfully retrieved.
class ScanSuccess extends ScanState {
  final ProductModel product;
  /// Whether data came from local cache.
  final bool fromCache;
  ScanSuccess(this.product, {this.fromCache = false});
}

/// An error occurred during scanning or product fetch.
class ScanError extends ScanState {
  final String message;
  final ScanErrorType type;
  /// The barcode that triggered the error (for retry).
  final String? barcode;

  ScanError({required this.message, required this.type, this.barcode});
}

enum ScanErrorType {
  productNotFound,
  networkError,
  cameraPermissionDenied,
  unknown,
}
