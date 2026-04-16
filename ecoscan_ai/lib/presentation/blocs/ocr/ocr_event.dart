part of 'ocr_bloc.dart';

abstract class OCREvent {}

/// Start the OCR camera session.
class StartOCR extends OCREvent {}

/// A camera frame is ready for text recognition.
class ProcessOCRFrame extends OCREvent {
  final InputImage image;
  ProcessOCRFrame(this.image);
}

/// User picked a static image from the gallery.
class ProcessStaticImage extends OCREvent {
  final InputImage image;
  ProcessStaticImage(this.image);
}

/// User confirmed/edited the extracted text and wants to proceed.
class ConfirmOCRText extends OCREvent {
  final String text;
  ConfirmOCRText(this.text);
}

/// Reset the OCR flow back to initial state.
class ResetOCR extends OCREvent {}
