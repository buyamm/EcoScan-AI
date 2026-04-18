import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/ai_analysis_model.dart';
import '../models/product_model.dart';
import '../models/user_profile.dart';
import '../../core/constants/app_constants.dart';

/// Thrown when the Groq API returns 429 rate-limit.
class RateLimitException implements Exception {
  /// Suggested seconds to wait before retrying (default 60).
  final int retryAfterSeconds;
  const RateLimitException({this.retryAfterSeconds = 60});
  @override
  String toString() =>
      'Groq API rate limit exceeded. Retry after ${retryAfterSeconds}s.';
}

/// Thrown for non-rate-limit API errors.
class GroqApiException implements Exception {
  final String message;
  final int? statusCode;
  const GroqApiException(this.message, {this.statusCode});
  @override
  String toString() => 'GroqApiException($statusCode): $message';
}

class GroqService {
  final http.Client _client;

  GroqService({http.Client? client}) : _client = client ?? http.Client();

  /// Analyze a product using Groq LLM.
  /// Optionally inject [userProfile] to personalize the prompt.
  ///
  /// Returns a parsed [AIAnalysisModel].
  /// Falls back to [AIAnalysisModel.fallback] when JSON cannot be parsed.
  /// Throws [RateLimitException] on 429, [GroqApiException] on other API errors.
  Future<AIAnalysisModel> analyzeProduct(
    ProductModel product, {
    UserProfile? userProfile,
  }) async {
    final prompt = _buildPrompt(product, userProfile);

    final body = jsonEncode({
      'model': AppConstants.groqModel,
      'messages': [
        {
          'role': 'system',
          'content':
              'Bạn là chuyên gia phân tích thành phần sản phẩm tiêu dùng. '
                  'Luôn trả về JSON hợp lệ, súc tích, bằng tiếng Việt.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'response_format': {'type': 'json_object'},
      'temperature': 0.3,
    });

    try {
      final response = await _client
          .post(
            Uri.parse('${AppConstants.groqBaseUrl}/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConstants.groqApiKey}',
            },
            body: body,
          )
          .timeout(Duration(seconds: AppConstants.groqTimeoutSeconds));

      if (response.statusCode == 429) {
        final retryAfter = _parseRetryAfter(response);
        throw RateLimitException(retryAfterSeconds: retryAfter);
      }

      if (response.statusCode != 200) {
        throw GroqApiException(
          'Groq API error: ${response.body}',
          statusCode: response.statusCode,
        );
      }

      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      final content = decoded['choices']?[0]?['message']?['content'];
      if (content == null) {
        return AIAnalysisModel.fallback('Không có nội dung phản hồi từ AI.');
      }

      return _parseAnalysis(content.toString());
    } on RateLimitException {
      rethrow;
    } on GroqApiException {
      rethrow;
    } on SocketException {
      throw GroqApiException('Không có kết nối mạng.');
    } catch (e) {
      // Timeout or unexpected errors → return fallback rather than crashing
      return AIAnalysisModel.fallback('Lỗi phân tích: $e');
    }
  }

  // ─── Private helpers ────────────────────────────────────────────────────────

  String _buildPrompt(ProductModel product, UserProfile? profile) {
    final sb = StringBuffer();
    sb.writeln('Phân tích sản phẩm sau:');
    sb.writeln('Tên: ${product.name}');
    sb.writeln('Thương hiệu: ${product.brand}');
    sb.writeln('Xuất xứ: ${product.countries}');

    final ingredientsDisplay = product.ingredientsText.isNotEmpty
        ? product.ingredientsText
        : product.ingredients.join(', ');
    sb.writeln('Thành phần: $ingredientsDisplay');
    sb.writeln('Nhãn/Tuyên bố: ${product.labels.join(', ')}');

    if (profile != null && profile.allAllergies.isNotEmpty) {
      sb.writeln('');
      sb.writeln(
          'Người dùng có dị ứng với: ${profile.allAllergies.join(', ')}. '
          'Hãy đặc biệt cảnh báo nếu sản phẩm chứa các chất này.');
    }
    if (profile != null && profile.lifestyle.isNotEmpty) {
      final lifestyleLabels = profile.lifestyle.map((l) {
        switch (l) {
          case LifestyleOption.vegan:
            return 'thuần chay';
          case LifestyleOption.vegetarian:
            return 'ăn chay';
          case LifestyleOption.ecoConscious:
            return 'thân thiện môi trường';
          case LifestyleOption.crueltyFreeOnly:
            return 'không thử nghiệm trên động vật';
        }
      }).join(', ');
      sb.writeln('Lối sống của người dùng: $lifestyleLabels.');
    }
    if (profile != null && profile.dietaryPreferences.isNotEmpty) {
      final dietLabels = profile.dietaryPreferences.map((d) {
        switch (d) {
          case DietaryPreference.glutenFree:
            return 'không gluten';
          case DietaryPreference.lactoseFree:
            return 'không lactose';
          case DietaryPreference.lowSugar:
            return 'ít đường';
          case DietaryPreference.lowSalt:
            return 'ít muối';
          case DietaryPreference.keto:
            return 'keto';
          case DietaryPreference.paleo:
            return 'paleo';
        }
      }).join(', ');
      sb.writeln('Chế độ ăn của người dùng: $dietLabels. '
          'Hãy cảnh báo nếu sản phẩm không phù hợp với chế độ ăn này.');
    }

    sb.writeln('');
    sb.writeln('Trả về JSON với cấu trúc sau (không thêm markdown):');
    sb.writeln('''{"overall_score":<0-100>,"health":{"score":<0-100>,"concerns":[...],"positives":[...]},"environment":{"score":<0-100>,"concerns":[...],"positives":[...]},"ethics":{"score":<0-100>,"cruelty_free":<true|false|null>,"vegan":<true|false|null>,"concerns":[...]},"greenwashing":{"level":"none|suspected|confirmed","claims":[{"claim":"...","reality":"..."}]},"ingredients_analysis":[{"name":"...","explanation":"...","safety":"safe|caution|avoid"}],"suitable_for":[...],"not_suitable_for":[...],"summary":"..."}''');

    return sb.toString();
  }

  AIAnalysisModel _parseAnalysis(String content) {
    // Strip potential markdown code fences
    String cleaned = content.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned
          .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
          .replaceFirst(RegExp(r'\s*```$'), '')
          .trim();
    }

    try {
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return AIAnalysisModel.fromJson(json);
    } on FormatException {
      // Malformed JSON → return fallback with raw content preserved
      return AIAnalysisModel.fallback(content);
    }
  }

  int _parseRetryAfter(http.Response response) {
    final header = response.headers['retry-after'];
    if (header != null) {
      return int.tryParse(header) ?? 60;
    }
    return 60;
  }
}
