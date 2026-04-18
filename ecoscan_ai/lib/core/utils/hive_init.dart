import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/nutrition_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/scan_record.dart';
import '../../data/models/user_profile.dart';
import '../constants/app_constants.dart';

/// Initialises Hive, registers all adapters, and opens all required boxes.
Future<void> initHive() async {
  await Hive.initFlutter();

  // Register adapters (order must match typeId assignments)
  Hive.registerAdapter(NutritionModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(EcoScoreLevelAdapter());
  Hive.registerAdapter(GreenwashingLevelAdapter());
  Hive.registerAdapter(IngredientSafetyAdapter());
  Hive.registerAdapter(HealthAnalysisAdapter());
  Hive.registerAdapter(EnvironmentAnalysisAdapter());
  Hive.registerAdapter(EthicsAnalysisAdapter());
  Hive.registerAdapter(GreenwashingClaimAdapter());
  Hive.registerAdapter(GreenwashingResultAdapter());
  Hive.registerAdapter(IngredientAnalysisAdapter());
  Hive.registerAdapter(AIAnalysisModelAdapter());
  Hive.registerAdapter(ScanRecordAdapter());
  Hive.registerAdapter(LifestyleOptionAdapter());
  Hive.registerAdapter(DietaryPreferenceAdapter());
  Hive.registerAdapter(UserProfileAdapter());

  // Open boxes
  await Hive.openBox<ScanRecord>(AppConstants.scanHistoryBox);
  await Hive.openBox<String>(AppConstants.cachedProductsBox);
}
