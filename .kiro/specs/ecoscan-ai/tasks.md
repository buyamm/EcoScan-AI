# Kế Hoạch Triển Khai — EcoScan AI

- [x] 1. Khởi tạo dự án Flutter và cấu hình cơ bản
  - Chạy `flutter create ecoscan_ai`, cấu hình `pubspec.yaml` với toàn bộ dependencies (flutter_bloc, go_router, hive_flutter, mobile_scanner, google_mlkit_text_recognition, http, cached_network_image, fl_chart, google_fonts, lottie, share_plus, image_picker, intl)
  - Tạo cấu trúc thư mục: `lib/core/`, `lib/data/`, `lib/domain/`, `lib/presentation/`
  - Cấu hình `AppConstants` với Groq API key hardcode, base URLs cho Open Food Facts và Groq
  - Thiết lập `AppTheme` (light/dark) với color scheme eco (primary #2E7D32, secondary #81C784, warning #F9A825, danger #C62828)
  - Cấu hình `flutter_localizations` cho tiếng Việt (mặc định) và tiếng Anh, tạo file `app_vi.arb` và `app_en.arb`
  - _Requirements: 9.1, 10.1_

- [x] 2. Xây dựng Data Models và Local Storage
- [x] 2.1 Tạo các data models cốt lõi
  - Viết `ProductModel`, `NutritionModel`, `AIAnalysisModel`, `HealthAnalysis`, `EnvironmentAnalysis`, `EthicsAnalysis`, `GreenwashingResult`, `IngredientAnalysis`, `ScanRecord`, `UserProfile` với Hive annotations
  - Chạy `build_runner` để generate Hive adapters
  - _Requirements: 3.2, 4.2, 7.1_

- [x] 2.2 Thiết lập Hive và SharedPreferences repositories
  - Implement `ScanHistoryRepository` với Hive Box (CRUD + giới hạn 500 bản ghi FIFO)
  - Implement `ProductCacheRepository` với Hive Box (cache 7 ngày)
  - Implement `UserProfileRepository` với SharedPreferences (JSON serialization)
  - Implement `SettingsRepository` với SharedPreferences (language, theme, notification)
  - _Requirements: 6.4, 7.1, 7.4, 7.5, 9.1_

- [x] 3. Xây dựng Services tích hợp API
- [x] 3.1 Implement OpenFoodFactsService
  - Viết `OpenFoodFactsService.getProduct(barcode)` gọi `GET /api/v2/product/{barcode}.json`, map response sang `ProductModel`
  - Viết `OpenFoodFactsService.searchAlternatives(category, excludeBarcode)` tìm sản phẩm thay thế
  - Xử lý lỗi: 404 (product not found), network timeout, JSON parse error
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 8.1_

- [x] 3.2 Implement GroqService
  - Viết `GroqService.analyzeProduct(ProductModel)` gọi Groq API với OpenAI-compatible chat completions format, model `llama-3.3-70b-versatile`
  - Build prompt template tiếng Việt với `response_format: json_object`
  - Parse JSON response sang `AIAnalysisModel`, xử lý malformed JSON (fallback sang raw text)
  - Xử lý lỗi: 429 rate limit (hiển thị retry sau 60s), timeout 15s, invalid JSON
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 5.1, 5.2, 5.3_

- [x] 3.3 Implement OCRService
  - Viết `OCRService` dùng `google_mlkit_text_recognition` để nhận dạng text từ `InputImage`
  - Implement `extractIngredients(String rawText)` để tách danh sách thành phần từ OCR output
  - Hỗ trợ cả camera stream (realtime) và ảnh tĩnh từ `image_picker`
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [x] 4. Xây dựng BLoC/Cubit State Management
- [x] 4.1 Implement ScanBloc
  - States: `ScanInitial`, `ScanActive`, `BarcodeDetected`, `ScanLoading`, `ScanSuccess(ProductModel)`, `ScanError`
  - Events: `StartScan`, `BarcodeScanned(barcode)`, `ManualBarcodeEntered(barcode)`, `RetryFetch`
  - Tích hợp `OpenFoodFactsService` và `ProductCacheRepository`
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 3.1, 3.2, 3.3, 3.4_

- [x] 4.2 Implement AIBloc
  - States: `AIInitial`, `AILoading`, `AISuccess(AIAnalysisModel)`, `AIError(String message)`
  - Events: `AnalyzeProduct(ProductModel)`, `AnalyzeOCRText(String text)`, `RetryAnalysis`
  - Tích hợp `GroqService`, áp dụng `UserProfile` filtering
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4_

- [x] 4.3 Implement OCRBloc, ProfileCubit, HistoryCubit, SettingsCubit
  - `OCRBloc`: quản lý luồng camera OCR và kết quả text recognition
  - `ProfileCubit`: load/save UserProfile, expose allergen/lifestyle filtering
  - `HistoryCubit`: load/delete scan history, search/filter
  - `SettingsCubit`: language switching (triggering locale rebuild), theme, notifications
  - _Requirements: 2.1, 2.2, 6.1, 6.2, 6.3, 6.4, 7.2, 7.4, 7.5, 9.1, 9.4_

- [x] 5. Xây dựng Shared Widgets
  - `EcoScoreChip`: hiển thị 🟢🟡🔴 với màu và label tương ứng score
  - `IngredientCard`: card hiển thị 1 thành phần với safety indicator và explanation
  - `ScoreGauge`: gauge chart hình tròn hiển thị điểm 0-100
  - `GreenwashingBadge`: badge cảnh báo greenwashing với 3 mức
  - `AllergenWarningBanner`: banner đỏ cảnh báo dị ứng
  - `ProductListTile`: tile dùng trong history và alternatives
  - `SectionHeader`, `LoadingOverlay`, `ErrorStateWidget`, `EmptyStateWidget`
  - _Requirements: 4.3, 5.3, 6.3, 7.2_

- [-] 6. Implement Nhóm A — Core Scanning Screens (40 màn hình)
- [x] 6.1 Onboarding và Home
  - `SplashScreen`: logo animation với Lottie, kiểm tra onboarding_done → điều hướng
  - `Onboarding1/2/3Screen`: 3 trang giới thiệu với PageView, nút "Bắt đầu"
  - `HomeScreen`: Bottom NavigationBar (Scan / History / Profile / Settings), welcome banner, quick stats
  - _Requirements: 10.1_

- [x] 6.2 Scan và Camera Screens
  - `ScanScreen`: `MobileScanner` widget với barcode overlay, nút chuyển OCR/manual
  - `OCRScanScreen`: `MobileScanner` + ML Kit overlay, highlight detected text vùng ingredients
  - `ManualInputScreen`: TextField nhập 8-14 ký tự số, validation, nút tra cứu
  - `ScanLoadingScreen`: Lottie animation loading, thông báo "Đang tìm sản phẩm..."
  - `ScanTipsScreen`, `BarcodeNotReadableScreen`, `CameraPermissionScreen`
  - `OCRResultScreen`: hiển thị text đã nhận dạng, nút "Phân tích"
  - `OCREditScreen`: TextField chỉnh sửa text OCR trước khi gửi AI
  - `ScanSuccessScreen`: animation thành công ngắn
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 2.2, 2.3, 2.4_

- [x] 6.3 Product Detail Screens
  - `ProductFoundScreen`: card xác nhận sản phẩm (ảnh, tên, brand), nút "Xem chi tiết"
  - `ProductNotFoundScreen`: thông báo không tìm thấy, nút "Thử OCR" và "Đóng góp"
  - `ProductDetailScreen`: đầy đủ thông tin (ảnh, tên, brand, xuất xứ, dinh dưỡng tóm tắt, EcoScore chip)
  - `NutritionDetailScreen`: bảng dinh dưỡng đầy đủ với progress bars
  - `ProductImageScreen`: xem ảnh full screen với zoom
  - `ContributeProductScreen`: form đơn giản hướng dẫn đóng góp Open Food Facts
  - _Requirements: 3.2, 10.1_

- [x] 6.4 Analysis và Score Screens
  - `IngredientBreakdownScreen`: danh sách tất cả ingredients với `IngredientCard`, filter safety
  - `IngredientDetailScreen`: chi tiết 1 thành phần (giải thích AI, safety level, context)
  - `ScoreBreakdownScreen`: 3 vòng gauge (health/environment/ethics) + overall, `ScoreGauge`
  - `EcoScoreExplainScreen`: giải thích cách tính điểm
  - `AIExplanationScreen`: full AI analysis text dạng collapsible sections
  - `HealthAnalysisScreen`, `EnvironmentAnalysisScreen`, `EthicsAnalysisScreen`: màn hình chi tiết từng chiều
  - `AILoadingScreen`: animation đang phân tích AI
  - `AIErrorScreen`: lỗi AI với nút retry
  - _Requirements: 4.2, 4.3, 4.4_

- [x] 6.5 Greenwashing, Audience, Alternatives
  - `GreenwashingDetectorScreen`: danh sách claims vs reality, `GreenwashingBadge`
  - `GreenwashingDetailScreen`: chi tiết 1 claim greenwashing với evidence
  - `SuitableAudienceScreen`: danh sách đối tượng phù hợp/không phù hợp dạng chips
  - `AlternativeProductsScreen`: grid 3+ sản phẩm thay thế từ Open Food Facts
  - `AlternativeDetailScreen`: product detail của sản phẩm thay thế
  - `ProductCompareScreen`: side-by-side so sánh 2 sản phẩm (score, ingredients count)
  - `NetworkErrorScreen`: lỗi mạng với nút retry
  - `AllergenWarningScreen`, `LifestyleConflictScreen`
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 8.1, 8.2, 8.3_

- [x] 7. Implement Nhóm B — Personalization Screens (20 màn hình)
- [x] 7.1 Profile Setup và Edit
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

- [x] 7.2 Personalized AI và Goals
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

- [x] 8. Implement Nhóm C — Dashboard & Analytics Screens (20 màn hình)
- [x] 8.1 Scan History
  - `ScanHistoryScreen`: ListView sản phẩm đã quét, sắp xếp mới nhất, `ProductListTile` với EcoScore
  - `HistoryDetailScreen`: hiển thị lại full analysis từ `ScanRecord` cục bộ (không gọi API)
  - `HistorySearchScreen`: TextField tìm kiếm theo tên sản phẩm
  - `HistoryFilterScreen`: filter theo EcoScore level, danh mục, khoảng thời gian
  - `HistoryEmptyScreen`: empty state khi chưa có lịch sử
  - _Requirements: 7.1, 7.2, 7.4, 7.5_

- [x] 8.2 Personal Impact và Charts
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

- [x] 9. Implement Nhóm D — Settings & System Screens (20 màn hình)
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

- [x] 10. Cấu hình GoRouter và điều hướng hoàn chỉnh
  - Định nghĩa toàn bộ 100 routes trong `AppRouter` với GoRouter
  - Cấu hình `initialLocation` dựa trên `onboarding_done` flag
  - Implement deep linking cho product sharing (route `/product/detail?barcode=xxx`)
  - Cấu hình `ShellRoute` cho Bottom NavigationBar (Home/Scan/History/Profile)
  - Xử lý navigation guards (redirect nếu chưa cấp quyền camera khi vào Scan)
  - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

- [x] 11. Tích hợp Auto-save Scan History và Personalization filtering
  - Trong `AIBloc`, sau khi `AISuccess`, tự động gọi `ScanHistoryRepository.save(ScanRecord)`
  - Trong `AIBloc`, khi build prompt cho Groq, inject `UserProfile` allergies/lifestyle vào prompt để AI tự filter và cảnh báo
  - Implement `EcoScoreCalculator` tính điểm tổng hợp từ 3 sub-scores (health 40%, environment 40%, ethics 20%)
  - Implement Achievement system: check milestones sau mỗi lần scan (first scan, 10 scans, first green product, v.v.)
  - _Requirements: 4.5, 6.3, 7.1, 7.4_

- [x] 12. Hoàn thiện Localization và Theme switching
  - Điền đầy đủ strings vào `app_vi.arb` và `app_en.arb` cho toàn bộ 100 màn hình
  - Implement `SettingsCubit.changeLanguage()` trigger `Locale` rebuild toàn app qua `MaterialApp.locale`
  - Implement `SettingsCubit.changeTheme()` trigger `ThemeMode` rebuild
  - Đảm bảo font size từ `SettingsCubit` được áp dụng qua `TextTheme` scaling
  - _Requirements: 9.1_

---

## Các Task Bổ Sung

- [x] 13. Implement Google Sign-In
- [x] 13.1 Thêm dependency và cấu hình Google Sign-In
  - Thêm `google_sign_in: ^6.x` vào `pubspec.yaml`
  - Cấu hình `google-services.json` (Android) và `GoogleService-Info.plist` (iOS) — hướng dẫn trong README
  - Tạo `AuthRepository` với `signInWithGoogle()`, `signOut()`, `getCurrentUser()` trả về `GoogleSignInAccount?`
  - Lưu `displayName`, `email`, `photoUrl` vào `UserProfile` qua `UserProfileRepository`
  - _Requirements: 11.1, 11.2, 11.5_

- [x] 13.2 Implement màn hình Login và luồng xác thực
  - Tạo `LoginScreen` (`/login`) với nút "Đăng nhập bằng Google" và nút "Tiếp tục không đăng nhập"
  - Tạo `AuthCubit` với states: `AuthInitial`, `AuthLoading`, `AuthAuthenticated(user)`, `AuthGuest`, `AuthError`
  - Cập nhật `SplashScreen` để kiểm tra trạng thái auth: nếu đã đăng nhập → `/home`, nếu chưa → `/login`
  - Cập nhật `AppRouter` thêm route `/login`, cấu hình redirect guard
  - Sau đăng nhập lần đầu → redirect đến `/profile/setup`
  - _Requirements: 11.1, 11.2, 11.3, 11.4_

- [ ]* 13.3 Viết unit tests cho AuthRepository
  - Test `signInWithGoogle()` thành công và thất bại
  - Test `signOut()` xóa thông tin tài khoản
  - _Requirements: 11.2, 11.5_

- [x] 14. Hoàn thiện hồ sơ người dùng đầy đủ
- [x] 14.1 Mở rộng UserProfile model với dietary preferences
  - Thêm `List<DietaryPreference>` vào `UserProfile` với enum: `glutenFree`, `lactoseFree`, `lowSugar`, `lowSalt`, `keto`, `paleo`
  - Thêm `String? displayName`, `String? email`, `String? photoUrl` vào `UserProfile`
  - Chạy lại `build_runner` để regenerate Hive adapters
  - Cập nhật `UserProfileRepository` để serialize/deserialize các field mới
  - _Requirements: 12.1, 12.2, 12.3, 12.4_

- [x] 14.2 Implement DietaryPreferenceScreen thực tế
  - Cập nhật `DietaryPreferenceScreen` với multi-select chips cho 6 chế độ ăn
  - Kết nối với `ProfileCubit.updateDietaryPreferences()` để lưu ngay lập tức
  - Hiển thị mô tả ngắn cho từng chế độ ăn
  - _Requirements: 12.3, 12.4_

- [x] 14.3 Cập nhật ProfileSetupScreen thành wizard đầy đủ
  - Cập nhật `ProfileSetupScreen` thành wizard 3 bước: (1) Dị ứng, (2) Lối sống, (3) Chế độ ăn
  - Mỗi bước có nút "Tiếp theo" / "Bỏ qua" / "Quay lại"
  - Bước cuối navigate đến `ProfileCompleteScreen` rồi về `/home`
  - _Requirements: 12.1, 12.2, 12.3, 11.4_

- [x] 14.4 Cập nhật UserProfileScreen hiển thị đầy đủ 3 nhóm
  - Hiển thị section "Chế độ ăn" với chips màu cam bên cạnh Dị ứng và Lối sống
  - Thêm nút navigate đến `DietaryPreferenceScreen`
  - Hiển thị avatar Google (photoUrl) nếu đã đăng nhập
  - _Requirements: 12.5_

- [x] 15. Implement cảnh báo cá nhân hóa theo hồ sơ
- [x] 15.1 Cập nhật AIBloc để inject đầy đủ User Profile vào prompt
  - Cập nhật `GroqService._buildPrompt()` để inject cả `allergies`, `lifestyle` và `dietaryPreferences` vào prompt
  - Sau `AISuccess`, kiểm tra xung đột allergen: so sánh `analysis.ingredients` với `profile.allAllergies`
  - Sau `AISuccess`, kiểm tra xung đột lối sống: dùng `analysis.ethics` và `analysis.suitableFor/notSuitableFor`
  - Emit `AISuccess` với thêm fields: `allergenConflicts: List<String>`, `lifestyleConflicts: List<LifestyleOption>`
  - _Requirements: 13.1, 13.2, 13.3_

- [x] 15.2 Implement luồng cảnh báo sau khi phân tích AI
  - Cập nhật màn hình `AILoadingScreen` listener: sau `AISuccess`, nếu có `allergenConflicts` → navigate đến `/product/allergen`, nếu có `lifestyleConflicts` → navigate đến `/product/lifestyle`, nếu không → navigate đến `/product/score`
  - Cập nhật `AllergenWarningScreen` hiển thị danh sách thành phần gây dị ứng cụ thể với nút "Vẫn xem chi tiết"
  - Cập nhật `LifestyleConflictScreen` hiển thị thành phần xung đột lối sống với giải thích
  - _Requirements: 13.1, 13.2_

- [x] 15.3 Thêm section "Phù hợp với bạn" vào ProductDetailScreen
  - Thêm widget `_PersonalizedSection` vào `ProductDetailScreen` khi có cả `analysis` và `userProfile`
  - Hiển thị danh sách thành phần an toàn (xanh) và thành phần cần chú ý (đỏ) dựa trên hồ sơ
  - Nếu chưa có hồ sơ, hiển thị banner gợi ý thiết lập hồ sơ với nút navigate đến `/profile/setup`
  - _Requirements: 13.4, 13.5_

- [x] 16. Implement biểu đồ thực cho Dashboard
- [x] 16.1 Implement WeeklyReportScreen với bar chart thực
  - Tính toán dữ liệu 7 ngày gần nhất từ `HistoryCubit.state.allRecords`
  - Render `BarChart` (fl_chart) với 7 cột, mỗi cột stack 3 màu (green/yellow/red)
  - Hiển thị tooltip khi nhấn vào cột: ngày, số lượng, điểm trung bình
  - _Requirements: 14.1, 14.4_

- [x] 16.2 Implement MonthlyReportScreen với line chart thực
  - Tính toán điểm trung bình theo tuần trong 4 tuần gần nhất từ ScanHistory
  - Render `LineChart` (fl_chart) với 4 điểm dữ liệu, đường xu hướng
  - Hiển thị tooltip khi nhấn vào điểm: tuần, điểm trung bình, số lần quét
  - _Requirements: 14.2, 14.4_

- [x] 16.3 Implement ImpactChartScreen với pie chart thực
  - Tính toán tỷ lệ 🟢🟡🔴 từ toàn bộ ScanHistory
  - Render `PieChart` (fl_chart) với 3 phần, legend bên dưới
  - Xử lý trường hợp ít hơn 3 bản ghi → hiển thị `ImpactEmptyScreen`
  - _Requirements: 14.3, 14.5_

- [x] 17. Hoàn thiện luồng gợi ý sản phẩm thay thế
- [x] 17.1 Cập nhật OpenFoodFactsService.searchAlternatives()
  - Cập nhật `searchAlternatives()` để gọi `GET /cgi/search.pl?action=process&tagtype_0=categories&tag_0={category}&json=1&page_size=10`
  - Lọc kết quả: loại bỏ sản phẩm trùng barcode, sắp xếp theo `nutriscore_grade` tốt hơn
  - Nếu `category` trống, dùng `product.labels_tags[0]` làm fallback
  - _Requirements: 15.1, 15.4_

- [x] 17.2 Implement ProductCompareScreen thực tế
  - Cập nhật `ProductCompareScreen` hiển thị bảng so sánh 2 cột: sản phẩm gốc vs thay thế
  - So sánh: Eco Score (gauge nhỏ), điểm sức khỏe, điểm môi trường, số thành phần, Nutri-Score
  - Nút "Chọn sản phẩm này" trên cột thay thế để navigate đến `AlternativeDetailScreen`
  - _Requirements: 15.3_

- [x] 17.3 Lọc sản phẩm thay thế theo User Profile
  - Trong `AlternativeProductsScreen._loadAlternatives()`, sau khi nhận kết quả từ API, lọc bỏ sản phẩm chứa allergens từ `ProfileCubit.state.profile.allAllergies`
  - Hiển thị badge "Phù hợp với bạn ✓" trên sản phẩm thay thế không có xung đột
  - _Requirements: 15.5_

- [x] 18. Hoàn thiện tính năng OCR chụp nhãn thành phần
- [x] 18.1 Cập nhật OCRScanScreen với chế độ chụp ảnh tĩnh
  - Cập nhật `OCRScanScreen` thêm nút chụp ảnh (capture button) thay vì chỉ dùng camera stream
  - Khi nhấn chụp: dừng camera, lấy frame hiện tại, gửi vào `OCRBloc` qua `ProcessStaticImage`
  - Giữ nút "Chọn từ thư viện" cho ảnh có sẵn
  - Hiển thị hướng dẫn rõ ràng: "Căn chỉnh vào phần THÀNH PHẦN trên nhãn"
  - _Requirements: 16.1, 16.2_

- [x] 18.2 Cập nhật OCRResultScreen và OCREditScreen
  - Cập nhật `OCRResultScreen` hiển thị text đã nhận dạng trong scrollable container, nút "Chỉnh sửa" → `OCREditScreen`, nút "Phân tích ngay"
  - Khi nhấn "Phân tích ngay": dispatch `AnalyzeOCRText` vào `AIBloc`, navigate đến `/ai/loading`
  - Cập nhật `OCREditScreen` với TextField đầy đủ, nút "Xác nhận và phân tích"
  - Xử lý trường hợp text trống hoặc quá ngắn: hiển thị SnackBar hướng dẫn
  - _Requirements: 16.3, 16.4, 16.5_

- [x] 18.3 Cải thiện OCRBloc xử lý camera stream
  - Cập nhật `OCRBloc` để xử lý `MobileScannerImage` từ camera stream (không chỉ static image)
  - Thêm debounce 1 giây để tránh xử lý quá nhiều frame
  - Emit `OCRTextDetected` khi nhận dạng được text có độ dài > 20 ký tự
  - _Requirements: 16.2_

- [x] 19. Đảm bảo navigation và routing hoàn chỉnh
- [x] 19.1 Kiểm tra và fix tất cả navigation gaps
  - Đảm bảo mọi màn hình có AppBar với nút back hoặc close phù hợp
  - Fix `ScanLoadingScreen`: thêm `BlocListener<AIBloc>` để navigate sau khi AI phân tích xong
  - Fix `ProductFoundScreen`: nút "Xem chi tiết" navigate đến `/product/detail` với cả `product` và trigger AI analysis
  - Đảm bảo `ScoreBreakdownScreen` có nút navigate đến từng màn hình phân tích chi tiết (health/environment/ethics)
  - _Requirements: 10.1, 10.2, 10.3_

- [x] 19.2 Implement luồng AI loading → result hoàn chỉnh
  - Cập nhật `AILoadingScreen` với `BlocListener<AIBloc>`: `AISuccess` → kiểm tra conflicts → navigate đúng màn hình; `AIError` → navigate `/ai/error`
  - Cập nhật `AIErrorScreen` với nút "Thử lại" dispatch `RetryAnalysis` và nút "Quay lại"
  - Đảm bảo `ScoreBreakdownScreen` hiển thị nút navigate đến `/product/alternatives` khi score < 70
  - _Requirements: 4.4, 10.4_

- [x] 19.3 Liệt kê và document các flow chính
  - Tạo comment block trong `app_router.dart` mô tả 5 flow chính:
    1. Barcode flow: `/scan` → `/scan/loading` → `/product/found` → `/product/detail` → `/product/score` → `/product/alternatives`
    2. OCR flow: `/scan/ocr` → `/scan/ocr/result` → `/ai/loading` → `/product/score`
    3. Manual flow: `/scan/manual` → `/scan/loading` → `/product/found` → ...
    4. History flow: `/history` → `/history/detail` → (xem lại analysis)
    5. Profile flow: `/profile` → `/profile/allergies` → `/profile/lifestyle` → `/profile/dietary`
  - _Requirements: 10.1_
