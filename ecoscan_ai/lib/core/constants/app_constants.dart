class AppConstants {
  AppConstants._();

  // Groq API (free tier, OpenAI-compatible)
  // Value is injected at build time via --dart-define-from-file=.env
  static const String groqApiKey =
      String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String groqModel = 'llama-3.3-70b-versatile';
  static const int groqTimeoutSeconds = 15;

  // Open Food Facts API
  static const String offBaseUrl = 'https://world.openfoodfacts.org/api/v2';

  // Hive box names
  static const String scanHistoryBox = 'scan_history';
  static const String cachedProductsBox = 'cached_products';

  // SharedPreferences keys
  static const String keyUserProfile = 'user_profile';
  static const String keyAppLanguage = 'app_language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyNotificationEnabled = 'notification_enabled';
  static const String keyFontSize = 'font_size';

  // Limits
  static const int maxScanHistory = 500;
  static const int productCacheDays = 7;

  // Eco Score thresholds
  static const int ecoScoreGoodMin = 70;
  static const int ecoScoreAverageMin = 40;
}
