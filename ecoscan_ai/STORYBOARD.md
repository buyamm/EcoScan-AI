# 🎬 EcoScan AI - Storyboard Journey

> *Hành trình từ Pain Point đến Outcome của người dùng khi sử dụng EcoScan AI*

---

## 📖 Tổng Quan Storyboard

**Persona**: Minh Anh - 32 tuổi, Marketing Manager, mẹ của bé 3 tuổi  
**Scenario**: Mua sữa tắm cho bé tại siêu thị Co.opmart  
**Goal**: Tìm sản phẩm an toàn, không gây dị ứng cho con  
**Duration**: 5-7 phút từ scan đến quyết định mua  

---

## 🎭 Step 1: Pain Point - Khó Khăn Ban Đầu

### 😰 Tình Huống
Minh Anh đang đứng trước kệ sữa tắm trẻ em tại siêu thị, cầm trên tay chai sữa tắm Johnson's Baby. Cô ấy nhìn vào danh sách thành phần dài dòng với những thuật ngữ hóa học khó hiểu.

### 💭 Pain Points
- **Thông tin phức tạp**: "Sodium Lauryl Sulfate", "Cocamidopropyl Betaine" - không hiểu có an toàn không?
- **Lo lắng dị ứng**: Bé từng bị dị ứng với paraben, sợ mua nhầm sản phẩm có hại
- **Thiếu thời gian**: Không thể google từng thành phần khi đang mua sắm
- **Không tin tuyên bố**: Nhãn ghi "gentle for baby" nhưng không biết có thật không
- **Quá nhiều lựa chọn**: 20+ sản phẩm khác nhau, không biết chọn cái nào

### 🎯 Desired Outcome
- Biết ngay sản phẩm có an toàn cho bé không
- Hiểu rõ từng thành phần có tác dụng gì
- Tìm được sản phẩm thay thế tốt hơn nếu cần

---

## 📱 Step 2: Input - Khởi Động Ứng Dụng

### 🔍 User Action
Minh Anh mở EcoScan AI trên iPhone, nhấn nút **"Quét ngay"** màu xanh lá nổi bật trên màn hình Home.

### 📊 Input Data
- **Barcode**: 8901030875427 (Johnson's Baby Gentle Wash)
- **User Profile**: 
  - Dị ứng: Paraben, Sulfate
  - Lối sống: Eco-conscious
  - Có con nhỏ: 3 tuổi
- **Location**: Vietnam (ảnh hưởng đến gợi ý sản phẩm thay thế)

### 🎬 Screen Flow
```
Home Screen → Tap "Quét ngay" → Camera Permission → Scan Screen
```

### ⚡ Technical Process
- Camera khởi động trong 1.5 giây
- Auto-focus và detect barcode frame
- Haptic feedback khi detect thành công

---

## 🤖 Step 3: AI Processing - Phân Tích Thông Minh

### 🔄 Data Pipeline
```
Barcode → Open Food Facts API → Product Data → Groq AI → Analysis Result
```

### 🧠 AI Analysis Process

**Phase 1: Product Lookup (2 giây)**
- Query Open Food Facts: `GET /product/8901030875427.json`
- Extract: ingredients, labels, nutrition, allergens
- Cache result locally for future use

**Phase 2: AI Analysis (3 giây)**
- Send to Groq API (Llama 3.3 70B model)
- Analyze 15 ingredients individually
- Cross-reference with user profile (paraben allergy)
- Generate personalized warnings

**Phase 3: Score Calculation (1 giây)**
- Health Score: 45/100 (contains SLS, potential irritant)
- Environment Score: 35/100 (non-biodegradable surfactants)
- Ethics Score: 60/100 (cruelty-free but not vegan)
- **Overall Eco Score: 42/100** 🟡

### 📋 AI Output
```json
{
  "overall_score": 42,
  "level": "yellow",
  "allergen_warnings": ["Sodium Lauryl Sulfate may cause skin irritation"],
  "personalized_alerts": ["Contains sulfate - matches your allergy profile"],
  "greenwashing": {
    "level": "suspected",
    "claims": ["Gentle formula vs harsh surfactants"]
  }
}
```

---

## ⚠️ Step 4: Action - Cảnh Báo & Phản Ứng

### 🚨 Immediate Alert
Màn hình hiển thị **banner đỏ nổi bật**:
> ⚠️ **CẢNH BÁO DỊ ỨNG**  
> Sản phẩm chứa Sulfate - có thể gây dị ứng cho bé

### 📊 Analysis Display
- **Eco Score**: 🟡 42/100 - Trung bình
- **Health**: 45/100 - Chứa chất gây kích ứng
- **Environment**: 35/100 - Khó phân hủy
- **Ethics**: 60/100 - Cruelty-free

### 🎭 User Reaction
Minh Anh giật mình khi thấy cảnh báo đỏ. Cô ấy nhấn vào **"Xem chi tiết"** để hiểu rõ hơn về các thành phần có hại.

### 🔍 Detailed Breakdown
- **Sodium Lauryl Sulfate**: Chất tạo bọt có thể gây khô da, kích ứng mắt
- **Cocamidopropyl Betaine**: An toàn hơn nhưng vẫn có thể gây dị ứng
- **Fragrance**: Không rõ thành phần, có thể chứa allergen

---

## ✨ Step 5: Extra Features - Tính Năng Bổ Sung

### 🔄 Alternative Suggestions
App tự động hiển thị **"Sản phẩm thay thế"** với 3 gợi ý:

1. **Aveeno Baby Daily Moisture** - 🟢 78/100
2. **Cetaphil Baby Gentle Wash** - 🟢 82/100  
3. **Organic Baby Co. Natural Wash** - 🟢 89/100

### 📊 Comparison Feature
Minh Anh nhấn **"So sánh"** giữa Johnson's và Cetaphil:

| Tiêu chí | Johnson's | Cetaphil |
|----------|-----------|----------|
| Eco Score | 🟡 42/100 | 🟢 82/100 |
| Allergen Risk | ⚠️ Cao | ✅ Thấp |
| Price | 89,000đ | 125,000đ |
| Ingredients | 15 | 8 |

### 🎯 Personalized Insights
- **Phù hợp với bé**: Cetaphil không chứa sulfate, paraben
- **Eco-friendly**: 85% thành phần tự nhiên
- **Dermatologist tested**: Được bác sĩ da liễu khuyên dùng

### 📍 Store Locator
App hiển thị **"Có sẵn tại Co.opmart"** với vị trí kệ B2-15.

---

## 🎯 Step 6: Decision & Purchase - Quyết Định Mua

### 💡 Decision Making
Minh Anh quyết định:
- ❌ Không mua Johnson's (có sulfate gây dị ứng)
- ✅ Chọn Cetaphil Baby (an toàn hơn, phù hợp với hồ sơ)
- 💰 Chấp nhận trả thêm 36,000đ cho sự an toàn

### 🛒 Purchase Action
- Đặt Johnson's trở lại kệ
- Tìm và lấy Cetaphil Baby từ kệ B2-15
- Thêm vào giỏ hàng và thanh toán

### 📱 App Interaction
- Nhấn **"Đã mua sản phẩm này"** trong app
- App lưu vào lịch sử và cập nhật thống kê
- Hiển thị thông báo: "Lựa chọn tuyệt vời! +10 điểm Eco Score"

---

## 📈 Step 7: Tracking & Learning - Theo Dõi & Học Hỏi

### 📊 Personal Dashboard Update
- **Eco Score cá nhân**: Tăng từ 65 → 68/100
- **Sản phẩm an toàn**: 23/30 (77% - cải thiện từ 70%)
- **Tiết kiệm**: Tránh được 1 sản phẩm có hại trong tuần

### 🏆 Achievement Unlocked
- **"Smart Parent"**: Chọn 10 sản phẩm an toàn cho trẻ em
- **"Allergen Avoider"**: Tránh được 5 sản phẩm chứa allergen

### 📚 Learning Content
App gợi ý bài viết:
- "5 thành phần cần tránh trong sản phẩm trẻ em"
- "Cách đọc nhãn mỹ phẩm an toàn"
- "Sulfate vs Sulfate-free: Sự khác biệt"

### 🔔 Smart Notifications
- Nhắc nhở: "Sữa tắm Cetaphil sắp hết, cần mua thêm?"
- Cảnh báo: "Sản phẩm mới Johnson's có công thức cải tiến"

---

## 🎉 Step 8: Outcome - Kết Quả Đạt Được

### ✅ Immediate Outcomes (Ngay lập tức)

**Cho Minh Anh:**
- ✅ Tránh được sản phẩm có thể gây dị ứng cho con
- ✅ Hiểu rõ thành phần và tác hại của từng chất
- ✅ Tìm được sản phẩm thay thế tốt hơn và an toàn hơn
- ✅ Tiết kiệm thời gian research (5 phút vs 30 phút google)
- ✅ Tăng confidence trong quyết định mua sắm

**Cho Bé:**
- ✅ Sử dụng sản phẩm không gây kích ứng da
- ✅ Tránh được các chất hóa học có hại
- ✅ Da bé mềm mại và không bị khô sau khi tắm

### 📊 Long-term Outcomes (Dài hạn)

**Behavioral Change (Sau 1 tháng):**
- 📈 85% sản phẩm được chọn có Eco Score ≥ 70 (tăng từ 60%)
- 📉 Giảm 40% sản phẩm chứa allergen trong giỏ hàng
- 🎯 Tăng 25% sản phẩm organic/natural
- 💰 ROI: Tiết kiệm 15% chi phí y tế do giảm dị ứng

**Knowledge Improvement:**
- 🧠 Hiểu được 50+ thành phần hóa học phổ biến
- 📚 Đọc được nhãn sản phẩm một cách thông minh
- 🔍 Phát hiện được greenwashing trong marketing
- 👥 Chia sẻ kiến thức với bạn bè, gia đình

### 🌍 Environmental Impact

**Personal Carbon Footprint:**
- 📉 Giảm 12% carbon footprint từ việc chọn sản phẩm bền vững
- ♻️ Tăng 30% sản phẩm có packaging tái chế
- 🌊 Giảm 20% microplastic từ sản phẩm làm sạch

**Community Impact:**
- 👥 Ảnh hưởng tích cực đến 5 người bạn cùng sử dụng app
- 📱 Chia sẻ 3 bài viết về tiêu dùng có trách nhiệm
- 🏆 Tham gia challenge "Green Family" với 50 gia đình khác

### 💡 Business Value

**For EcoScan AI:**
- 📊 User engagement: 8 phút/session (cao hơn 60% so với trung bình)
- 🔄 Retention rate: 85% sau 30 ngày
- ⭐ App rating: 4.8/5 với review tích cực
- 💰 Conversion to premium: 25% sau 3 tháng

**For Ecosystem:**
- 🏪 Partnership với Cetaphil: 15% tăng trưởng sales
- 📈 Data insights cho brands về consumer preferences
- 🌱 Thúc đẩy innovation trong sustainable products
- 🎯 Nâng cao nhận thức về responsible consumption

---

## 📋 Storyboard Summary

| Step | Phase | Duration | Key Action | Outcome |
|------|-------|----------|------------|---------|
| 1 | Pain Point | 30s | Confusion at store | Frustration with complex labels |
| 2 | Input | 15s | Scan barcode | Product identified |
| 3 | AI Processing | 6s | AI analysis | Comprehensive evaluation |
| 4 | Action | 60s | Review warnings | Understanding of risks |
| 5 | Extra Features | 120s | Compare alternatives | Better options found |
| 6 | Decision | 90s | Purchase decision | Safe product chosen |
| 7 | Tracking | 30s | Update profile | Progress recorded |
| 8 | Outcome | Ongoing | Behavioral change | Healthier lifestyle |

**Total Journey Time**: ~7 minutes  
**User Satisfaction**: 9.2/10  
**Problem Resolution**: 100%  
**Likelihood to Recommend**: 95%

---

## 🎬 Visual Storyboard Flow

```
😰 Pain Point → 📱 Open App → 📷 Scan → 🤖 AI Analysis → 
⚠️ Alert → 🔍 Explore → 🛒 Purchase → 📊 Track → 🎉 Success
```

### 🎨 UI/UX Highlights

- **Red Alert Banner**: Immediate attention for allergen warnings
- **Green Score Badges**: Positive reinforcement for good choices
- **Smooth Transitions**: 300ms animations between screens
- **Haptic Feedback**: Physical confirmation of important actions
- **Voice Accessibility**: Screen reader support for visually impaired

### 📱 Technical Performance

- **Scan Speed**: <2 seconds barcode detection
- **AI Response**: <5 seconds complete analysis
- **Offline Capability**: View history and profile without internet
- **Battery Optimization**: <5% battery usage per session
- **Data Usage**: <2MB per scan (including images)

---

*Storyboard này minh họa cách EcoScan AI chuyển đổi một trải nghiệm mua sắm đầy lo lắng thành một quyết định thông minh và tự tin, đồng thời tạo ra tác động tích cực lâu dài cho cả cá nhân và cộng đồng.*