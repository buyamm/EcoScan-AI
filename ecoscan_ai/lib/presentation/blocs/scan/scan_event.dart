part of 'scan_bloc.dart';

abstract class ScanEvent {}

/// Start the camera scanner session.
class StartScan extends ScanEvent {}

/// A barcode was detected by the camera scanner.
class BarcodeScanned extends ScanEvent {
  final String barcode;
  BarcodeScanned(this.barcode);
}

/// User manually typed a barcode string.
class ManualBarcodeEntered extends ScanEvent {
  final String barcode;
  ManualBarcodeEntered(this.barcode);
}

/// Retry the last failed product fetch.
class RetryFetch extends ScanEvent {}
