import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Result from an OCR recognition pass.
class OcrResult {
  /// Full raw text extracted from the image.
  final String rawText;

  /// Extracted ingredient list (may be empty if no ingredients section found).
  final List<String> ingredients;

  /// Whether a clear ingredients section was detected.
  final bool hasIngredients;

  const OcrResult({
    required this.rawText,
    required this.ingredients,
    required this.hasIngredients,
  });
}

class OcrService {
  final TextRecognizer _recognizer;

  OcrService()
      : _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// Recognizes text from an [InputImage] (camera frame or static file).
  /// Returns an [OcrResult] with raw text and parsed ingredients.
  Future<OcrResult> recognizeFromImage(InputImage image) async {
    final recognized = await _recognizer.processImage(image);
    final rawText = recognized.text;
    return _buildResult(rawText);
  }

  /// Extracts and parses ingredients from a raw OCR text string.
  /// Useful when the caller already has the text (e.g. from a previous scan).
  OcrResult extractFromText(String rawText) => _buildResult(rawText);

  /// Extract only the ingredient list from raw text. Returns empty list when
  /// no ingredient section is found.
  List<String> extractIngredients(String rawText) =>
      _buildResult(rawText).ingredients;

  /// Releases the underlying ML Kit recognizer. Call when the service is
  /// no longer needed to free native resources.
  Future<void> dispose() => _recognizer.close();

  // ─── Private helpers ────────────────────────────────────────────────────────

  OcrResult _buildResult(String rawText) {
    final ingredients = _parseIngredients(rawText);
    return OcrResult(
      rawText: rawText,
      ingredients: ingredients,
      hasIngredients: ingredients.isNotEmpty,
    );
  }

  /// Attempts to locate and split an ingredients section from [rawText].
  ///
  /// Strategy:
  /// 1. Find a line containing an ingredient header keyword.
  /// 2. Take text from that point until an end-marker (nutrition table, etc.).
  /// 3. Split on commas and semicolons to get individual items.
  List<String> _parseIngredients(String rawText) {
    if (rawText.trim().isEmpty) return [];

    final lower = rawText.toLowerCase();

    // Header keywords in order of priority (Vietnamese + English)
    final headers = [
      'thành phần',
      'nguyên liệu',
      'ingredients',
      'ingredient',
      'ingrédients',
      'zutaten',
    ];

    // Markers that indicate we've left the ingredient section
    final stopMarkers = [
      'thông tin dinh dưỡng',
      'nutrition facts',
      'nutrition information',
      'hướng dẫn sử dụng',
      'cách dùng',
      'bảo quản',
      'storage',
      'directions',
      'best before',
      'hạn sử dụng',
    ];

    int startIdx = -1;
    for (final header in headers) {
      final idx = lower.indexOf(header);
      if (idx != -1) {
        // Move past the header word itself
        startIdx = idx + header.length;
        break;
      }
    }

    if (startIdx == -1) return [];

    // Find first stop marker after the start
    int endIdx = rawText.length;
    for (final stop in stopMarkers) {
      final idx = lower.indexOf(stop, startIdx);
      if (idx != -1 && idx < endIdx) {
        endIdx = idx;
      }
    }

    final section = rawText.substring(startIdx, endIdx).trim();
    if (section.isEmpty) return [];

    // Split on commas, semicolons, or newlines; clean up each token
    final items = section
        .split(RegExp(r'[,;\n]+'))
        .map((s) => _cleanIngredient(s))
        .where((s) => s.isNotEmpty && s.length > 1)
        .toList();

    return items;
  }

  String _cleanIngredient(String raw) {
    return raw
        .trim()
        // Remove leading colon/dot/dash that sometimes follows the header
        .replaceAll(RegExp(r'^[:.\-\s]+'), '')
        // Remove trailing punctuation
        .replaceAll(RegExp(r'[.]+$'), '')
        // Collapse multiple spaces
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
