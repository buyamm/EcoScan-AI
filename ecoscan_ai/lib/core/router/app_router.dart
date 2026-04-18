import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/scan_record.dart';
import '../../data/models/user_profile.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/about_screen.dart';
import '../../presentation/screens/achievement_detail_screen.dart';
import '../../presentation/screens/achievement_list_screen.dart';
import '../../presentation/screens/ai_error_screen.dart';
import '../../presentation/screens/ai_explanation_screen.dart';
import '../../presentation/screens/ai_loading_screen.dart';
import '../../presentation/screens/ai_personalized_screen.dart';
import '../../presentation/screens/allergen_warning_screen.dart';
import '../../presentation/screens/allergy_detail_screen.dart';
import '../../presentation/screens/alternative_detail_screen.dart';
import '../../presentation/screens/alternative_products_screen.dart';
import '../../presentation/screens/api_key_screen.dart';
import '../../presentation/screens/barcode_not_readable_screen.dart';
import '../../presentation/screens/cache_screen.dart';
import '../../presentation/screens/camera_permission_screen.dart';
import '../../presentation/screens/category_breakdown_screen.dart';
import '../../presentation/screens/contribute_product_screen.dart';
import '../../presentation/screens/credits_screen.dart';
import '../../presentation/screens/custom_allergy_screen.dart';
import '../../presentation/screens/data_usage_screen.dart';
import '../../presentation/screens/delete_confirm_screen.dart';
import '../../presentation/screens/delete_data_screen.dart';
import '../../presentation/screens/dietary_preference_screen.dart';
import '../../presentation/screens/eco_goal_screen.dart';
import '../../presentation/screens/eco_preference_screen.dart';
import '../../presentation/screens/eco_score_explain_screen.dart';
import '../../presentation/screens/eco_trend_screen.dart';
import '../../presentation/screens/edit_allergies_screen.dart';
import '../../presentation/screens/edit_lifestyle_screen.dart';
import '../../presentation/screens/environment_analysis_screen.dart';
import '../../presentation/screens/ethics_analysis_screen.dart';
import '../../presentation/screens/export_data_screen.dart';
import '../../presentation/screens/feedback_screen.dart';
import '../../presentation/screens/font_size_screen.dart';
import '../../presentation/screens/greenwashing_detail_screen.dart';
import '../../presentation/screens/greenwashing_detector_screen.dart';
import '../../presentation/screens/health_analysis_screen.dart';
import '../../presentation/screens/health_goal_screen.dart';
import '../../presentation/screens/help_screen.dart';
import '../../presentation/screens/history_detail_screen.dart';
import '../../presentation/screens/history_empty_screen.dart';
import '../../presentation/screens/history_filter_screen.dart';
import '../../presentation/screens/history_search_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/impact_chart_screen.dart';
import '../../presentation/screens/impact_empty_screen.dart';
import '../../presentation/screens/ingredient_breakdown_screen.dart';
import '../../presentation/screens/ingredient_detail_screen.dart';
import '../../presentation/screens/language_screen.dart';
import '../../presentation/screens/lifestyle_conflict_screen.dart';
import '../../presentation/screens/lifestyle_detail_screen.dart';
import '../../presentation/screens/manual_input_screen.dart';
import '../../presentation/screens/milestone_screen.dart';
import '../../presentation/screens/monthly_report_screen.dart';
import '../../presentation/screens/network_error_screen.dart';
import '../../presentation/screens/notification_preference_screen.dart';
import '../../presentation/screens/notification_screen.dart';
import '../../presentation/screens/nutrition_detail_screen.dart';
import '../../presentation/screens/ocr_edit_screen.dart';
import '../../presentation/screens/ocr_result_screen.dart';
import '../../presentation/screens/ocr_scan_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/open_source_screen.dart';
import '../../presentation/screens/permissions_screen.dart';
import '../../presentation/screens/personal_impact_screen.dart';
import '../../presentation/screens/personal_insight_screen.dart';
import '../../presentation/screens/personalized_warning_screen.dart';
import '../../presentation/screens/privacy_policy_screen.dart';
import '../../presentation/screens/product_compare_screen.dart';
import '../../presentation/screens/product_detail_screen.dart';
import '../../presentation/screens/product_found_screen.dart';
import '../../presentation/screens/product_image_screen.dart';
import '../../presentation/screens/product_not_found_screen.dart';
import '../../presentation/screens/profile_achievement_screen.dart';
import '../../presentation/screens/profile_complete_screen.dart';
import '../../presentation/screens/profile_edit_screen.dart';
import '../../presentation/screens/profile_setup_screen.dart';
import '../../presentation/screens/profile_summary_screen.dart';
import '../../presentation/screens/recommendation_screen.dart';
import '../../presentation/screens/scan_history_screen.dart';
import '../../presentation/screens/scan_loading_screen.dart';
import '../../presentation/screens/scan_screen.dart';
import '../../presentation/screens/scan_success_screen.dart';
import '../../presentation/screens/scan_tips_screen.dart';
import '../../presentation/screens/score_breakdown_screen.dart';
import '../../presentation/screens/score_history_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/share_impact_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/suitable_audience_screen.dart';
import '../../presentation/screens/terms_screen.dart';
import '../../presentation/screens/theme_screen.dart';
import '../../presentation/screens/top_products_screen.dart';
import '../../presentation/screens/tutorial_screen.dart';
import '../../presentation/screens/update_screen.dart';
import '../../presentation/screens/user_profile_screen.dart';
import '../../presentation/screens/weekly_report_screen.dart';
import '../../presentation/screens/worst_products_screen.dart';

/// Central router definition for EcoScan AI.
/// All 100 routes are defined here.
///
/// ─── Main Navigation Flows ───────────────────────────────────────────────────
///
/// 1. Barcode Flow:
///    /scan → /scan/loading → /product/found → /product/detail
///         → /product/score → /product/alternatives
///    - User scans a barcode; ScanBloc fetches product from Open Food Facts.
///    - ProductFoundScreen lets user view detail (triggers AI) or analyze directly.
///    - AILoadingScreen listens to AIBloc and routes to allergen/lifestyle/score.
///    - ScoreBreakdownScreen shows alternatives button when score < 70.
///
/// 2. OCR Flow:
///    /scan/ocr → /scan/ocr/result → /scan/ocr/edit (optional)
///             → /ai/loading → /product/score
///    - User captures ingredient label; ML Kit extracts text.
///    - OCRResultScreen lets user confirm or edit text before AI analysis.
///    - AIBloc dispatches AnalyzeOCRText; AILoadingScreen handles routing.
///
/// 3. Manual Flow:
///    /scan/manual → /scan/loading → /product/found → /product/detail
///                → /product/score → /product/alternatives
///    - User types a barcode manually; same flow as barcode after lookup.
///
/// 4. History Flow:
///    /history → /history/detail → (view saved analysis without API calls)
///    - ScanHistoryScreen lists all saved ScanRecords from Hive.
///    - HistoryDetailScreen re-renders the full analysis from local data.
///    - Supports search (/history/search) and filter (/history/filter).
///
/// 5. Profile Flow:
///    /profile → /profile/allergies → /profile/lifestyle → /profile/dietary
///    - UserProfileScreen shows summary chips (red=allergens, green=lifestyle, orange=dietary).
///    - Each sub-screen saves changes to SharedPreferences immediately.
///    - Profile data is injected into Groq prompts on next AI analysis.
///
/// ─────────────────────────────────────────────────────────────────────────────
class AppRouter {
  AppRouter._();

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        ..._splashAndOnboarding(),
        _shellRoute(),
        ..._scanRoutes(),
        ..._productRoutes(),
        ..._aiAndErrorRoutes(),
        ..._historyRoutes(),
        ..._profileRoutes(),
        ..._impactRoutes(),
        ..._achievementRoutes(),
        ..._settingsRoutes(),
      ],
    );
  }

  // ─── Splash + Onboarding ─────────────────────────────────────────────────

  static List<GoRoute> _splashAndOnboarding() => [
        GoRoute(
          path: '/splash',
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/onboarding/:page',
          builder: (_, state) {
            final page =
                int.tryParse(state.pathParameters['page'] ?? '1') ?? 1;
            return OnboardingScreen(pageIndex: page);
          },
        ),
      ];

  // ─── Shell Route (Bottom Navigation) ─────────────────────────────────────

  static ShellRoute _shellRoute() => ShellRoute(
        builder: (_, __, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/scan',
            builder: (_, __) => const ScanScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (_, __) => const ScanHistoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const UserProfileScreen(),
          ),
        ],
      );

  // ─── Scan Sub-Routes ──────────────────────────────────────────────────────

  static List<GoRoute> _scanRoutes() => [
        GoRoute(
          path: '/scan/ocr',
          builder: (_, __) => const OCRScanScreen(),
        ),
        GoRoute(
          path: '/scan/manual',
          builder: (_, __) => const ManualInputScreen(),
        ),
        GoRoute(
          path: '/scan/loading',
          builder: (_, state) =>
              ScanLoadingScreen(barcode: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: '/scan/tips',
          builder: (_, __) => const ScanTipsScreen(),
        ),
        GoRoute(
          path: '/scan/unreadable',
          builder: (_, __) => const BarcodeNotReadableScreen(),
        ),
        GoRoute(
          path: '/scan/ocr/result',
          builder: (_, state) =>
              OCRResultScreen(ocrText: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: '/scan/ocr/edit',
          builder: (_, state) =>
              OCREditScreen(initialText: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: '/scan/success',
          builder: (_, __) => const ScanSuccessScreen(),
        ),
      ];

  // ─── Product / Analysis Routes ────────────────────────────────────────────

  static List<GoRoute> _productRoutes() => [
        GoRoute(
          path: '/product/found',
          builder: (_, state) =>
              ProductFoundScreen(product: state.extra as ProductModel),
        ),
        GoRoute(
          path: '/product/not-found',
          builder: (_, state) =>
              ProductNotFoundScreen(barcode: state.extra as String?),
        ),
        // Supports both extra: ProductModel and deep link ?barcode=xxx
        GoRoute(
          path: '/product/detail',
          builder: (_, state) {
            final extra = state.extra;
            if (extra is ProductModel) {
              return ProductDetailScreen(product: extra);
            }
            if (extra is Map<String, dynamic>) {
              return ProductDetailScreen(
                product: extra['product'] as ProductModel,
                analysis: extra['analysis'] as AIAnalysisModel?,
              );
            }
            final barcode = state.uri.queryParameters['barcode'] ?? '';
            return ProductDetailScreen(
                product: ProductModel.empty(barcode: barcode));
          },
        ),
        GoRoute(
          path: '/product/nutrition',
          builder: (_, state) =>
              NutritionDetailScreen(product: state.extra as ProductModel),
        ),
        GoRoute(
          path: '/product/ingredients',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return IngredientBreakdownScreen(
              product: e['product'] as ProductModel,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/score',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return ScoreBreakdownScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
              fromCache: e['fromCache'] as bool? ?? false,
            );
          },
        ),
        GoRoute(
          path: '/product/score/explain',
          builder: (_, __) => const EcoScoreExplainScreen(),
        ),
        GoRoute(
          path: '/product/ai',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return AIExplanationScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/health',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return HealthAnalysisScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/environment',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return EnvironmentAnalysisScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/ethics',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return EthicsAnalysisScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/greenwashing',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return GreenwashingDetectorScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/greenwashing/detail',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return GreenwashingDetailScreen(
              claim: e['claim'] as GreenwashingClaim,
              level: e['level'] as GreenwashingLevel,
            );
          },
        ),
        GoRoute(
          path: '/product/audience',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return SuitableAudienceScreen(
              product: e['product'] as ProductModel?,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/alternatives',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return AlternativeProductsScreen(
              product: e['product'] as ProductModel,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/product/alternatives/detail',
          builder: (_, state) =>
              AlternativeDetailScreen(product: state.extra as ProductModel),
        ),
        GoRoute(
          path: '/product/compare',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return ProductCompareScreen(
              productA: e['productA'] as ProductModel,
              analysisA: e['analysisA'] as AIAnalysisModel,
              productB: e['productB'] as ProductModel,
              analysisB: e['analysisB'] as AIAnalysisModel?,
            );
          },
        ),
        GoRoute(
          path: '/product/image',
          builder: (_, state) =>
              ProductImageScreen(imageUrl: state.extra as String),
        ),
        GoRoute(
          path: '/product/allergen',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return AllergenWarningScreen(
              product: e['product'] as ProductModel,
              analysis: e['analysis'] as AIAnalysisModel,
              detectedAllergens:
                  List<String>.from(e['detectedAllergens'] as List),
            );
          },
        ),
        GoRoute(
          path: '/product/lifestyle',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return LifestyleConflictScreen(
              product: e['product'] as ProductModel,
              analysis: e['analysis'] as AIAnalysisModel,
              userProfile: e['userProfile'] as UserProfile,
            );
          },
        ),
        GoRoute(
          path: '/product/contribute',
          builder: (_, state) =>
              ContributeProductScreen(barcode: state.extra as String?),
        ),
        GoRoute(
          path: '/ingredient/detail',
          builder: (_, state) => IngredientDetailScreen(
              ingredient: state.extra as IngredientAnalysis),
        ),
      ];

  // ─── AI + Error Routes ────────────────────────────────────────────────────

  static List<GoRoute> _aiAndErrorRoutes() => [
        GoRoute(
          path: '/ai/loading',
          builder: (_, __) => const AILoadingScreen(),
        ),
        GoRoute(
          path: '/ai/error',
          builder: (_, state) =>
              AIErrorScreen(message: state.extra as String?),
        ),
        GoRoute(
          path: '/error/network',
          builder: (_, __) => const NetworkErrorScreen(),
        ),
        GoRoute(
          path: '/error/camera',
          builder: (_, __) => const CameraPermissionScreen(),
        ),
      ];

  // ─── History Routes ───────────────────────────────────────────────────────

  static List<GoRoute> _historyRoutes() => [
        GoRoute(
          path: '/history/detail',
          builder: (_, state) =>
              HistoryDetailScreen(record: state.extra as ScanRecord),
        ),
        GoRoute(
          path: '/history/search',
          builder: (_, __) => const HistorySearchScreen(),
        ),
        GoRoute(
          path: '/history/filter',
          builder: (_, __) => const HistoryFilterScreen(),
        ),
        GoRoute(
          path: '/history/empty',
          builder: (_, __) => const HistoryEmptyScreen(),
        ),
      ];

  // ─── Profile / Personalization Routes ────────────────────────────────────

  static List<GoRoute> _profileRoutes() => [
        GoRoute(
          path: '/profile/setup',
          builder: (_, __) => const ProfileSetupScreen(),
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (_, __) => const ProfileEditScreen(),
        ),
        GoRoute(
          path: '/profile/allergies',
          builder: (_, __) => const EditAllergiesScreen(),
        ),
        GoRoute(
          path: '/profile/allergies/detail',
          builder: (_, state) =>
              AllergyDetailScreen(allergen: state.extra as String),
        ),
        GoRoute(
          path: '/profile/allergies/custom',
          builder: (_, __) => const CustomAllergyScreen(),
        ),
        GoRoute(
          path: '/profile/lifestyle',
          builder: (_, __) => const EditLifestyleScreen(),
        ),
        GoRoute(
          path: '/profile/lifestyle/detail',
          builder: (_, state) =>
              LifestyleDetailScreen(option: state.extra as LifestyleOption),
        ),
        GoRoute(
          path: '/profile/warning',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return PersonalizedWarningScreen(
              product: e['product'] as ProductModel,
              analysis: e['analysis'] as AIAnalysisModel,
              userProfile: e['userProfile'] as UserProfile,
              allergenConflicts:
                  List<String>.from(e['allergenConflicts'] as List),
              lifestyleConflicts:
                  List<LifestyleOption>.from(e['lifestyleConflicts'] as List),
            );
          },
        ),
        GoRoute(
          path: '/profile/ai',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>;
            return AIPersonalizedScreen(
              product: e['product'] as ProductModel,
              analysis: e['analysis'] as AIAnalysisModel,
            );
          },
        ),
        GoRoute(
          path: '/profile/complete',
          builder: (_, __) => const ProfileCompleteScreen(),
        ),
        GoRoute(
          path: '/profile/summary',
          builder: (_, __) => const ProfileSummaryScreen(),
        ),
        GoRoute(
          path: '/profile/dietary',
          builder: (_, __) => const DietaryPreferenceScreen(),
        ),
        GoRoute(
          path: '/profile/eco',
          builder: (_, __) => const EcoPreferenceScreen(),
        ),
        GoRoute(
          path: '/profile/insight',
          builder: (_, __) => const PersonalInsightScreen(),
        ),
        GoRoute(
          path: '/profile/recommendations',
          builder: (_, __) => const RecommendationScreen(),
        ),
        GoRoute(
          path: '/profile/notifications',
          builder: (_, __) => const NotificationPreferenceScreen(),
        ),
        GoRoute(
          path: '/profile/health-goal',
          builder: (_, __) => const HealthGoalScreen(),
        ),
        GoRoute(
          path: '/profile/eco-goal',
          builder: (_, __) => const EcoGoalScreen(),
        ),
        GoRoute(
          path: '/profile/achievements',
          builder: (_, __) => const ProfileAchievementScreen(),
        ),
      ];

  // ─── Impact / Dashboard Routes ────────────────────────────────────────────

  static List<GoRoute> _impactRoutes() => [
        GoRoute(
          path: '/impact',
          builder: (_, __) => const PersonalImpactScreen(),
        ),
        GoRoute(
          path: '/impact/weekly',
          builder: (_, __) => const WeeklyReportScreen(),
        ),
        GoRoute(
          path: '/impact/monthly',
          builder: (_, __) => const MonthlyReportScreen(),
        ),
        GoRoute(
          path: '/impact/chart',
          builder: (_, __) => const ImpactChartScreen(),
        ),
        GoRoute(
          path: '/impact/category',
          builder: (_, __) => const CategoryBreakdownScreen(),
        ),
        GoRoute(
          path: '/impact/trend',
          builder: (_, __) => const EcoTrendScreen(),
        ),
        GoRoute(
          path: '/impact/scores',
          builder: (_, __) => const ScoreHistoryScreen(),
        ),
        GoRoute(
          path: '/impact/top',
          builder: (_, __) => const TopProductsScreen(),
        ),
        GoRoute(
          path: '/impact/worst',
          builder: (_, __) => const WorstProductsScreen(),
        ),
        GoRoute(
          path: '/impact/empty',
          builder: (_, __) => const ImpactEmptyScreen(),
        ),
        GoRoute(
          path: '/impact/share',
          builder: (_, state) {
            final e = state.extra as Map<String, dynamic>?;
            return ShareImpactScreen(
              total: e?['total'] as int? ?? 0,
              green: e?['green'] as int? ?? 0,
              yellow: e?['yellow'] as int? ?? 0,
              red: e?['red'] as int? ?? 0,
              avgScore: e?['avgScore'] as int? ?? 0,
            );
          },
        ),
        GoRoute(
          path: '/impact/export',
          builder: (_, __) => const ExportDataScreen(),
        ),
      ];

  // ─── Achievement Routes ───────────────────────────────────────────────────

  static List<GoRoute> _achievementRoutes() => [
        GoRoute(
          path: '/achievements',
          builder: (_, __) => const AchievementListScreen(),
        ),
        GoRoute(
          path: '/achievements/detail',
          builder: (_, state) => AchievementDetailScreen(
              achievement: state.extra as Achievement),
        ),
        GoRoute(
          path: '/achievements/milestone',
          builder: (_, __) => const MilestoneScreen(),
        ),
      ];

  // ─── Settings Routes ──────────────────────────────────────────────────────

  static List<GoRoute> _settingsRoutes() => [
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/settings/language',
          builder: (_, __) => const LanguageScreen(),
        ),
        GoRoute(
          path: '/settings/notification',
          builder: (_, __) => const NotificationScreen(),
        ),
        GoRoute(
          path: '/settings/privacy',
          builder: (_, __) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: '/settings/about',
          builder: (_, __) => const AboutScreen(),
        ),
        GoRoute(
          path: '/settings/delete-data',
          builder: (_, __) => const DeleteDataScreen(),
        ),
        GoRoute(
          path: '/settings/delete-confirm',
          builder: (_, __) => const DeleteConfirmScreen(),
        ),
        GoRoute(
          path: '/settings/api-key',
          builder: (_, __) => const APIKeyScreen(),
        ),
        GoRoute(
          path: '/settings/theme',
          builder: (_, __) => const ThemeScreen(),
        ),
        GoRoute(
          path: '/settings/font',
          builder: (_, __) => const FontSizeScreen(),
        ),
        GoRoute(
          path: '/settings/data',
          builder: (_, __) => const DataUsageScreen(),
        ),
        GoRoute(
          path: '/settings/opensource',
          builder: (_, __) => const OpenSourceScreen(),
        ),
        GoRoute(
          path: '/settings/feedback',
          builder: (_, __) => const FeedbackScreen(),
        ),
        GoRoute(
          path: '/settings/help',
          builder: (_, __) => const HelpScreen(),
        ),
        GoRoute(
          path: '/settings/tutorial',
          builder: (_, __) => const TutorialScreen(),
        ),
        GoRoute(
          path: '/settings/permissions',
          builder: (_, __) => const PermissionsScreen(),
        ),
        GoRoute(
          path: '/settings/cache',
          builder: (_, __) => const CacheScreen(),
        ),
        GoRoute(
          path: '/settings/update',
          builder: (_, __) => const UpdateScreen(),
        ),
        GoRoute(
          path: '/settings/terms',
          builder: (_, __) => const TermsScreen(),
        ),
        GoRoute(
          path: '/settings/credits',
          builder: (_, __) => const CreditsScreen(),
        ),
      ];
}
