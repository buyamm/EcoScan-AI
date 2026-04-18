import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/hive_init.dart';
import 'core/router/app_router.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/user_profile_repository.dart';
import 'data/repositories/scan_history_repository.dart';
import 'data/repositories/product_cache_repository.dart';
import 'data/services/groq_service.dart';
import 'data/services/open_food_facts_service.dart';
import 'data/services/ocr_service.dart';
import 'presentation/blocs/ai/ai_bloc.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/history/history_cubit.dart';
import 'presentation/blocs/ocr/ocr_bloc.dart';
import 'presentation/blocs/profile/profile_cubit.dart';
import 'presentation/blocs/scan/scan_bloc.dart';
import 'presentation/blocs/settings/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  final prefs = await SharedPreferences.getInstance();
  final settingsRepo = SettingsRepository(prefs);
  final userProfileRepo = UserProfileRepository(prefs);
  final scanHistoryRepo = ScanHistoryRepository();
  final productCacheRepo = ProductCacheRepository();
  final authRepo = AuthRepository(prefs: prefs, profileRepo: userProfileRepo);

  runApp(EcoScanApp(
    settingsRepo: settingsRepo,
    userProfileRepo: userProfileRepo,
    scanHistoryRepo: scanHistoryRepo,
    productCacheRepo: productCacheRepo,
    authRepo: authRepo,
  ));
}

class EcoScanApp extends StatelessWidget {
  final SettingsRepository settingsRepo;
  final UserProfileRepository userProfileRepo;
  final ScanHistoryRepository scanHistoryRepo;
  final ProductCacheRepository productCacheRepo;
  final AuthRepository authRepo;

  const EcoScanApp({
    super.key,
    required this.settingsRepo,
    required this.userProfileRepo,
    required this.scanHistoryRepo,
    required this.productCacheRepo,
    required this.authRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsCubit(repo: settingsRepo),
        ),
        BlocProvider(
          create: (_) => AuthCubit(authRepo: authRepo),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(repo: userProfileRepo),
        ),
        BlocProvider(
          create: (_) => HistoryCubit(repo: scanHistoryRepo)..loadHistory(),
        ),
        BlocProvider(
          create: (_) => ScanBloc(
            offService: OpenFoodFactsService(),
            cacheRepo: productCacheRepo,
          ),
        ),
        BlocProvider(
          create: (_) => AIBloc(
            groqService: GroqService(),
            profileRepo: userProfileRepo,
            historyRepo: scanHistoryRepo,
          ),
        ),
        BlocProvider(
          create: (_) => OCRBloc(ocrService: OcrService()),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: 'EcoScan AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightWithScale(settingsState.fontSize),
            darkTheme: AppTheme.darkWithScale(settingsState.fontSize),
            themeMode: settingsState.themeMode,
            locale: settingsState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.createRouter(),
          );
        },
      ),
    );
  }
}
