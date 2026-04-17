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

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get remove;

  /// No description provided for @apply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại'**
  String get reset;

  /// No description provided for @export.
  ///
  /// In vi, this message translates to:
  /// **'Xuất'**
  String get export;

  /// No description provided for @contribute.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp'**
  String get contribute;

  /// No description provided for @compare.
  ///
  /// In vi, this message translates to:
  /// **'So sánh'**
  String get compare;

  /// No description provided for @viewDetail.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get viewDetail;

  /// No description provided for @seeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get seeAll;

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

  /// No description provided for @scanActive.
  ///
  /// In vi, this message translates to:
  /// **'Đưa mã vạch vào khung ngắm'**
  String get scanActive;

  /// No description provided for @scanHintBarcode.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ EAN-8, EAN-13, UPC-A, UPC-E'**
  String get scanHintBarcode;

  /// No description provided for @scanHintOCR.
  ///
  /// In vi, this message translates to:
  /// **'Hướng camera vào danh sách thành phần'**
  String get scanHintOCR;

  /// No description provided for @scanNoBarcode.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy mã vạch sau 30 giây. Thử điều chỉnh góc quét hoặc dùng OCR.'**
  String get scanNoBarcode;

  /// No description provided for @scanManualHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã vạch từ 8–14 ký tự số'**
  String get scanManualHint;

  /// No description provided for @scanManualLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã vạch'**
  String get scanManualLabel;

  /// No description provided for @scanManualError.
  ///
  /// In vi, this message translates to:
  /// **'Mã vạch không hợp lệ (8–14 chữ số)'**
  String get scanManualError;

  /// No description provided for @scanLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tìm sản phẩm...'**
  String get scanLoading;

  /// No description provided for @scanSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Quét thành công!'**
  String get scanSuccess;

  /// No description provided for @barcodeNotReadable.
  ///
  /// In vi, this message translates to:
  /// **'Không đọc được mã vạch'**
  String get barcodeNotReadable;

  /// No description provided for @barcodeNotReadableHint.
  ///
  /// In vi, this message translates to:
  /// **'Thử làm sạch ống kính, cải thiện ánh sáng, hoặc nhập mã thủ công.'**
  String get barcodeNotReadableHint;

  /// No description provided for @ocrResult.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả OCR'**
  String get ocrResult;

  /// No description provided for @ocrEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa văn bản OCR'**
  String get ocrEdit;

  /// No description provided for @ocrNotDetected.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận dạng được văn bản rõ ràng. Cải thiện ánh sáng và khoảng cách.'**
  String get ocrNotDetected;

  /// No description provided for @cameraPermission.
  ///
  /// In vi, this message translates to:
  /// **'Cần quyền camera'**
  String get cameraPermission;

  /// No description provided for @cameraPermissionHint.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cấp quyền camera trong Cài đặt hệ thống để sử dụng tính năng quét.'**
  String get cameraPermissionHint;

  /// No description provided for @openSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở cài đặt'**
  String get openSettings;

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

  /// No description provided for @productNotFoundHint.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm này chưa có trong cơ sở dữ liệu. Bạn có thể thử quét OCR hoặc đóng góp dữ liệu.'**
  String get productNotFoundHint;

  /// No description provided for @productDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sản phẩm'**
  String get productDetail;

  /// No description provided for @productBrand.
  ///
  /// In vi, this message translates to:
  /// **'Thương hiệu'**
  String get productBrand;

  /// No description provided for @productOrigin.
  ///
  /// In vi, this message translates to:
  /// **'Xuất xứ'**
  String get productOrigin;

  /// No description provided for @productImage.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh sản phẩm'**
  String get productImage;

  /// No description provided for @contributeProduct.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp sản phẩm'**
  String get contributeProduct;

  /// No description provided for @contributeHint.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp thông tin sản phẩm lên Open Food Facts để giúp cộng đồng.'**
  String get contributeHint;

  /// No description provided for @ingredients.
  ///
  /// In vi, this message translates to:
  /// **'Thành phần'**
  String get ingredients;

  /// No description provided for @ingredientDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết thành phần'**
  String get ingredientDetail;

  /// No description provided for @ingredientSafe.
  ///
  /// In vi, this message translates to:
  /// **'An toàn'**
  String get ingredientSafe;

  /// No description provided for @ingredientCaution.
  ///
  /// In vi, this message translates to:
  /// **'Cần lưu ý'**
  String get ingredientCaution;

  /// No description provided for @ingredientAvoid.
  ///
  /// In vi, this message translates to:
  /// **'Nên tránh'**
  String get ingredientAvoid;

  /// No description provided for @filterSafety.
  ///
  /// In vi, this message translates to:
  /// **'Lọc theo độ an toàn'**
  String get filterSafety;

  /// No description provided for @allIngredients.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả thành phần'**
  String get allIngredients;

  /// No description provided for @nutrition.
  ///
  /// In vi, this message translates to:
  /// **'Dinh dưỡng'**
  String get nutrition;

  /// No description provided for @nutritionDetail.
  ///
  /// In vi, this message translates to:
  /// **'Bảng dinh dưỡng chi tiết'**
  String get nutritionDetail;

  /// No description provided for @per100g.
  ///
  /// In vi, this message translates to:
  /// **'Trên 100g'**
  String get per100g;

  /// No description provided for @calories.
  ///
  /// In vi, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @fat.
  ///
  /// In vi, this message translates to:
  /// **'Chất béo'**
  String get fat;

  /// No description provided for @saturatedFat.
  ///
  /// In vi, this message translates to:
  /// **'Chất béo bão hòa'**
  String get saturatedFat;

  /// No description provided for @carbohydrates.
  ///
  /// In vi, this message translates to:
  /// **'Carbohydrate'**
  String get carbohydrates;

  /// No description provided for @sugars.
  ///
  /// In vi, this message translates to:
  /// **'Đường'**
  String get sugars;

  /// No description provided for @fiber.
  ///
  /// In vi, this message translates to:
  /// **'Chất xơ'**
  String get fiber;

  /// No description provided for @proteins.
  ///
  /// In vi, this message translates to:
  /// **'Protein'**
  String get proteins;

  /// No description provided for @salt.
  ///
  /// In vi, this message translates to:
  /// **'Muối'**
  String get salt;

  /// No description provided for @sodium.
  ///
  /// In vi, this message translates to:
  /// **'Natri'**
  String get sodium;

  /// No description provided for @ecoScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm Eco'**
  String get ecoScore;

  /// No description provided for @ecoScoreExplain.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích Eco Score'**
  String get ecoScoreExplain;

  /// No description provided for @ecoScoreExplainHint.
  ///
  /// In vi, this message translates to:
  /// **'Eco Score được tính từ 3 tiêu chí: Sức khỏe (40%), Môi trường (40%), Đạo đức (20%).'**
  String get ecoScoreExplainHint;

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

  /// No description provided for @scoreBreakdown.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích điểm số'**
  String get scoreBreakdown;

  /// No description provided for @overallScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm tổng hợp'**
  String get overallScore;

  /// No description provided for @healthAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích sức khỏe'**
  String get healthAnalysis;

  /// No description provided for @healthScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm sức khỏe'**
  String get healthScore;

  /// No description provided for @healthConcerns.
  ///
  /// In vi, this message translates to:
  /// **'Vấn đề sức khỏe'**
  String get healthConcerns;

  /// No description provided for @healthPositives.
  ///
  /// In vi, this message translates to:
  /// **'Điểm tích cực'**
  String get healthPositives;

  /// No description provided for @environmentAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích môi trường'**
  String get environmentAnalysis;

  /// No description provided for @environmentScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm môi trường'**
  String get environmentScore;

  /// No description provided for @environmentConcerns.
  ///
  /// In vi, this message translates to:
  /// **'Vấn đề môi trường'**
  String get environmentConcerns;

  /// No description provided for @environmentPositives.
  ///
  /// In vi, this message translates to:
  /// **'Điểm tích cực'**
  String get environmentPositives;

  /// No description provided for @ethicsAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích đạo đức'**
  String get ethicsAnalysis;

  /// No description provided for @ethicsScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm đạo đức'**
  String get ethicsScore;

  /// No description provided for @crueltyFree.
  ///
  /// In vi, this message translates to:
  /// **'Không thử nghiệm động vật'**
  String get crueltyFree;

  /// No description provided for @vegan.
  ///
  /// In vi, this message translates to:
  /// **'Thuần chay'**
  String get vegan;

  /// No description provided for @ethicsConcerns.
  ///
  /// In vi, this message translates to:
  /// **'Vấn đề đạo đức'**
  String get ethicsConcerns;

  /// No description provided for @aiExplanation.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích AI'**
  String get aiExplanation;

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

  /// No description provided for @aiErrorHint.
  ///
  /// In vi, this message translates to:
  /// **'Không thể phân tích sản phẩm. Vui lòng thử lại sau.'**
  String get aiErrorHint;

  /// No description provided for @aiLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang phân tích...'**
  String get aiLoading;

  /// No description provided for @aiPersonalized.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích cá nhân hóa'**
  String get aiPersonalized;

  /// No description provided for @aiRateLimit.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng thử lại sau 1 phút (giới hạn tốc độ API).'**
  String get aiRateLimit;

  /// No description provided for @greenwashing.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện Greenwashing'**
  String get greenwashing;

  /// No description provided for @greenwashingDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết Greenwashing'**
  String get greenwashingDetail;

  /// No description provided for @greenwashingNone.
  ///
  /// In vi, this message translates to:
  /// **'Không phát hiện'**
  String get greenwashingNone;

  /// No description provided for @greenwashingSuspected.
  ///
  /// In vi, this message translates to:
  /// **'Nghi ngờ'**
  String get greenwashingSuspected;

  /// No description provided for @greenwashingConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận Greenwashing'**
  String get greenwashingConfirmed;

  /// No description provided for @greenwashingClaim.
  ///
  /// In vi, this message translates to:
  /// **'Tuyên bố'**
  String get greenwashingClaim;

  /// No description provided for @greenwashingReality.
  ///
  /// In vi, this message translates to:
  /// **'Thực tế'**
  String get greenwashingReality;

  /// No description provided for @greenwashingNoClaims.
  ///
  /// In vi, this message translates to:
  /// **'Không có tuyên bố đặc biệt'**
  String get greenwashingNoClaims;

  /// No description provided for @suitableAudience.
  ///
  /// In vi, this message translates to:
  /// **'Đối tượng phù hợp'**
  String get suitableAudience;

  /// No description provided for @suitableFor.
  ///
  /// In vi, this message translates to:
  /// **'Phù hợp với'**
  String get suitableFor;

  /// No description provided for @notSuitableFor.
  ///
  /// In vi, this message translates to:
  /// **'Không phù hợp với'**
  String get notSuitableFor;

  /// No description provided for @alternatives.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm thay thế'**
  String get alternatives;

  /// No description provided for @alternativesHint.
  ///
  /// In vi, this message translates to:
  /// **'Các sản phẩm cùng danh mục có Eco Score cao hơn'**
  String get alternativesHint;

  /// No description provided for @noAlternatives.
  ///
  /// In vi, this message translates to:
  /// **'Chưa tìm thấy sản phẩm thay thế phù hợp'**
  String get noAlternatives;

  /// No description provided for @alternativeDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sản phẩm thay thế'**
  String get alternativeDetail;

  /// No description provided for @compareProducts.
  ///
  /// In vi, this message translates to:
  /// **'So sánh sản phẩm'**
  String get compareProducts;

  /// No description provided for @allergenWarning.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo dị ứng'**
  String get allergenWarning;

  /// No description provided for @allergenWarningHint.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm này chứa thành phần bạn đã khai báo dị ứng!'**
  String get allergenWarningHint;

  /// No description provided for @allergenDetected.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện chất gây dị ứng'**
  String get allergenDetected;

  /// No description provided for @lifestyleConflict.
  ///
  /// In vi, this message translates to:
  /// **'Xung đột lối sống'**
  String get lifestyleConflict;

  /// No description provided for @lifestyleConflictHint.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm này không phù hợp với lối sống đã khai báo.'**
  String get lifestyleConflictHint;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối mạng'**
  String get networkError;

  /// No description provided for @networkErrorHint.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra kết nối internet và thử lại.'**
  String get networkErrorHint;

  /// No description provided for @userProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ người dùng'**
  String get userProfile;

  /// No description provided for @profileSetup.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập hồ sơ'**
  String get profileSetup;

  /// No description provided for @profileEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get profileEdit;

  /// No description provided for @profileComplete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành thiết lập hồ sơ'**
  String get profileComplete;

  /// No description provided for @profileSummary.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt hồ sơ'**
  String get profileSummary;

  /// No description provided for @displayName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị'**
  String get displayName;

  /// No description provided for @displayNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên của bạn'**
  String get displayNameHint;

  /// No description provided for @allergies.
  ///
  /// In vi, this message translates to:
  /// **'Dị ứng'**
  String get allergies;

  /// No description provided for @editAllergies.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa dị ứng'**
  String get editAllergies;

  /// No description provided for @allergyDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết dị ứng'**
  String get allergyDetail;

  /// No description provided for @customAllergy.
  ///
  /// In vi, this message translates to:
  /// **'Dị ứng tùy chỉnh'**
  String get customAllergy;

  /// No description provided for @customAllergyHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập loại dị ứng tùy chỉnh'**
  String get customAllergyHint;

  /// No description provided for @noAllergies.
  ///
  /// In vi, this message translates to:
  /// **'Chưa khai báo dị ứng'**
  String get noAllergies;

  /// No description provided for @allergyGluten.
  ///
  /// In vi, this message translates to:
  /// **'Gluten'**
  String get allergyGluten;

  /// No description provided for @allergyLactose.
  ///
  /// In vi, this message translates to:
  /// **'Lactose'**
  String get allergyLactose;

  /// No description provided for @allergyNuts.
  ///
  /// In vi, this message translates to:
  /// **'Hạt cây'**
  String get allergyNuts;

  /// No description provided for @allergyParaben.
  ///
  /// In vi, this message translates to:
  /// **'Paraben'**
  String get allergyParaben;

  /// No description provided for @allergySulfate.
  ///
  /// In vi, this message translates to:
  /// **'Sulfate'**
  String get allergySulfate;

  /// No description provided for @allergySoy.
  ///
  /// In vi, this message translates to:
  /// **'Đậu nành'**
  String get allergySoy;

  /// No description provided for @allergyEggs.
  ///
  /// In vi, this message translates to:
  /// **'Trứng'**
  String get allergyEggs;

  /// No description provided for @allergyShellfish.
  ///
  /// In vi, this message translates to:
  /// **'Hải sản có vỏ'**
  String get allergyShellfish;

  /// No description provided for @allergyPollen.
  ///
  /// In vi, this message translates to:
  /// **'Phấn hoa'**
  String get allergyPollen;

  /// No description provided for @lifestyle.
  ///
  /// In vi, this message translates to:
  /// **'Lối sống'**
  String get lifestyle;

  /// No description provided for @editLifestyle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa lối sống'**
  String get editLifestyle;

  /// No description provided for @lifestyleDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết lối sống'**
  String get lifestyleDetail;

  /// No description provided for @lifestyleVegetarian.
  ///
  /// In vi, this message translates to:
  /// **'Ăn chay (Vegetarian)'**
  String get lifestyleVegetarian;

  /// No description provided for @lifestyleVegan.
  ///
  /// In vi, this message translates to:
  /// **'Thuần chay (Vegan)'**
  String get lifestyleVegan;

  /// No description provided for @lifestyleEcoConscious.
  ///
  /// In vi, this message translates to:
  /// **'Ý thức môi trường (Eco-conscious)'**
  String get lifestyleEcoConscious;

  /// No description provided for @lifestyleCrueltyFree.
  ///
  /// In vi, this message translates to:
  /// **'Không thử nghiệm động vật (Cruelty-free)'**
  String get lifestyleCrueltyFree;

  /// No description provided for @noLifestyle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn lối sống'**
  String get noLifestyle;

  /// No description provided for @personalizedWarning.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo cá nhân hóa'**
  String get personalizedWarning;

  /// No description provided for @dietaryPreference.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn chế độ ăn'**
  String get dietaryPreference;

  /// No description provided for @ecoPreference.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn môi trường'**
  String get ecoPreference;

  /// No description provided for @healthGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu sức khỏe'**
  String get healthGoal;

  /// No description provided for @ecoGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu môi trường'**
  String get ecoGoal;

  /// No description provided for @personalInsight.
  ///
  /// In vi, this message translates to:
  /// **'Insight cá nhân'**
  String get personalInsight;

  /// No description provided for @recommendations.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý cải thiện'**
  String get recommendations;

  /// No description provided for @notificationPreference.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn thông báo'**
  String get notificationPreference;

  /// No description provided for @profileAchievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích hồ sơ'**
  String get profileAchievements;

  /// No description provided for @scanHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử quét'**
  String get scanHistory;

  /// No description provided for @historyDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết lịch sử'**
  String get historyDetail;

  /// No description provided for @historySearch.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm lịch sử'**
  String get historySearch;

  /// No description provided for @historyFilter.
  ///
  /// In vi, this message translates to:
  /// **'Lọc lịch sử'**
  String get historyFilter;

  /// No description provided for @historyEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử quét'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Quét sản phẩm đầu tiên để bắt đầu theo dõi.'**
  String get historyEmptyHint;

  /// No description provided for @scannedAt.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian quét'**
  String get scannedAt;

  /// No description provided for @scanMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức quét'**
  String get scanMethod;

  /// No description provided for @filterByScore.
  ///
  /// In vi, this message translates to:
  /// **'Lọc theo Eco Score'**
  String get filterByScore;

  /// No description provided for @filterByDate.
  ///
  /// In vi, this message translates to:
  /// **'Lọc theo thời gian'**
  String get filterByDate;

  /// No description provided for @filterByCategory.
  ///
  /// In vi, this message translates to:
  /// **'Lọc theo danh mục'**
  String get filterByCategory;

  /// No description provided for @sortNewest.
  ///
  /// In vi, this message translates to:
  /// **'Mới nhất trước'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In vi, this message translates to:
  /// **'Cũ nhất trước'**
  String get sortOldest;

  /// No description provided for @personalImpact.
  ///
  /// In vi, this message translates to:
  /// **'Tác động cá nhân'**
  String get personalImpact;

  /// No description provided for @totalScans.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lượt quét'**
  String get totalScans;

  /// No description provided for @greenProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm xanh'**
  String get greenProducts;

  /// No description provided for @yellowProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm trung bình'**
  String get yellowProducts;

  /// No description provided for @redProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm kém'**
  String get redProducts;

  /// No description provided for @greenStreak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi xanh'**
  String get greenStreak;

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

  /// No description provided for @impactChart.
  ///
  /// In vi, this message translates to:
  /// **'Biểu đồ tác động'**
  String get impactChart;

  /// No description provided for @categoryBreakdown.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích theo danh mục'**
  String get categoryBreakdown;

  /// No description provided for @ecoTrend.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng tiêu dùng xanh'**
  String get ecoTrend;

  /// No description provided for @scoreHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử điểm số'**
  String get scoreHistory;

  /// No description provided for @topProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm tốt nhất'**
  String get topProducts;

  /// No description provided for @worstProducts.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm kém nhất'**
  String get worstProducts;

  /// No description provided for @impactEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ dữ liệu'**
  String get impactEmpty;

  /// No description provided for @impactEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Quét thêm sản phẩm để xem thống kê tác động.'**
  String get impactEmptyHint;

  /// No description provided for @shareImpact.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ tác động'**
  String get shareImpact;

  /// No description provided for @exportData.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu'**
  String get exportData;

  /// No description provided for @exportCSV.
  ///
  /// In vi, this message translates to:
  /// **'Xuất CSV'**
  String get exportCSV;

  /// No description provided for @exportJSON.
  ///
  /// In vi, this message translates to:
  /// **'Xuất JSON'**
  String get exportJSON;

  /// No description provided for @achievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get achievements;

  /// No description provided for @achievementDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết thành tích'**
  String get achievementDetail;

  /// No description provided for @milestone.
  ///
  /// In vi, this message translates to:
  /// **'Cột mốc'**
  String get milestone;

  /// No description provided for @achievementUnlocked.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa thành tích!'**
  String get achievementUnlocked;

  /// No description provided for @firstScan.
  ///
  /// In vi, this message translates to:
  /// **'Lần quét đầu tiên'**
  String get firstScan;

  /// No description provided for @tenScans.
  ///
  /// In vi, this message translates to:
  /// **'10 lượt quét'**
  String get tenScans;

  /// No description provided for @firstGreenProduct.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm xanh đầu tiên'**
  String get firstGreenProduct;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @languageHint.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ sẽ được thay đổi ngay lập tức, không cần khởi động lại.'**
  String get languageHint;

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

  /// No description provided for @theme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get themeSystem;

  /// No description provided for @themeSystemHint.
  ///
  /// In vi, this message translates to:
  /// **'\"Theo hệ thống\" sẽ tự động chuyển đổi dựa trên cài đặt của thiết bị.'**
  String get themeSystemHint;

  /// No description provided for @fontSize.
  ///
  /// In vi, this message translates to:
  /// **'Cỡ chữ'**
  String get fontSize;

  /// No description provided for @fontSizeSmall.
  ///
  /// In vi, this message translates to:
  /// **'Nhỏ'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeDefault.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get fontSizeDefault;

  /// No description provided for @fontSizeMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeLarge.
  ///
  /// In vi, this message translates to:
  /// **'Lớn'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeReset.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mặc định'**
  String get fontSizeReset;

  /// No description provided for @fontSizePreview.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước'**
  String get fontSizePreview;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @notificationEnable.
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo'**
  String get notificationEnable;

  /// No description provided for @notificationReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở quét sản phẩm mới'**
  String get notificationReminder;

  /// No description provided for @notificationTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc nhở'**
  String get notificationTime;

  /// No description provided for @privacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách quyền riêng tư'**
  String get privacyPolicy;

  /// No description provided for @privacyDataLocal.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu lưu cục bộ'**
  String get privacyDataLocal;

  /// No description provided for @privacyDataSent.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gửi đến API'**
  String get privacyDataSent;

  /// No description provided for @privacyLocalDesc.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử quét, hồ sơ người dùng, cài đặt được lưu hoàn toàn trên thiết bị của bạn.'**
  String get privacyLocalDesc;

  /// No description provided for @privacyApiDesc.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách thành phần sản phẩm được gửi đến Groq API để phân tích AI. Không có thông tin cá nhân nào được gửi đi.'**
  String get privacyApiDesc;

  /// No description provided for @about.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get about;

  /// No description provided for @aboutVersion.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get aboutVersion;

  /// No description provided for @aboutTeam.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm phát triển'**
  String get aboutTeam;

  /// No description provided for @aboutGithub.
  ///
  /// In vi, this message translates to:
  /// **'GitHub'**
  String get aboutGithub;

  /// No description provided for @aboutMission.
  ///
  /// In vi, this message translates to:
  /// **'Hướng đến SDG 12 — Tiêu dùng có trách nhiệm'**
  String get aboutMission;

  /// No description provided for @deleteData.
  ///
  /// In vi, this message translates to:
  /// **'Xóa dữ liệu'**
  String get deleteData;

  /// No description provided for @deleteDataHint.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác này sẽ xóa toàn bộ lịch sử quét và hồ sơ người dùng khỏi thiết bị.'**
  String get deleteDataHint;

  /// No description provided for @deleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa dữ liệu'**
  String get deleteConfirm;

  /// No description provided for @deleteConfirmHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa toàn bộ dữ liệu? Thao tác này không thể hoàn tác.'**
  String get deleteConfirmHint;

  /// No description provided for @deleteSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa toàn bộ dữ liệu'**
  String get deleteSuccess;

  /// No description provided for @dataUsage.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng dữ liệu'**
  String get dataUsage;

  /// No description provided for @cacheSize.
  ///
  /// In vi, this message translates to:
  /// **'Dung lượng cache'**
  String get cacheSize;

  /// No description provided for @historySize.
  ///
  /// In vi, this message translates to:
  /// **'Dung lượng lịch sử'**
  String get historySize;

  /// No description provided for @clearCache.
  ///
  /// In vi, this message translates to:
  /// **'Xóa cache'**
  String get clearCache;

  /// No description provided for @clearCacheSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa cache'**
  String get clearCacheSuccess;

  /// No description provided for @cacheManagement.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý cache'**
  String get cacheManagement;

  /// No description provided for @openSource.
  ///
  /// In vi, this message translates to:
  /// **'Mã nguồn mở'**
  String get openSource;

  /// No description provided for @openSourceHint.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng sử dụng các thư viện mã nguồn mở sau:'**
  String get openSourceHint;

  /// No description provided for @feedback.
  ///
  /// In vi, this message translates to:
  /// **'Gửi phản hồi'**
  String get feedback;

  /// No description provided for @feedbackHint.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi của bạn giúp chúng tôi cải thiện ứng dụng.'**
  String get feedbackHint;

  /// No description provided for @feedbackSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi phản hồi qua email'**
  String get feedbackSend;

  /// No description provided for @help.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & FAQ'**
  String get help;

  /// No description provided for @helpFaq.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get helpFaq;

  /// No description provided for @helpQ1.
  ///
  /// In vi, this message translates to:
  /// **'Làm thế nào để quét sản phẩm?'**
  String get helpQ1;

  /// No description provided for @helpA1.
  ///
  /// In vi, this message translates to:
  /// **'Mở màn hình Quét, hướng camera vào mã vạch sản phẩm.'**
  String get helpA1;

  /// No description provided for @helpQ2.
  ///
  /// In vi, this message translates to:
  /// **'Tại sao không tìm thấy sản phẩm?'**
  String get helpQ2;

  /// No description provided for @helpA2.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm có thể chưa có trong cơ sở dữ liệu Open Food Facts. Thử quét OCR nhãn thành phần.'**
  String get helpA2;

  /// No description provided for @helpQ3.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu cá nhân có được chia sẻ không?'**
  String get helpQ3;

  /// No description provided for @helpA3.
  ///
  /// In vi, this message translates to:
  /// **'Không. Toàn bộ dữ liệu cá nhân lưu cục bộ trên thiết bị.'**
  String get helpA3;

  /// No description provided for @tutorial.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn sử dụng'**
  String get tutorial;

  /// No description provided for @tutorialStep1.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã vạch'**
  String get tutorialStep1;

  /// No description provided for @tutorialStep2.
  ///
  /// In vi, this message translates to:
  /// **'Xem phân tích AI'**
  String get tutorialStep2;

  /// No description provided for @tutorialStep3.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập hồ sơ'**
  String get tutorialStep3;

  /// No description provided for @permissions.
  ///
  /// In vi, this message translates to:
  /// **'Quyền ứng dụng'**
  String get permissions;

  /// No description provided for @permissionCamera.
  ///
  /// In vi, this message translates to:
  /// **'Camera'**
  String get permissionCamera;

  /// No description provided for @permissionCameraDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cần thiết để quét mã vạch và nhãn sản phẩm'**
  String get permissionCameraDesc;

  /// No description provided for @permissionStorage.
  ///
  /// In vi, this message translates to:
  /// **'Bộ nhớ'**
  String get permissionStorage;

  /// No description provided for @permissionStorageDesc.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lịch sử quét và cache sản phẩm cục bộ'**
  String get permissionStorageDesc;

  /// No description provided for @permissionInternet.
  ///
  /// In vi, this message translates to:
  /// **'Internet'**
  String get permissionInternet;

  /// No description provided for @permissionInternetDesc.
  ///
  /// In vi, this message translates to:
  /// **'Gọi Open Food Facts API và Groq AI API'**
  String get permissionInternetDesc;

  /// No description provided for @update.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra cập nhật'**
  String get update;

  /// No description provided for @updateLatest.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang dùng phiên bản mới nhất'**
  String get updateLatest;

  /// No description provided for @updateAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Có phiên bản mới'**
  String get updateAvailable;

  /// No description provided for @updateNow.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật ngay'**
  String get updateNow;

  /// No description provided for @terms.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get terms;

  /// No description provided for @termsAccept.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý với điều khoản'**
  String get termsAccept;

  /// No description provided for @credits.
  ///
  /// In vi, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @creditsHint.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn các dự án mã nguồn mở đã hỗ trợ EcoScan AI.'**
  String get creditsHint;

  /// No description provided for @apiKey.
  ///
  /// In vi, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @apiKeyHint.
  ///
  /// In vi, this message translates to:
  /// **'Dành cho nhà phát triển'**
  String get apiKeyHint;

  /// No description provided for @apiKeyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Groq API Key'**
  String get apiKeyLabel;

  /// No description provided for @apiKeySave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu API Key'**
  String get apiKeySave;

  /// No description provided for @onboardingTitle1.
  ///
  /// In vi, this message translates to:
  /// **'Quét & Khám phá'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã vạch hoặc nhãn sản phẩm để hiểu rõ những gì bạn đang tiêu dùng.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích AI thông minh'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In vi, this message translates to:
  /// **'AI phân tích từng thành phần — đánh giá sức khỏe, môi trường và đạo đức.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân hóa cho bạn'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập hồ sơ dị ứng và lối sống để nhận cảnh báo phù hợp.'**
  String get onboardingDesc3;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @homeWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến EcoScan AI'**
  String get homeWelcome;

  /// No description provided for @homeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu dùng thông minh, sống có trách nhiệm'**
  String get homeSubtitle;

  /// No description provided for @homeScanNow.
  ///
  /// In vi, this message translates to:
  /// **'Quét ngay'**
  String get homeScanNow;

  /// No description provided for @homeRecentScans.
  ///
  /// In vi, this message translates to:
  /// **'Quét gần đây'**
  String get homeRecentScans;

  /// No description provided for @homeQuickStats.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê nhanh'**
  String get homeQuickStats;

  /// No description provided for @noData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get noData;

  /// No description provided for @errorOccurred.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get tryAgain;

  /// No description provided for @goHome.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get goHome;
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
