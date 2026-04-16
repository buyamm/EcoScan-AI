# Tài Liệu Thiết Kế — EcoScan AI

## 1. Tổng Quan

EcoScan AI là ứng dụng Flutter thuần client (no-backend) cho phép người dùng quét mã vạch hoặc nhãn sản phẩm để nhận phân tích bền vững đa chiều bằng AI. Toàn bộ dữ liệu người dùng lưu cục bộ (SharedPreferences + Hive), API calls đến Open Food Facts và Google Gemini được thực hiện trực tiếp từ thiết bị.

Mục tiêu: 100 màn hình Flutter, hỗ trợ tiếng Việt/Anh, không cần đăng nhập.

---

## 2. Kiến Trúc

### 2.1 Kiến Trúc Tổng Thể

Ứng dụng theo mô hình **Clean Architecture** kết hợp **BLoC pattern** (flutter_bloc):

```
lib/
├── core/
│   ├── constants/         # API keys, endpoints, app constants
│   ├── theme/             # AppTheme, colors, typography
│   ├── utils/             # Helpers, extensions
│   └── localization/      # VI/EN strings (flutter_localizations)
├── data/
│   ├── models/            # Product, Ingredient, ScanRecord, UserProfile
│   ├── repositories/      # ProductRepository, ScanHistoryRepository
│   └── services/          # OpenFoodFactsService, GeminiService, OCRService
├── domain/
│   └── entities/          # Pure domain objects
├── presentation/
│   ├── blocs/             # ScanBloc, ProductBloc, AIBloc, ProfileBloc, HistoryBloc
│   ├── screens/           # 100 màn hình, tổ chức theo nhóm A/B/C/D
│   └── widgets/           # Shared widgets (EcoScoreChip, IngredientCard, v.v.)
└── main.dart
```

### 2.2 Luồng Dữ Liệu Chính

```mermaid
flowchart LR
    Camera -->|barcode/OCR| ScanBloc
    ScanBloc -->|barcode| ProductRepository
    ProductRepository -->|GET /product/{barcode}| OpenFoodFactsAPI
    OpenFoodFactsAPI -->|ProductModel| ProductBloc
    ProductBloc -->|ingredients list| GeminiService
    GeminiService -->|POST /generateContent| GeminiAPI
    GeminiAPI -->|AIAnalysis| AIBloc
    AIBloc --> UI
    UI -->|save| ScanHistoryRepository
    ScanHistoryRepository -->|Hive Box| LocalStorage
```

### 2.3 State Management

- **flutter_bloc** cho tất cả business logic
- **Cubit** cho các state đơn giản (Settings, Profile)
- **BLoC** cho luồng phức tạp (Scan, AI Analysis)

---

## 3. Thành Phần và Giao Diện

### 3.1 Danh Sách 100 Màn Hình

#### Nhóm A — Core Scanning (40 màn hình)

| # | Màn hình | Route | Mô tả |
|---|----------|-------|-------|
| 1 | SplashScreen | `/splash` | Logo + animation khởi động |
| 2 | Onboarding1Screen | `/onboarding/1` | Giới thiệu tính năng scan |
| 3 | Onboarding2Screen | `/onboarding/2` | Giới thiệu AI phân tích |
| 4 | Onboarding3Screen | `/onboarding/3` | Giới thiệu cá nhân hóa |
| 5 | HomeScreen | `/home` | Dashboard chính, bottom nav |
| 6 | ScanScreen | `/scan` | Camera + barcode overlay |
| 7 | OCRScanScreen | `/scan/ocr` | Camera + OCR overlay |
| 8 | ManualInputScreen | `/scan/manual` | Nhập mã vạch thủ công |
| 9 | ScanLoadingScreen | `/scan/loading` | Animation loading API |
| 10 | ProductFoundScreen | `/product/found` | Xác nhận sản phẩm tìm thấy |
| 11 | ProductNotFoundScreen | `/product/not-found` | Sản phẩm không có trong DB |
| 12 | ProductDetailScreen | `/product/detail` | Thông tin đầy đủ sản phẩm |
| 13 | NutritionDetailScreen | `/product/nutrition` | Bảng dinh dưỡng chi tiết |
| 14 | IngredientBreakdownScreen | `/product/ingredients` | Danh sách thành phần |
| 15 | IngredientDetailScreen | `/ingredient/detail` | Chi tiết 1 thành phần |
| 16 | ScoreBreakdownScreen | `/product/score` | Phân tích điểm số chi tiết |
| 17 | AIExplanationScreen | `/product/ai` | Giải thích AI toàn bộ |
| 18 | HealthAnalysisScreen | `/product/health` | Phân tích sức khỏe |
| 19 | EnvironmentAnalysisScreen | `/product/environment` | Phân tích môi trường |
| 20 | EthicsAnalysisScreen | `/product/ethics` | Phân tích đạo đức |
| 21 | GreenwashingDetectorScreen | `/product/greenwashing` | Phát hiện greenwashing |
| 22 | GreenwashingDetailScreen | `/product/greenwashing/detail` | Chi tiết từng tuyên bố |
| 23 | SuitableAudienceScreen | `/product/audience` | Đối tượng phù hợp/không phù hợp |
| 24 | AlternativeProductsScreen | `/product/alternatives` | Sản phẩm thay thế |
| 25 | AlternativeDetailScreen | `/product/alternatives/detail` | Chi tiết sản phẩm thay thế |
| 26 | ProductCompareScreen | `/product/compare` | So sánh 2 sản phẩm |
| 27 | AILoadingScreen | `/ai/loading` | Loading phân tích AI |
| 28 | AIErrorScreen | `/ai/error` | Lỗi Gemini API |
| 29 | NetworkErrorScreen | `/error/network` | Lỗi kết nối mạng |
| 30 | CameraPermissionScreen | `/error/camera` | Hướng dẫn cấp quyền camera |
| 31 | ScanTipsScreen | `/scan/tips` | Mẹo quét hiệu quả |
| 32 | BarcodeNotReadableScreen | `/scan/unreadable` | Mã vạch không đọc được |
| 33 | OCRResultScreen | `/scan/ocr/result` | Kết quả OCR trước khi phân tích |
| 34 | OCREditScreen | `/scan/ocr/edit` | Chỉnh sửa text OCR |
| 35 | ProductImageScreen | `/product/image` | Xem ảnh sản phẩm full |
| 36 | AllergenWarningScreen | `/product/allergen` | Cảnh báo dị ứng |
| 37 | LifestyleConflictScreen | `/product/lifestyle` | Xung đột lối sống |
| 38 | EcoScoreExplainScreen | `/product/score/explain` | Giải thích cách tính Eco Score |
| 39 | ContributeProductScreen | `/product/contribute` | Đóng góp dữ liệu sản phẩm |
| 40 | ScanSuccessScreen | `/scan/success` | Xác nhận quét thành công |

#### Nhóm B — Personalization (20 màn hình)

| # | Màn hình | Route | Mô tả |
|---|----------|-------|-------|
| 41 | UserProfileScreen | `/profile` | Hồ sơ người dùng tổng quan |
| 42 | EditAllergiesScreen | `/profile/allergies` | Chỉnh sửa danh sách dị ứng |
| 43 | AllergyDetailScreen | `/profile/allergies/detail` | Chi tiết về 1 loại dị ứng |
| 44 | EditLifestyleScreen | `/profile/lifestyle` | Chỉnh sửa lối sống |
| 45 | LifestyleDetailScreen | `/profile/lifestyle/detail` | Chi tiết về 1 lối sống |
| 46 | PersonalizedWarningScreen | `/profile/warning` | Cảnh báo cá nhân hóa |
| 47 | AIPersonalizedScreen | `/profile/ai` | Phân tích AI theo hồ sơ |
| 48 | ProfileSetupScreen | `/profile/setup` | Thiết lập hồ sơ lần đầu |
| 49 | ProfileCompleteScreen | `/profile/complete` | Hoàn thành thiết lập hồ sơ |
| 50 | CustomAllergyScreen | `/profile/allergies/custom` | Thêm dị ứng tùy chỉnh |
| 51 | DietaryPreferenceScreen | `/profile/dietary` | Tùy chọn chế độ ăn |
| 52 | EcoPreferenceScreen | `/profile/eco` | Tùy chọn ưu tiên môi trường |
| 53 | ProfileSummaryScreen | `/profile/summary` | Tóm tắt hồ sơ |
| 54 | PersonalInsightScreen | `/profile/insight` | Insight cá nhân từ AI |
| 55 | RecommendationScreen | `/profile/recommendations` | Gợi ý cải thiện từ AI |
| 56 | ProfileEditScreen | `/profile/edit` | Chỉnh sửa thông tin hồ sơ |
| 57 | NotificationPreferenceScreen | `/profile/notifications` | Tùy chọn thông báo cá nhân |
| 58 | HealthGoalScreen | `/profile/health-goal` | Mục tiêu sức khỏe |
| 59 | EcoGoalScreen | `/profile/eco-goal` | Mục tiêu môi trường |
| 60 | ProfileAchievementScreen | `/profile/achievements` | Huy hiệu thành tích |

#### Nhóm C — Dashboard & Analytics (20 màn hình)

| # | Màn hình | Route | Mô tả |
|---|----------|-------|-------|
| 61 | ScanHistoryScreen | `/history` | Danh sách lịch sử quét |
| 62 | HistoryDetailScreen | `/history/detail` | Chi tiết 1 lần quét |
| 63 | HistorySearchScreen | `/history/search` | Tìm kiếm lịch sử |
| 64 | HistoryFilterScreen | `/history/filter` | Lọc lịch sử theo tiêu chí |
| 65 | HistoryEmptyScreen | `/history/empty` | Trạng thái lịch sử trống |
| 66 | PersonalImpactScreen | `/impact` | Tác động cá nhân tổng quan |
| 67 | WeeklyReportScreen | `/impact/weekly` | Báo cáo tuần |
| 68 | MonthlyReportScreen | `/impact/monthly` | Báo cáo tháng |
| 69 | ImpactChartScreen | `/impact/chart` | Biểu đồ tác động |
| 70 | CategoryBreakdownScreen | `/impact/category` | Phân tích theo danh mục |
| 71 | EcoTrendScreen | `/impact/trend` | Xu hướng tiêu dùng xanh |
| 72 | ScoreHistoryScreen | `/impact/scores` | Lịch sử điểm số |
| 73 | TopProductsScreen | `/impact/top` | Sản phẩm tốt nhất đã quét |
| 74 | WorstProductsScreen | `/impact/worst` | Sản phẩm kém nhất đã quét |
| 75 | ImpactEmptyScreen | `/impact/empty` | Trạng thái chưa có dữ liệu |
| 76 | AchievementListScreen | `/achievements` | Danh sách huy hiệu |
| 77 | AchievementDetailScreen | `/achievements/detail` | Chi tiết huy hiệu |
| 78 | MilestoneScreen | `/achievements/milestone` | Cột mốc đạt được |
| 79 | ShareImpactScreen | `/impact/share` | Chia sẻ tác động cá nhân |
| 80 | ExportDataScreen | `/impact/export` | Xuất dữ liệu |

#### Nhóm D — Settings & System (20 màn hình)

| # | Màn hình | Route | Mô tả |
|---|----------|-------|-------|
| 81 | SettingsScreen | `/settings` | Cài đặt chính |
| 82 | LanguageScreen | `/settings/language` | Chọn ngôn ngữ |
| 83 | NotificationScreen | `/settings/notification` | Cài đặt thông báo |
| 84 | PrivacyPolicyScreen | `/settings/privacy` | Chính sách quyền riêng tư |
| 85 | AboutScreen | `/settings/about` | Thông tin ứng dụng |
| 86 | DeleteDataScreen | `/settings/delete-data` | Xóa dữ liệu cục bộ |
| 87 | DeleteConfirmScreen | `/settings/delete-confirm` | Xác nhận xóa dữ liệu |
| 88 | APIKeyScreen | `/settings/api-key` | Nhập Gemini API key |
| 89 | ThemeScreen | `/settings/theme` | Chọn theme sáng/tối |
| 90 | FontSizeScreen | `/settings/font` | Cỡ chữ |
| 91 | DataUsageScreen | `/settings/data` | Thông tin sử dụng dữ liệu |
| 92 | OpenSourceScreen | `/settings/opensource` | Thư viện mã nguồn mở |
| 93 | FeedbackScreen | `/settings/feedback` | Gửi phản hồi |
| 94 | HelpScreen | `/settings/help` | Trợ giúp & FAQ |
| 95 | TutorialScreen | `/settings/tutorial` | Hướng dẫn sử dụng |
| 96 | PermissionsScreen | `/settings/permissions` | Quản lý quyền ứng dụng |
| 97 | CacheScreen | `/settings/cache` | Quản lý bộ nhớ cache |
| 98 | UpdateScreen | `/settings/update` | Kiểm tra cập nhật |
| 99 | TermsScreen | `/settings/terms` | Điều khoản sử dụng |
| 100 | CreditsScreen | `/settings/credits` | Credits & Acknowledgements |

---

## 4. Mô Hình Dữ Liệu

### 4.1 ProductModel

```dart
class ProductModel {
  final String barcode;
  final String name;
  final String brand;
  final String imageUrl;
  final String countries;
  final List<String> ingredients;
  final String ingredientsText;
  final NutritionModel? nutrition;
  final List<String> labels;        // "organic", "eco-friendly", etc.
  final List<String> allergens;
  final String? ecoScore;           // A-E từ Open Food Facts
  final String? nutriScore;
}
```

### 4.2 AIAnalysisModel

```dart
class AIAnalysisModel {
  final int overallScore;           // 0-100
  final EcoScoreLevel level;        // green / yellow / red
  final HealthAnalysis health;
  final EnvironmentAnalysis environment;
  final EthicsAnalysis ethics;
  final GreenwashingResult greenwashing;
  final List<IngredientAnalysis> ingredients;
  final List<String> suitableFor;
  final List<String> notSuitableFor;
  final String summary;             // Tóm tắt bằng tiếng Việt
}

class HealthAnalysis {
  final int score;
  final List<String> concerns;      // toxicity, allergens
  final List<String> positives;
}

class EnvironmentAnalysis {
  final int score;
  final List<String> concerns;      // microplastics, non-biodegradable
  final List<String> positives;
}

class EthicsAnalysis {
  final int score;
  final bool? crueltyFree;
  final bool? vegan;
  final List<String> concerns;
}

class GreenwashingResult {
  final GreenwashingLevel level;    // none / suspected / confirmed
  final List<GreenwashingClaim> claims;
}
```

### 4.3 ScanRecord

```dart
class ScanRecord {
  final String id;
  final DateTime scannedAt;
  final ProductModel product;
  final AIAnalysisModel analysis;
  final String scanMethod;          // barcode / ocr / manual
}
```

### 4.4 UserProfile

```dart
class UserProfile {
  final List<String> allergies;     // ["gluten", "lactose", "paraben", ...]
  final List<LifestyleOption> lifestyle; // vegan, vegetarian, eco-conscious, cruelty-free
  final List<String> customAllergies;
}
```

---

## 5. Tích Hợp API

### 5.1 Open Food Facts API

- Base URL: `https://world.openfoodfacts.org/api/v2`
- Endpoint: `GET /product/{barcode}.json`
- Không cần API key
- Response fields cần thiết: `product.product_name`, `product.brands`, `product.image_url`, `product.ingredients_text`, `product.nutriments`, `product.labels_tags`, `product.allergens_tags`, `product.countries_tags`

```dart
class OpenFoodFactsService {
  Future<ProductModel?> getProduct(String barcode);
  Future<List<ProductModel>> searchAlternatives(String category, String excludeBarcode);
}
```

### 5.2 Groq API (miễn phí, OpenAI-compatible)

- Model: `llama-3.3-70b-versatile` (free tier: 14,400 req/ngày, 30 RPM)
- Base URL: `https://api.groq.com/openai/v1`
- Endpoint: `POST /chat/completions`
- API key: **hardcode trong app** (constant trong `core/constants/`) — người dùng không cần nhập

**Prompt Template (OpenAI Chat Completions format):**

```json
{
  "model": "llama-3.3-70b-versatile",
  "messages": [
    {
      "role": "system",
      "content": "Bạn là chuyên gia phân tích thành phần sản phẩm. Luôn trả về JSON hợp lệ, ngắn gọn, bằng tiếng Việt."
    },
    {
      "role": "user",
      "content": "Phân tích sản phẩm:\nTên: {product_name}\nThành phần: {ingredients_text}\nNhãn: {labels}\n\nTrả về JSON:\n{\"overall_score\":<0-100>,\"health\":{\"score\":<0-100>,\"concerns\":[...],\"positives\":[...]},\"environment\":{\"score\":<0-100>,\"concerns\":[...],\"positives\":[...]},\"ethics\":{\"score\":<0-100>,\"cruelty_free\":<bool|null>,\"vegan\":<bool|null>,\"concerns\":[...]},\"greenwashing\":{\"level\":\"none|suspected|confirmed\",\"claims\":[{\"claim\":\"...\",\"reality\":\"...\"}]},\"ingredients_analysis\":[{\"name\":\"...\",\"explanation\":\"...\",\"safety\":\"safe|caution|avoid\"}],\"suitable_for\":[...],\"not_suitable_for\":[...],\"summary\":\"...\"}"
    }
  ],
  "response_format": { "type": "json_object" }
}
```

### 5.3 Google ML Kit (OCR)

- Package: `google_mlkit_text_recognition`
- Xử lý offline, không cần API key
- Hỗ trợ Latin script (đủ cho nhãn sản phẩm phổ biến)

---

## 6. Xử Lý Lỗi

| Tình huống | Xử lý |
|-----------|-------|
| Không có mạng | Hiển thị NetworkErrorScreen, nút Retry |
| Open Food Facts 404 | Hiển thị ProductNotFoundScreen, gợi ý OCR |
| Gemini API rate limit (429) | Hiển thị thông báo "Vui lòng thử lại sau 1 phút" |
| Gemini API key không hợp lệ | Hiển thị AIErrorScreen với hướng dẫn liên hệ hỗ trợ |
| Gemini trả về JSON không hợp lệ | Parse lỗi → hiển thị raw text thay vì crash |
| Camera permission denied | Hiển thị CameraPermissionScreen với hướng dẫn |
| OCR không nhận dạng được | Hiển thị OCREditScreen để chỉnh sửa thủ công |
| Hive lỗi đọc/ghi | Log lỗi, tiếp tục không lưu (graceful degradation) |

---

## 7. Lưu Trữ Cục Bộ

### 7.1 SharedPreferences
- `user_profile`: JSON string của UserProfile
- `app_language`: `"vi"` hoặc `"en"`
- `gemini_api_key`: API key người dùng nhập
- `theme_mode`: `"light"` / `"dark"` / `"system"`
- `onboarding_done`: bool
- `notification_enabled`: bool
- `font_size`: double

### 7.2 Hive
- Box `scan_history`: List<ScanRecord> (tối đa 500 bản ghi, FIFO)
- Box `cached_products`: Map<barcode, ProductModel> (cache 7 ngày)

---

## 8. Thiết Kế Giao Diện

### 8.1 Design System

- **Primary color**: `#2E7D32` (xanh lá đậm — eco theme)
- **Secondary color**: `#81C784` (xanh lá nhạt)
- **Warning color**: `#F9A825` (vàng)
- **Danger color**: `#C62828` (đỏ)
- **Background**: `#F1F8E9` (light) / `#1B2A1B` (dark)
- **Font**: Inter (Google Fonts)
- **Border radius**: 16px (cards), 12px (buttons)

### 8.2 Eco Score Visual

```
🟢 Score ≥ 70  → màu #2E7D32, label "Tốt"
🟡 Score 40-69 → màu #F9A825, label "Trung bình"  
🔴 Score < 40  → màu #C62828, label "Kém"
```

### 8.3 Navigation

- **Bottom Navigation Bar**: Home | Scan | History | Profile
- **GoRouter** cho routing có type-safety
- Deep link support cho sharing sản phẩm

---

## 9. Dependencies Chính

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  go_router: ^13.0.0
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  mobile_scanner: ^5.0.0          # Barcode scanning
  google_mlkit_text_recognition: ^0.13.0  # OCR
  http: ^1.2.0                    # API calls (OpenFood Facts + Groq)
  cached_network_image: ^3.3.1
  flutter_localizations: sdk: flutter
  intl: ^0.19.0
  fl_chart: ^0.68.0               # Charts cho Dashboard
  google_fonts: ^6.2.1
  lottie: ^3.1.0                  # Loading animations
  share_plus: ^9.0.0
  image_picker: ^1.0.7

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
  flutter_test: sdk: flutter
```
