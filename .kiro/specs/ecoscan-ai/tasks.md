# Kế Hoạch Triển Khai — EcoScan AI

- [x] 1. Khởi tạo dự án Flutter và cấu hình cơ bản
  - Chạy `flutter create ecoscan_ai`, cấu hình `pubspec.yaml` với toàn bộ dependencies (flutter_bloc, go_router, hive_flutter, mobile_scanner, google_mlkit_text_recognition, http, cached_network_image, fl_chart, google_fonts, lottie, share_plus, image_picker, intl)
  - Tạo cấu trúc thư mục: `lib/core/`, `lib/data/`, `lib/domain/`, `lib/presentation/`
  - Cấu hình `AppConstants` với Groq API key hardcode, base URLs cho Open Food Facts và Groq
  - Thiết lập `AppTheme` (light/dark) với color scheme eco (primary #2E7D32, secondary #81C784, warning #F9A825, danger #C62828)
  - Cấu hình `flutter_localizations` cho tiếng Việt (mặc định) và tiếng Anh, tạo file `app_vi.arb` và `app_en.arb`
  - _Requirements: 9.1, 10.1_

- [ ] 2. Xây dựng Data Models và Local Storage
- [ ] 2.1 Tạo các data models cốt lõi
  - Viết `ProductModel`, `NutritionModel`, `AIAnalysisModel`, `HealthAnalysis`, `EnvironmentAnalysis`, `EthicsAnalysis`, `GreenwashingResult`, `IngredientAnalysis`, `ScanRecord`, `UserProfile` với Hive annotations
  - Chạy `build_runner` để generate Hive adapters
  - _Requirements: 3.2, 4.2, 7.1_

- [ ] 2.2 Thiết lập Hive và SharedPreferences repositories
  - Implement `ScanHistoryRepository` với Hive Box (CRUD + giới hạn 500 bản ghi FIFO)
  - Implement `ProductCacheRepository` với Hive Box (cache 7 ngày)
  - Implement `UserProfileRepository` với SharedPreferences (JSON serialization)
  - Implement `SettingsRepository` với SharedPreferences (language, theme, notification)
  - _Requirements: 6.4, 7.1, 7.4, 7.5, 9.1_

- [ ] 3. Xây dựng Services tích hợp API
- [ ] 3.1 Implement OpenFoodFactsService
  - Viết `OpenFoodFactsService.getProduct(barcode)` gọi `GET /api/v2/product/{barcode}.json`, map response sang `ProductModel`
  - Viết `OpenFoodFactsService.searchAlternatives(category, excludeBarcode)` tìm sản phẩm thay thế
  - Xử lý lỗi: 404 (product not found), network timeout, JSON parse error
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 8.1_

- [ ] 3.2 Implement GroqService
  - Viết `GroqService.analyzeProduct(ProductModel)` gọi Groq API với OpenAI-compatible chat completions format, model `llama-3.3-70b-versatile`
  - Build prompt template tiếng Việt với `response_format: json_object`
  - Parse JSON response sang `AIAnalysisModel`, xử lý malformed JSON (fallback sang raw text)
  - Xử lý lỗi: 429 rate limit (hiển thị retry sau 60s), timeout 15s, invalid JSON
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 5.1, 5.2, 5.3_

- [ ] 3.3 Implement OCRService
  - Viết `OCRService` dùng `google_mlkit_text_recognition` để nhận dạng text từ `InputImage`
  - Implement `extractIngredients(String rawText)` để tách danh sách thành phần từ OCR output
  - Hỗ trợ cả camera stream (realtime) và ảnh tĩnh từ `image_picker`
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [ ] 4. Xây dựng BLoC/Cubit State Management
- [ ] 4.1 Implement ScanBloc
  - States: `ScanInitial`, `ScanActive`, `BarcodeDetected`, `ScanLoading`, `ScanSuccess(ProductModel)`, `ScanError`
  - Events: `StartScan`, `BarcodeScanned(barcode)`, `ManualBarcodeEntered(barcode)`, `RetryFetch`
  - Tích hợp `OpenFoodFactsService` và `ProductCacheRepository`
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 3.1, 3.2, 3.3, 3.4_

- [ ] 4.2 Implement AIBloc
  - States: `AIInitial`, `AILoading`, `AISuccess(AIAnalysisModel)`, `AIError(String message)`
  - Events: `AnalyzeProduct(ProductModel)`, `AnalyzeOCRText(String text)`, `RetryAnalysis`
  - Tích hợp `GroqService`, áp dụng `UserProfile` filtering
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4_

- [ ] 4.3 Implement OCRBloc, ProfileCubit, HistoryCubit, SettingsCubit
  - `OCRBloc`: quản lý luồng camera OCR và kết quả text recognition
  - `ProfileCubit`: load/save UserProfile, expose allergen/lifestyle filtering
  - `HistoryCubit`: load/delete scan history, search/filter
  - `SettingsCubit`: language switching (triggering locale rebuild), theme, notifications
  - _Requirements: 2.1, 2.2, 6.1, 6.2, 6.3, 6.4, 7.2, 7.4, 7.5, 9.1, 9.4_

- [ ] 5. Xây dựng Shared Widgets
  - `EcoScoreChip`: hiển thị 🟢🟡🔴 với màu và label tương ứng score
  - `IngredientCard`: card hiển thị 1 thành phần với safety indicator và explanation
  - `ScoreGauge`: gauge chart hình tròn hiển thị điểm 0-100
  - `GreenwashingBadge`: badge cảnh báo greenwashing với 3 mức
  - `AllergenWarningBanner`: banner đỏ cảnh báo dị ứng
  - `ProductListTile`: tile dùng trong history và alternatives
  - `SectionHeader`, `LoadingOverlay`, `ErrorStateWidget`, `EmptyStateWidget`
  - _Requirements: 4.3, 5.3, 6.3, 7.2_

- [ ] 6. Implement Nhóm A — Core Scanning Screens (40 màn hình)
- [ ] 6.1 Onboarding và Home
  - `SplashScreen`: logo animation với Lottie, kiểm tra onboarding_done → điều hướng
  - `Onboarding1/2/3Screen`: 3 trang giới thiệu với PageView, nút "Bắt đầu"
  - `HomeScreen`: Bottom NavigationBar (Scan / History / Profile / Settings), welcome banner, quick stats
  - _Requirements: 10.1_

- [ ] 6.2 Scan và Camera Screens
  - `ScanScreen`: `MobileScanner` widget với barcode overlay, nút chuyển OCR/manual
  - `OCRScanScreen`: `MobileScanner` + ML Kit overlay, highlight detected text vùng ingredients
  - `ManualInputScreen`: TextField nhập 8-14 ký tự số, validation, nút tra cứu
  - `ScanLoadingScreen`: Lottie animation loading, thông báo "Đang tìm sản phẩm..."
  - `ScanTipsScreen`, `BarcodeNotReadableScreen`, `CameraPermissionScreen`
  - `OCRResultScreen`: hiển thị text đã nhận dạng, nút "Phân tích"
  - `OCREditScreen`: TextField chỉnh sửa text OCR trước khi gửi AI
  - `ScanSuccessScreen`: animation thành công ngắn
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 2.2, 2.3, 2.4_

- [ ] 6.3 Product Detail Screens
  - `ProductFoundScreen`: card xác nhận sản phẩm (ảnh, tên, brand), nút "Xem chi tiết"
  - `ProductNotFoundScreen`: thông báo không tìm thấy, nút "Thử OCR" và "Đóng góp"
  - `ProductDetailScreen`: đầy đủ thông tin (ảnh, tên, brand, xuất xứ, dinh dưỡng tóm tắt, EcoScore chip)
  - `NutritionDetailScreen`: bảng dinh dưỡng đầy đủ với progress bars
  - `ProductImageScreen`: xem ảnh full screen với zoom
  - `ContributeProductScreen`: form đơn giản hướng dẫn đóng góp Open Food Facts
  - _Requirements: 3.2, 10.1_

- [ ] 6.4 Analysis và Score Screens
  - `IngredientBreakdownScreen`: danh sách tất cả ingredients với `IngredientCard`, filter safety
  - `IngredientDetailScreen`: chi tiết 1 thành phần (giải thích AI, safety level, context)
  - `ScoreBreakdownScreen`: 3 vòng gauge (health/environment/ethics) + overall, `ScoreGauge`
  - `EcoScoreExplainScreen`: giải thích cách tính điểm
  - `AIExplanationScreen`: full AI analysis text dạng collapsible sections
  - `HealthAnalysisScreen`, `EnvironmentAnalysisScreen`, `EthicsAnalysisScreen`: màn hình chi tiết từng chiều
  - `AILoadingScreen`: animation đang phân tích AI
  - `AIErrorScreen`: lỗi AI với nút retry
  - _Requirements: 4.2, 4.3, 4.4_

- [ ] 6.5 Greenwashing, Audience, Alternatives
  - `GreenwashingDetectorScreen`: danh sách claims vs reality, `GreenwashingBadge`
  - `GreenwashingDetailScreen`: chi tiết 1 claim greenwashing với evidence
  - `SuitableAudienceScreen`: danh sách đối tượng phù hợp/không phù hợp dạng chips
  - `AlternativeProductsScreen`: grid 3+ sản phẩm thay thế từ Open Food Facts
  - `AlternativeDetailScreen`: product detail của sản phẩm thay thế
  - `ProductCompareScreen`: side-by-side so sánh 2 sản phẩm (score, ingredients count)
  - `NetworkErrorScreen`: lỗi mạng với nút retry
  - `AllergenWarningScreen`, `LifestyleConflictScreen`
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 8.1, 8.2, 8.3_

- [ ] 7. Implement Nhóm B — Personalization Screens (20 màn hình)
- [ ] 7.1 Profile Setup và Edit
  - `ProfileSetupScreen`: wizard thiết lập hồ sơ lần đầu (sau onboarding)
  - `UserProfileScreen`: tổng quan hồ sơ, danh sách dị ứng + lối sống, nút chỉnh sửa
  - `EditAllergiesScreen`: multi-select danh sách allergens chuẩn (gluten, lactose, nuts, paraben, sulfate, soy, eggs, shellfish, pollen)
  - `CustomAllergyScreen`: TextField thêm dị ứng tùy chỉnh
  - `AllergyDetailScreen`: giải thích chi tiết 1 loại dị ứng
  - `EditLifestyleScreen`: multi-select (Vegetarian, Vegan, Eco-conscious, Cruelty-free only)
  - `LifestyleDetailScreen`: giải thích chi tiết 1 lối sống
  - `ProfileEditScreen`: chỉnh sửa thông tin tên hiển thị
  - `ProfileCompleteScreen`: màn hình hoàn thành setup
  - `ProfileSummaryScreen`: tóm tắt hồ sơ dạng chips
  - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [ ] 7.2 Personalized AI và Goals
  - `PersonalizedWarningScreen`: cảnh báo dị ứng/lối sống nổi bật khi quét sản phẩm
  - `AIPersonalizedScreen`: phân tích AI có tính đến hồ sơ cá nhân
  - `DietaryPreferenceScreen`: chi tiết tùy chọn chế độ ăn
  - `EcoPreferenceScreen`: tùy chọn ưu tiên môi trường
  - `HealthGoalScreen`, `EcoGoalScreen`: thiết lập mục tiêu
  - `PersonalInsightScreen`: insight AI từ lịch sử quét + hồ sơ
  - `RecommendationScreen`: gợi ý cải thiện từ AI dựa trên lịch sử
  - `NotificationPreferenceScreen`: tùy chọn thông báo cá nhân
  - `ProfileAchievementScreen`: danh sách huy hiệu đã đạt
  - _Requirements: 4.5, 6.1, 6.2, 6.3_

- [ ] 8. Implement Nhóm C — Dashboard & Analytics Screens (20 màn hình)
- [ ] 8.1 Scan History
  - `ScanHistoryScreen`: ListView sản phẩm đã quét, sắp xếp mới nhất, `ProductListTile` với EcoScore
  - `HistoryDetailScreen`: hiển thị lại full analysis từ `ScanRecord` cục bộ (không gọi API)
  - `HistorySearchScreen`: TextField tìm kiếm theo tên sản phẩm
  - `HistoryFilterScreen`: filter theo EcoScore level, danh mục, khoảng thời gian
  - `HistoryEmptyScreen`: empty state khi chưa có lịch sử
  - _Requirements: 7.1, 7.2, 7.4, 7.5_

- [ ] 8.2 Personal Impact và Charts
  - `PersonalImpactScreen`: tổng quan stats (tổng scan, tỷ lệ 🟢🟡🔴, streak xanh)
  - `WeeklyReportScreen`: báo cáo tuần với `fl_chart` bar chart
  - `MonthlyReportScreen`: báo cáo tháng với line chart xu hướng
  - `ImpactChartScreen`: biểu đồ pie chart phân bổ Eco Score
  - `CategoryBreakdownScreen`: phân tích theo danh mục sản phẩm
  - `EcoTrendScreen`: xu hướng tiêu dùng xanh theo thời gian
  - `ScoreHistoryScreen`: lịch sử điểm số từng lần quét
  - `TopProductsScreen`: top 5 sản phẩm tốt nhất đã quét
  - `WorstProductsScreen`: top 5 sản phẩm kém nhất
  - `ImpactEmptyScreen`: empty state chưa đủ dữ liệu
  - `ShareImpactScreen`: tạo ảnh share tác động cá nhân
  - `ExportDataScreen`: xuất CSV/JSON lịch sử quét
  - `AchievementListScreen`, `AchievementDetailScreen`, `MilestoneScreen`
  - _Requirements: 7.2, 7.3_

- [ ] 9. Implement Nhóm D — Settings & System Screens (20 màn hình)
  - `SettingsScreen`: danh sách settings chính với ListTile
  - `LanguageScreen`: chọn VI/EN, cập nhật locale ngay lập tức (không restart)
  - `NotificationScreen`: toggle thông báo + picker giờ nhắc nhở
  - `ThemeScreen`: chọn Light / Dark / System
  - `FontSizeScreen`: slider chỉnh cỡ chữ
  - `PrivacyPolicyScreen`: text dài mô tả dữ liệu lưu cục bộ vs gửi API
  - `AboutScreen`: version, team info, link GitHub
  - `DeleteDataScreen`: mô tả dữ liệu sẽ xóa
  - `DeleteConfirmScreen`: AlertDialog + nút xác nhận xóa toàn bộ Hive + SharedPreferences
  - `DataUsageScreen`: thống kê bộ nhớ cache đang dùng
  - `CacheScreen`: quản lý và xóa cache sản phẩm
  - `OpenSourceScreen`: danh sách packages mã nguồn mở
  - `FeedbackScreen`: form gửi feedback (deep link đến email)
  - `HelpScreen`: FAQ dạng ExpansionTile
  - `TutorialScreen`: video/GIF hướng dẫn sử dụng
  - `PermissionsScreen`: danh sách quyền app đang dùng
  - `UpdateScreen`: kiểm tra version mới
  - `TermsScreen`: điều khoản sử dụng
  - `CreditsScreen`: credits & acknowledgements
  - `APIKeyScreen`: (ẩn, dev only) xem/override API key nếu cần
  - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

- [ ] 10. Cấu hình GoRouter và điều hướng hoàn chỉnh
  - Định nghĩa toàn bộ 100 routes trong `AppRouter` với GoRouter
  - Cấu hình `initialLocation` dựa trên `onboarding_done` flag
  - Implement deep linking cho product sharing (route `/product/detail?barcode=xxx`)
  - Cấu hình `ShellRoute` cho Bottom NavigationBar (Home/Scan/History/Profile)
  - Xử lý navigation guards (redirect nếu chưa cấp quyền camera khi vào Scan)
  - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

- [ ] 11. Tích hợp Auto-save Scan History và Personalization filtering
  - Trong `AIBloc`, sau khi `AISuccess`, tự động gọi `ScanHistoryRepository.save(ScanRecord)`
  - Trong `AIBloc`, khi build prompt cho Groq, inject `UserProfile` allergies/lifestyle vào prompt để AI tự filter và cảnh báo
  - Implement `EcoScoreCalculator` tính điểm tổng hợp từ 3 sub-scores (health 40%, environment 40%, ethics 20%)
  - Implement Achievement system: check milestones sau mỗi lần scan (first scan, 10 scans, first green product, v.v.)
  - _Requirements: 4.5, 6.3, 7.1, 7.4_

- [ ] 12. Hoàn thiện Localization và Theme switching
  - Điền đầy đủ strings vào `app_vi.arb` và `app_en.arb` cho toàn bộ 100 màn hình
  - Implement `SettingsCubit.changeLanguage()` trigger `Locale` rebuild toàn app qua `MaterialApp.locale`
  - Implement `SettingsCubit.changeTheme()` trigger `ThemeMode` rebuild
  - Đảm bảo font size từ `SettingsCubit` được áp dụng qua `TextTheme` scaling
  - _Requirements: 9.1_
