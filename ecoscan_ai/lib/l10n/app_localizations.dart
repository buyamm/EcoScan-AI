import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'EcoScan AI'**
  String get appName;

  /// No description provided for @scan.
  ///
  /// In vi, this message translates to:
  /// **'Quét'**
  String get scan;

  /// No description provided for @history.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In vi, this message translates to:
  /// **'Lọc'**
  String get filter;

  /// No description provided for @share.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get share;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get next;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get start;

  /// No description provided for @analyze.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích'**
  String get analyze;

  /// No description provided for @scanBarcode.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã vạch'**
  String get scanBarcode;

  /// No description provided for @scanOCR.
  ///
  /// In vi, this message translates to:
  /// **'Quét nhãn OCR'**
  String get scanOCR;

  /// No description provided for @manualInput.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã thủ công'**
  String get manualInput;

  /// No description provided for @scanTips.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo quét'**
  String get scanTips;

  /// No description provided for @productFound.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thấy sản phẩm'**
  String get productFound;

  /// No description provided for @productNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy sản phẩm'**
  String get productNotFound;

  /// No description provided for @productDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sản phẩm'**
  String get productDetail;

  /// No description provided for @ingredients.
  ///
  /// In vi, this message translates to:
  /// **'Thành phần'**
  String get ingredients;

  /// No description provided for @nutrition.
  ///
  /// In vi, this message translates to:
  /// **'Dinh dưỡng'**
  String get nutrition;

  /// No description provided for @ecoScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm Eco'**
  String get ecoScore;

  /// No description provided for @good.
  ///
  /// In vi, this message translates to:
  /// **'Tốt'**
  String get good;

  /// No description provided for @average.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get average;

  /// No description provided for @poor.
  ///
  /// In vi, this message translates to:
  /// **'Kém'**
  String get poor;

  /// No description provided for @healthAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích sức khỏe'**
  String get healthAnalysis;

  /// No description provided for @environmentAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích môi trường'**
  String get environmentAnalysis;

  /// No description provided for @ethicsAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích đạo đức'**
  String get ethicsAnalysis;

  /// No description provided for @greenwashing.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện Greenwashing'**
  String get greenwashing;

  /// No description provided for @alternatives.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm thay thế'**
  String get alternatives;

  /// No description provided for @allergenWarning.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo dị ứng'**
  String get allergenWarning;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối mạng'**
  String get networkError;

  /// No description provided for @aiAnalyzing.
  ///
  /// In vi, this message translates to:
  /// **'AI đang phân tích...'**
  String get aiAnalyzing;

  /// No description provided for @aiError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi phân tích AI'**
  String get aiError;

  /// No description provided for @cameraPermission.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền camera'**
  String get cameraPermission;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get theme;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách quyền riêng tư'**
  String get privacyPolicy;

  /// No description provided for @about.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get about;

  /// No description provided for @deleteData.
  ///
  /// In vi, this message translates to:
  /// **'Xóa dữ liệu'**
  String get deleteData;

  /// No description provided for @allergies.
  ///
  /// In vi, this message translates to:
  /// **'Dị ứng'**
  String get allergies;

  /// No description provided for @lifestyle.
  ///
  /// In vi, this message translates to:
  /// **'Lối sống'**
  String get lifestyle;

  /// No description provided for @scanHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử quét'**
  String get scanHistory;

  /// No description provided for @personalImpact.
  ///
  /// In vi, this message translates to:
  /// **'Tác động cá nhân'**
  String get personalImpact;

  /// No description provided for @weeklyReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo tuần'**
  String get weeklyReport;

  /// No description provided for @monthlyReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo tháng'**
  String get monthlyReport;

  /// No description provided for @achievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get achievements;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get english;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
