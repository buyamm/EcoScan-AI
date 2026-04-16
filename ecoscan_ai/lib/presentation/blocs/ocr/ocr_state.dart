part of 'ocr_bloc.dart';

abstract class OCRState {}

class OCRInitial extends OCRState {}

/// Camera is active and scanning for text.
class OCRScanning extends OCRState {}

/// Text was recognized but no ingredient section detected yet.
class OCRTextDetected extends OCRState {
  final String rawText;
  OCRTextDetected(this.rawText);
}

/// Ingredients section was found; ready to send for AI analysis.
class OCRIngredientsFound extends OCRState {
  final String rawText;
  final List<String> ingredients;
  OCRIngredientsFound({required this.rawText, required this.ingredients});
}

/// Processing a static image.
class OCRProcessing extends OCRState {}

/// User confirmed the text; downstream can trigger AI analysis.
class OCRConfirmed extends OCRState {
  final String confirmedText;
  OCRConfirmed(this.confirmedText);
}

class OCRError extends OCRState {
  final String message;
  OCRError(this.message);
}
