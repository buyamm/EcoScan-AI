import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../data/services/ocr_service.dart';

part 'ocr_event.dart';
part 'ocr_state.dart';

class OCRBloc extends Bloc<OCREvent, OCRState> {
  final OcrService _ocrService;

  /// Debounce timer to avoid processing too many camera frames per second.
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(seconds: 1);

  /// Minimum text length to emit OCRTextDetected from a stream frame.
  static const _minStreamTextLength = 20;

  OCRBloc({required OcrService ocrService})
      : _ocrService = ocrService,
        super(OCRInitial()) {
    on<StartOCR>(_onStartOCR);
    on<ProcessOCRFrame>(_onProcessFrame);
    on<ProcessStaticImage>(_onProcessStaticImage);
    on<ConfirmOCRText>(_onConfirmText);
    on<ResetOCR>(_onReset);
  }

  void _onStartOCR(StartOCR event, Emitter<OCRState> emit) {
    emit(OCRScanning());
  }

  Future<void> _onProcessFrame(
      ProcessOCRFrame event, Emitter<OCRState> emit) async {
    // Skip if already in a terminal/processing state to avoid flooding
    if (state is OCRIngredientsFound || state is OCRConfirmed) return;

    // Debounce: cancel any pending timer and schedule a new one
    _debounceTimer?.cancel();
    final completer = Completer<void>();
    _debounceTimer = Timer(_debounceDuration, () => completer.complete());
    await completer.future;

    // After debounce, check state again in case it changed
    if (state is OCRIngredientsFound || state is OCRConfirmed) return;

    try {
      final result = await _ocrService.recognizeFromImage(event.image);
      if (result.rawText.isEmpty) return;

      if (result.hasIngredients) {
        emit(OCRIngredientsFound(
          rawText: result.rawText,
          ingredients: result.ingredients,
        ));
      } else if (result.rawText.length >= _minStreamTextLength) {
        // Only emit for stream frames when text is long enough to be meaningful
        emit(OCRTextDetected(result.rawText));
      }
    } catch (e) {
      // Frame errors are non-fatal; only emit error on static image failures
    }
  }

  Future<void> _onProcessStaticImage(
      ProcessStaticImage event, Emitter<OCRState> emit) async {
    emit(OCRProcessing());
    try {
      final result = await _ocrService.recognizeFromImage(event.image);
      if (result.hasIngredients) {
        emit(OCRIngredientsFound(
          rawText: result.rawText,
          ingredients: result.ingredients,
        ));
      } else if (result.rawText.isNotEmpty) {
        emit(OCRTextDetected(result.rawText));
      } else {
        emit(OCRError(
            'Không nhận dạng được văn bản. Hãy thử cải thiện ánh sáng và khoảng cách.'));
      }
    } catch (e) {
      emit(OCRError('Lỗi xử lý ảnh: $e'));
    }
  }

  void _onConfirmText(ConfirmOCRText event, Emitter<OCRState> emit) {
    emit(OCRConfirmed(event.text));
  }

  void _onReset(ResetOCR event, Emitter<OCRState> emit) {
    _debounceTimer?.cancel();
    emit(OCRInitial());
  }

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    await _ocrService.dispose();
    return super.close();
  }
}
