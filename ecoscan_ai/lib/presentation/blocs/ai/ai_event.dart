part of 'ai_bloc.dart';

abstract class AIEvent {}

/// Analyze a product fetched via barcode/manual input.
class AnalyzeProduct extends AIEvent {
  final ProductModel product;
  AnalyzeProduct(this.product);
}

/// Analyze raw text extracted via OCR.
class AnalyzeOCRText extends AIEvent {
  final String text;
  AnalyzeOCRText(this.text);
}

/// Retry the last analysis request.
class RetryAnalysis extends AIEvent {}
