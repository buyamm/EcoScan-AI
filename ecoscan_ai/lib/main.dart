import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/hive_init.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/user_profile_repository.dart';
import 'data/repositories/scan_history_repository.dart';
import 'data/repositories/product_cache_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  final prefs = await SharedPreferences.getInstance();
  final settingsRepo = SettingsRepository(prefs);
  final userProfileRepo = UserProfileRepository(prefs);
  final scanHistoryRepo = ScanHistoryRepository();
  final productCacheRepo = ProductCacheRepository();

  runApp(EcoScanApp(
    settingsRepo: settingsRepo,
    userProfileRepo: userProfileRepo,
    scanHistoryRepo: scanHistoryRepo,
    productCacheRepo: productCacheRepo,
  ));
}

class EcoScanApp extends StatelessWidget {
  final SettingsRepository settingsRepo;
  final UserProfileRepository userProfileRepo;
  final ScanHistoryRepository scanHistoryRepo;
  final ProductCacheRepository productCacheRepo;

  const EcoScanApp({
    super.key,
    required this.settingsRepo,
    required this.userProfileRepo,
    required this.scanHistoryRepo,
    required this.productCacheRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoScan AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Scaffold(
        body: Center(
          child: Text('EcoScan AI'),
        ),
      ),
    );
  }
}
