// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'EcoScan AI';

  @override
  String get scan => 'Scan';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get share => 'Share';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Get Started';

  @override
  String get analyze => 'Analyze';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get export => 'Export';

  @override
  String get contribute => 'Contribute';

  @override
  String get compare => 'Compare';

  @override
  String get viewDetail => 'View Detail';

  @override
  String get seeAll => 'See All';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get scanOCR => 'Scan Label (OCR)';

  @override
  String get manualInput => 'Enter Code Manually';

  @override
  String get scanTips => 'Scan Tips';

  @override
  String get scanActive => 'Point the barcode at the viewfinder';

  @override
  String get scanHintBarcode => 'Supports EAN-8, EAN-13, UPC-A, UPC-E';

  @override
  String get scanHintOCR => 'Point the camera at the ingredient list';

  @override
  String get scanNoBarcode =>
      'No barcode found after 30 seconds. Try adjusting the angle or use OCR.';

  @override
  String get scanManualHint => 'Enter 8–14 digit barcode';

  @override
  String get scanManualLabel => 'Barcode';

  @override
  String get scanManualError => 'Invalid barcode (8–14 digits required)';

  @override
  String get scanLoading => 'Looking up product...';

  @override
  String get scanSuccess => 'Scan successful!';

  @override
  String get barcodeNotReadable => 'Barcode Not Readable';

  @override
  String get barcodeNotReadableHint =>
      'Try cleaning the lens, improving lighting, or entering the code manually.';

  @override
  String get ocrResult => 'OCR Result';

  @override
  String get ocrEdit => 'Edit OCR Text';

  @override
  String get ocrNotDetected =>
      'Could not detect clear text. Improve lighting and distance.';

  @override
  String get cameraPermission => 'Camera Permission Required';

  @override
  String get cameraPermissionHint =>
      'Please grant camera permission in System Settings to use the scanning feature.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get productFound => 'Product Found';

  @override
  String get productNotFound => 'Product Not Found';

  @override
  String get productNotFoundHint =>
      'This product is not in the database yet. You can try OCR scanning or contribute the data.';

  @override
  String get productDetail => 'Product Detail';

  @override
  String get productBrand => 'Brand';

  @override
  String get productOrigin => 'Origin';

  @override
  String get productImage => 'Product Image';

  @override
  String get contributeProduct => 'Contribute Product';

  @override
  String get contributeHint =>
      'Contribute product information to Open Food Facts to help the community.';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get ingredientDetail => 'Ingredient Detail';

  @override
  String get ingredientSafe => 'Safe';

  @override
  String get ingredientCaution => 'Caution';

  @override
  String get ingredientAvoid => 'Avoid';

  @override
  String get filterSafety => 'Filter by Safety';

  @override
  String get allIngredients => 'All Ingredients';

  @override
  String get nutrition => 'Nutrition';

  @override
  String get nutritionDetail => 'Full Nutrition Facts';

  @override
  String get per100g => 'Per 100g';

  @override
  String get calories => 'Calories';

  @override
  String get fat => 'Fat';

  @override
  String get saturatedFat => 'Saturated Fat';

  @override
  String get carbohydrates => 'Carbohydrates';

  @override
  String get sugars => 'Sugars';

  @override
  String get fiber => 'Fiber';

  @override
  String get proteins => 'Protein';

  @override
  String get salt => 'Salt';

  @override
  String get sodium => 'Sodium';

  @override
  String get ecoScore => 'Eco Score';

  @override
  String get ecoScoreExplain => 'Eco Score Explanation';

  @override
  String get ecoScoreExplainHint =>
      'Eco Score is calculated from 3 criteria: Health (40%), Environment (40%), Ethics (20%).';

  @override
  String get good => 'Good';

  @override
  String get average => 'Average';

  @override
  String get poor => 'Poor';

  @override
  String get scoreBreakdown => 'Score Breakdown';

  @override
  String get overallScore => 'Overall Score';

  @override
  String get healthAnalysis => 'Health Analysis';

  @override
  String get healthScore => 'Health Score';

  @override
  String get healthConcerns => 'Health Concerns';

  @override
  String get healthPositives => 'Positives';

  @override
  String get environmentAnalysis => 'Environment Analysis';

  @override
  String get environmentScore => 'Environment Score';

  @override
  String get environmentConcerns => 'Environmental Concerns';

  @override
  String get environmentPositives => 'Positives';

  @override
  String get ethicsAnalysis => 'Ethics Analysis';

  @override
  String get ethicsScore => 'Ethics Score';

  @override
  String get crueltyFree => 'Cruelty-free';

  @override
  String get vegan => 'Vegan';

  @override
  String get ethicsConcerns => 'Ethics Concerns';

  @override
  String get aiExplanation => 'AI Explanation';

  @override
  String get aiAnalyzing => 'AI is analyzing...';

  @override
  String get aiError => 'AI Analysis Error';

  @override
  String get aiErrorHint => 'Could not analyze product. Please try again.';

  @override
  String get aiLoading => 'Analyzing...';

  @override
  String get aiPersonalized => 'Personalized Analysis';

  @override
  String get aiRateLimit => 'Please try again in 1 minute (API rate limit).';

  @override
  String get greenwashing => 'Greenwashing Detector';

  @override
  String get greenwashingDetail => 'Greenwashing Detail';

  @override
  String get greenwashingNone => 'None Detected';

  @override
  String get greenwashingSuspected => 'Suspected';

  @override
  String get greenwashingConfirmed => 'Greenwashing Confirmed';

  @override
  String get greenwashingClaim => 'Claim';

  @override
  String get greenwashingReality => 'Reality';

  @override
  String get greenwashingNoClaims => 'No special claims found';

  @override
  String get suitableAudience => 'Suitable Audience';

  @override
  String get suitableFor => 'Suitable For';

  @override
  String get notSuitableFor => 'Not Suitable For';

  @override
  String get alternatives => 'Alternative Products';

  @override
  String get alternativesHint =>
      'Products in the same category with a higher Eco Score';

  @override
  String get noAlternatives => 'No suitable alternatives found';

  @override
  String get alternativeDetail => 'Alternative Product Detail';

  @override
  String get compareProducts => 'Compare Products';

  @override
  String get allergenWarning => 'Allergen Warning';

  @override
  String get allergenWarningHint =>
      'This product contains ingredients you declared as allergens!';

  @override
  String get allergenDetected => 'Allergen Detected';

  @override
  String get lifestyleConflict => 'Lifestyle Conflict';

  @override
  String get lifestyleConflictHint =>
      'This product is not suitable for your declared lifestyle.';

  @override
  String get networkError => 'Network Error';

  @override
  String get networkErrorHint =>
      'Check your internet connection and try again.';

  @override
  String get userProfile => 'User Profile';

  @override
  String get profileSetup => 'Profile Setup';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileComplete => 'Profile Setup Complete';

  @override
  String get profileSummary => 'Profile Summary';

  @override
  String get displayName => 'Display Name';

  @override
  String get displayNameHint => 'Enter your name';

  @override
  String get allergies => 'Allergies';

  @override
  String get editAllergies => 'Edit Allergies';

  @override
  String get allergyDetail => 'Allergy Detail';

  @override
  String get customAllergy => 'Custom Allergy';

  @override
  String get customAllergyHint => 'Enter a custom allergy';

  @override
  String get noAllergies => 'No allergies declared';

  @override
  String get allergyGluten => 'Gluten';

  @override
  String get allergyLactose => 'Lactose';

  @override
  String get allergyNuts => 'Tree Nuts';

  @override
  String get allergyParaben => 'Paraben';

  @override
  String get allergySulfate => 'Sulfate';

  @override
  String get allergySoy => 'Soy';

  @override
  String get allergyEggs => 'Eggs';

  @override
  String get allergyShellfish => 'Shellfish';

  @override
  String get allergyPollen => 'Pollen';

  @override
  String get lifestyle => 'Lifestyle';

  @override
  String get editLifestyle => 'Edit Lifestyle';

  @override
  String get lifestyleDetail => 'Lifestyle Detail';

  @override
  String get lifestyleVegetarian => 'Vegetarian';

  @override
  String get lifestyleVegan => 'Vegan';

  @override
  String get lifestyleEcoConscious => 'Eco-conscious';

  @override
  String get lifestyleCrueltyFree => 'Cruelty-free only';

  @override
  String get noLifestyle => 'No lifestyle selected';

  @override
  String get personalizedWarning => 'Personalized Warning';

  @override
  String get dietaryPreference => 'Dietary Preference';

  @override
  String get ecoPreference => 'Eco Preference';

  @override
  String get healthGoal => 'Health Goal';

  @override
  String get ecoGoal => 'Eco Goal';

  @override
  String get personalInsight => 'Personal Insight';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get notificationPreference => 'Notification Preference';

  @override
  String get profileAchievements => 'Profile Achievements';

  @override
  String get scanHistory => 'Scan History';

  @override
  String get historyDetail => 'History Detail';

  @override
  String get historySearch => 'Search History';

  @override
  String get historyFilter => 'Filter History';

  @override
  String get historyEmpty => 'No Scan History';

  @override
  String get historyEmptyHint => 'Scan your first product to start tracking.';

  @override
  String get scannedAt => 'Scanned At';

  @override
  String get scanMethod => 'Scan Method';

  @override
  String get filterByScore => 'Filter by Eco Score';

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get filterByCategory => 'Filter by Category';

  @override
  String get sortNewest => 'Newest First';

  @override
  String get sortOldest => 'Oldest First';

  @override
  String get personalImpact => 'Personal Impact';

  @override
  String get totalScans => 'Total Scans';

  @override
  String get greenProducts => 'Green Products';

  @override
  String get yellowProducts => 'Average Products';

  @override
  String get redProducts => 'Poor Products';

  @override
  String get greenStreak => 'Green Streak';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get monthlyReport => 'Monthly Report';

  @override
  String get impactChart => 'Impact Chart';

  @override
  String get categoryBreakdown => 'Category Breakdown';

  @override
  String get ecoTrend => 'Eco Consumption Trend';

  @override
  String get scoreHistory => 'Score History';

  @override
  String get topProducts => 'Top Products';

  @override
  String get worstProducts => 'Worst Products';

  @override
  String get impactEmpty => 'Not Enough Data';

  @override
  String get impactEmptyHint => 'Scan more products to see impact statistics.';

  @override
  String get shareImpact => 'Share Impact';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get exportJSON => 'Export JSON';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementDetail => 'Achievement Detail';

  @override
  String get milestone => 'Milestone';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get firstScan => 'First Scan';

  @override
  String get tenScans => '10 Scans';

  @override
  String get firstGreenProduct => 'First Green Product';

  @override
  String get language => 'Language';

  @override
  String get languageHint =>
      'Language will change immediately without restarting.';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get themeSystemHint =>
      '\"System\" will automatically switch based on your device settings.';

  @override
  String get fontSize => 'Font Size';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeDefault => 'Default';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeReset => 'Reset to Default';

  @override
  String get fontSizePreview => 'Preview';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationEnable => 'Enable Notifications';

  @override
  String get notificationReminder => 'New product scan reminder';

  @override
  String get notificationTime => 'Reminder Time';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyDataLocal => 'Locally Stored Data';

  @override
  String get privacyDataSent => 'Data Sent to API';

  @override
  String get privacyLocalDesc =>
      'Scan history, user profile, and settings are stored entirely on your device.';

  @override
  String get privacyApiDesc =>
      'Product ingredient lists are sent to the Groq API for AI analysis. No personal information is ever sent.';

  @override
  String get about => 'About';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutTeam => 'Development Team';

  @override
  String get aboutGithub => 'GitHub';

  @override
  String get aboutMission => 'Towards SDG 12 — Responsible Consumption';

  @override
  String get deleteData => 'Delete Data';

  @override
  String get deleteDataHint =>
      'This will permanently delete all scan history and user profile from the device.';

  @override
  String get deleteConfirm => 'Confirm Data Deletion';

  @override
  String get deleteConfirmHint =>
      'Are you sure you want to delete all data? This cannot be undone.';

  @override
  String get deleteSuccess => 'All data deleted';

  @override
  String get dataUsage => 'Data Usage';

  @override
  String get cacheSize => 'Cache Size';

  @override
  String get historySize => 'History Size';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheSuccess => 'Cache cleared';

  @override
  String get cacheManagement => 'Cache Management';

  @override
  String get openSource => 'Open Source';

  @override
  String get openSourceHint =>
      'This app uses the following open-source libraries:';

  @override
  String get feedback => 'Send Feedback';

  @override
  String get feedbackHint => 'Your feedback helps us improve the app.';

  @override
  String get feedbackSend => 'Send feedback via email';

  @override
  String get help => 'Help & FAQ';

  @override
  String get helpFaq => 'Frequently Asked Questions';

  @override
  String get helpQ1 => 'How do I scan a product?';

  @override
  String get helpA1 =>
      'Open the Scan screen and point the camera at the product barcode.';

  @override
  String get helpQ2 => 'Why can\'t I find a product?';

  @override
  String get helpA2 =>
      'The product may not be in the Open Food Facts database. Try OCR scanning the ingredient label.';

  @override
  String get helpQ3 => 'Is my personal data shared?';

  @override
  String get helpA3 =>
      'No. All personal data is stored locally on your device.';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get tutorialStep1 => 'Scan a Barcode';

  @override
  String get tutorialStep2 => 'View AI Analysis';

  @override
  String get tutorialStep3 => 'Set Up Your Profile';

  @override
  String get permissions => 'App Permissions';

  @override
  String get permissionCamera => 'Camera';

  @override
  String get permissionCameraDesc =>
      'Required to scan barcodes and product labels';

  @override
  String get permissionStorage => 'Storage';

  @override
  String get permissionStorageDesc =>
      'Store scan history and product cache locally';

  @override
  String get permissionInternet => 'Internet';

  @override
  String get permissionInternetDesc =>
      'Call Open Food Facts API and Groq AI API';

  @override
  String get update => 'Check for Updates';

  @override
  String get updateLatest => 'You are on the latest version';

  @override
  String get updateAvailable => 'New version available';

  @override
  String get updateNow => 'Update Now';

  @override
  String get terms => 'Terms of Use';

  @override
  String get termsAccept => 'I agree to the terms';

  @override
  String get credits => 'Credits';

  @override
  String get creditsHint =>
      'Thank you to the open-source projects that power EcoScan AI.';

  @override
  String get apiKey => 'API Key';

  @override
  String get apiKeyHint => 'For developers only';

  @override
  String get apiKeyLabel => 'Groq API Key';

  @override
  String get apiKeySave => 'Save API Key';

  @override
  String get onboardingTitle1 => 'Scan & Discover';

  @override
  String get onboardingDesc1 =>
      'Scan barcodes or product labels to understand what you\'re consuming.';

  @override
  String get onboardingTitle2 => 'Smart AI Analysis';

  @override
  String get onboardingDesc2 =>
      'AI analyzes every ingredient — evaluating health, environment, and ethics.';

  @override
  String get onboardingTitle3 => 'Personalized for You';

  @override
  String get onboardingDesc3 =>
      'Set up your allergy and lifestyle profile to receive tailored warnings.';

  @override
  String get home => 'Home';

  @override
  String get homeWelcome => 'Welcome to EcoScan AI';

  @override
  String get homeSubtitle => 'Smart consumption, responsible living';

  @override
  String get homeScanNow => 'Scan Now';

  @override
  String get homeRecentScans => 'Recent Scans';

  @override
  String get homeQuickStats => 'Quick Stats';

  @override
  String get noData => 'No Data';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get goHome => 'Go Home';
}
