# Tài Liệu Yêu Cầu

## Giới Thiệu

EcoScan AI là ứng dụng Flutter cho phép người dùng quét mã vạch hoặc nhãn sản phẩm để nhận phân tích toàn diện về mức độ bền vững, an toàn sức khỏe, và đạo đức của sản phẩm. Ứng dụng sử dụng Open Food Facts API để lấy dữ liệu sản phẩm và LLM API miễn phí (Google Gemini) để phân tích thành phần bằng tiếng Việt. Không có backend riêng — toàn bộ logic chạy trên client.

Ứng dụng hướng đến SDG 12 (Tiêu dùng có trách nhiệm), giúp người tiêu dùng Việt Nam đưa ra quyết định mua sắm thông minh và có trách nhiệm hơn.

---

## Bảng Thuật Ngữ

- **EcoScan AI**: Tên hệ thống ứng dụng Flutter được mô tả trong tài liệu này.
- **Barcode Scanner**: Chức năng quét mã vạch sản phẩm qua camera thiết bị.
- **OCR Scanner**: Chức năng nhận dạng văn bản từ nhãn sản phẩm qua camera (Google ML Kit).
- **Open Food Facts API**: API công khai cung cấp dữ liệu sản phẩm thực phẩm toàn cầu.
- **LLM API**: Groq API (miễn phí, OpenAI-compatible) với model `llama-3.3-70b-versatile`, hardcode trong app, dùng để phân tích thành phần.
- **Eco Score**: Điểm đánh giá tổng hợp mức độ bền vững của sản phẩm (🟢 Tốt / 🟡 Trung bình / 🔴 Kém).
- **Greenwashing**: Hiện tượng sản phẩm tuyên bố "xanh" hoặc "tự nhiên" nhưng thành phần thực tế không tương ứng.
- **User Profile**: Hồ sơ cá nhân người dùng lưu trữ thông tin dị ứng và lối sống.
- **Scan History**: Lịch sử các sản phẩm đã quét của người dùng, lưu cục bộ trên thiết bị.
- **Ingredient**: Thành phần nguyên liệu được liệt kê trên nhãn sản phẩm.
- **Allergen**: Chất gây dị ứng được xác định trong thành phần sản phẩm.
- **Cruelty-free**: Sản phẩm không thử nghiệm trên động vật.
- **Biodegradable**: Khả năng phân hủy sinh học của thành phần sản phẩm.

---

## Yêu Cầu

### Yêu Cầu 1 — Quét Mã Vạch

**User Story:** Là người tiêu dùng, tôi muốn quét mã vạch sản phẩm bằng camera điện thoại, để nhanh chóng tra cứu thông tin sản phẩm mà không cần nhập tay.

#### Tiêu Chí Chấp Nhận

1. WHEN người dùng mở màn hình Scan, THE EcoScan AI SHALL kích hoạt camera thiết bị và hiển thị khung ngắm mã vạch trong vòng 2 giây.
2. WHEN camera phát hiện mã vạch hợp lệ (EAN-8, EAN-13, UPC-A, UPC-E, QR Code), THE EcoScan AI SHALL đọc giá trị mã vạch và chuyển sang trạng thái tải dữ liệu.
3. IF camera không phát hiện mã vạch sau 30 giây, THEN THE EcoScan AI SHALL hiển thị thông báo gợi ý người dùng điều chỉnh góc quét hoặc chuyển sang quét OCR.
4. WHEN người dùng nhấn nút nhập mã thủ công, THE EcoScan AI SHALL hiển thị trường nhập liệu cho phép nhập chuỗi mã vạch từ 8 đến 14 ký tự số.
5. IF thiết bị không có camera hoặc quyền camera bị từ chối, THEN THE EcoScan AI SHALL hiển thị thông báo lỗi rõ ràng và hướng dẫn cấp quyền trong Cài đặt hệ thống.

---

### Yêu Cầu 2 — Quét Nhãn Bằng OCR

**User Story:** Là người tiêu dùng, tôi muốn chụp ảnh nhãn thành phần sản phẩm, để phân tích ngay cả khi sản phẩm không có mã vạch trong cơ sở dữ liệu.

#### Tiêu Chí Chấp Nhận

1. WHEN người dùng chọn chế độ OCR Scan, THE EcoScan AI SHALL kích hoạt camera và sử dụng Google ML Kit để nhận dạng văn bản từ khung hình camera theo thời gian thực.
2. WHEN Google ML Kit nhận dạng được văn bản chứa từ khóa "ingredients", "thành phần", hoặc danh sách nguyên liệu, THE EcoScan AI SHALL trích xuất danh sách thành phần và chuyển sang màn hình phân tích AI.
3. IF Google ML Kit không nhận dạng được văn bản rõ ràng, THEN THE EcoScan AI SHALL hiển thị hướng dẫn cải thiện ánh sáng và khoảng cách chụp.
4. WHEN người dùng chụp ảnh tĩnh thay vì quét trực tiếp, THE EcoScan AI SHALL xử lý ảnh từ thư viện ảnh thiết bị và trích xuất văn bản thành phần.

---

### Yêu Cầu 3 — Lấy Dữ Liệu Sản Phẩm

**User Story:** Là người tiêu dùng, tôi muốn xem thông tin đầy đủ về sản phẩm sau khi quét, để hiểu rõ nguồn gốc và thành phần trước khi mua.

#### Tiêu Chí Chấp Nhận

1. WHEN EcoScan AI nhận được mã vạch hợp lệ, THE EcoScan AI SHALL gọi Open Food Facts API với mã vạch đó và hiển thị màn hình loading trong khi chờ phản hồi.
2. WHEN Open Food Facts API trả về dữ liệu sản phẩm, THE EcoScan AI SHALL hiển thị tên sản phẩm, thương hiệu, hình ảnh, quốc gia xuất xứ, danh sách thành phần, và bảng dinh dưỡng.
3. IF Open Food Facts API không tìm thấy sản phẩm (status = 0), THEN THE EcoScan AI SHALL hiển thị màn hình "Không tìm thấy sản phẩm" với tùy chọn quét OCR hoặc đóng góp dữ liệu.
4. IF kết nối mạng thất bại trong quá trình gọi API, THEN THE EcoScan AI SHALL hiển thị thông báo lỗi mạng và nút thử lại.
5. WHILE EcoScan AI đang gọi API, THE EcoScan AI SHALL hiển thị animation loading và ngăn người dùng thực hiện thao tác quét mới.

---

### Yêu Cầu 4 — Phân Tích AI Thành Phần

**User Story:** Là người tiêu dùng, tôi muốn nhận phân tích AI về từng thành phần sản phẩm bằng tiếng Việt dễ hiểu, để biết sản phẩm có an toàn và thân thiện môi trường không.

#### Tiêu Chí Chấp Nhận

1. WHEN EcoScan AI nhận được danh sách thành phần từ API hoặc OCR, THE EcoScan AI SHALL gửi danh sách thành phần đến Groq API (model llama-3.3-70b-versatile) với prompt phân tích đa chiều bằng tiếng Việt.
2. WHEN Groq API trả về kết quả phân tích, THE EcoScan AI SHALL hiển thị giải thích từng thành phần, đánh giá sức khỏe (toxicity, allergen), đánh giá môi trường (biodegradable, microplastics), và đánh giá đạo đức (cruelty-free).
3. THE EcoScan AI SHALL tính toán và hiển thị Eco Score tổng hợp theo thang 3 mức: 🟢 Tốt (≥70 điểm), 🟡 Trung bình (40–69 điểm), 🔴 Kém (<40 điểm).
4. IF Groq API trả về lỗi hoặc timeout sau 15 giây, THEN THE EcoScan AI SHALL hiển thị thông báo lỗi và cho phép người dùng thử lại phân tích.
5. WHERE người dùng đã thiết lập User Profile, THE EcoScan AI SHALL lọc và làm nổi bật các thành phần liên quan đến dị ứng hoặc lối sống của người dùng trong kết quả phân tích.

---

### Yêu Cầu 5 — Phát Hiện Greenwashing

**User Story:** Là người tiêu dùng có ý thức môi trường, tôi muốn biết liệu tuyên bố "xanh" trên nhãn sản phẩm có thực sự đúng không, để tránh bị lừa bởi marketing gian lận.

#### Tiêu Chí Chấp Nhận

1. WHEN EcoScan AI phân tích sản phẩm có chứa tuyên bố marketing như "100% natural", "eco-friendly", "green", "organic", "tự nhiên", THE EcoScan AI SHALL so sánh tuyên bố đó với danh sách thành phần thực tế thông qua LLM.
2. WHEN LLM phát hiện mâu thuẫn giữa tuyên bố marketing và thành phần thực tế, THE EcoScan AI SHALL hiển thị cảnh báo Greenwashing với giải thích cụ thể bằng tiếng Việt.
3. THE EcoScan AI SHALL phân loại mức độ greenwashing thành 3 cấp: Không phát hiện / Nghi ngờ / Xác nhận greenwashing.
4. IF sản phẩm không có tuyên bố marketing nào, THEN THE EcoScan AI SHALL hiển thị trạng thái "Không có tuyên bố đặc biệt" trong phần Greenwashing Detector.

---

### Yêu Cầu 6 — Hồ Sơ Cá Nhân Hóa

**User Story:** Là người dùng có nhu cầu đặc biệt (dị ứng, ăn chay, v.v.), tôi muốn thiết lập hồ sơ cá nhân, để nhận cảnh báo và phân tích phù hợp với tình trạng sức khỏe và lối sống của tôi.

#### Tiêu Chí Chấp Nhận

1. THE EcoScan AI SHALL cung cấp màn hình User Profile cho phép người dùng chọn các loại dị ứng từ danh sách chuẩn (gluten, lactose, nuts, paraben, sulfate, v.v.) và lưu cục bộ trên thiết bị.
2. THE EcoScan AI SHALL cung cấp tùy chọn lối sống bao gồm: Ăn chay (Vegetarian), Thuần chay (Vegan), Eco-conscious, Không thử nghiệm động vật (Cruelty-free only).
3. WHEN người dùng đã thiết lập hồ sơ và quét sản phẩm chứa thành phần gây dị ứng đã khai báo, THE EcoScan AI SHALL hiển thị cảnh báo nổi bật màu đỏ trước khi hiển thị kết quả phân tích đầy đủ.
4. WHEN người dùng cập nhật hồ sơ cá nhân, THE EcoScan AI SHALL lưu thay đổi vào bộ nhớ cục bộ (SharedPreferences) ngay lập tức mà không cần kết nối mạng.

---

### Yêu Cầu 7 — Lịch Sử Quét và Dashboard

**User Story:** Là người dùng thường xuyên, tôi muốn xem lại lịch sử các sản phẩm đã quét và thống kê tác động cá nhân, để theo dõi thói quen tiêu dùng của mình theo thời gian.

#### Tiêu Chí Chấp Nhận

1. WHEN người dùng hoàn thành quét và phân tích một sản phẩm, THE EcoScan AI SHALL tự động lưu bản ghi vào Scan History cục bộ bao gồm: tên sản phẩm, hình ảnh, Eco Score, và thời gian quét.
2. THE EcoScan AI SHALL hiển thị màn hình Scan History với danh sách các sản phẩm đã quét, sắp xếp theo thời gian mới nhất, hỗ trợ tìm kiếm và lọc theo Eco Score.
3. THE EcoScan AI SHALL hiển thị màn hình Personal Impact với thống kê: tổng số sản phẩm đã quét, tỷ lệ sản phẩm xanh/vàng/đỏ, và xu hướng tiêu dùng theo tuần/tháng.
4. WHEN người dùng nhấn vào một mục trong Scan History, THE EcoScan AI SHALL hiển thị lại kết quả phân tích đầy đủ của sản phẩm đó từ dữ liệu đã lưu cục bộ mà không cần gọi API lại.
5. WHEN người dùng xóa một mục lịch sử, THE EcoScan AI SHALL xóa bản ghi đó khỏi bộ nhớ cục bộ và cập nhật danh sách ngay lập tức.

---

### Yêu Cầu 8 — Sản Phẩm Thay Thế

**User Story:** Là người tiêu dùng muốn cải thiện lựa chọn, tôi muốn xem gợi ý sản phẩm thay thế tốt hơn, để dễ dàng chuyển sang lựa chọn lành mạnh và bền vững hơn.

#### Tiêu Chí Chấp Nhận

1. WHEN Eco Score của sản phẩm là 🟡 hoặc 🔴, THE EcoScan AI SHALL hiển thị phần "Sản phẩm thay thế" với tối thiểu 3 gợi ý sản phẩm cùng danh mục có Eco Score cao hơn từ dữ liệu Open Food Facts.
2. WHEN người dùng nhấn vào sản phẩm thay thế được gợi ý, THE EcoScan AI SHALL hiển thị màn hình Product Detail đầy đủ của sản phẩm đó.
3. IF không tìm thấy sản phẩm thay thế phù hợp, THEN THE EcoScan AI SHALL hiển thị thông báo "Chưa tìm thấy sản phẩm thay thế" thay vì để trống phần này.

---

### Yêu Cầu 9 — Cài Đặt và Hệ Thống

**User Story:** Là người dùng, tôi muốn tùy chỉnh ngôn ngữ, thông báo và quyền riêng tư của ứng dụng, để có trải nghiệm phù hợp với nhu cầu cá nhân.

#### Tiêu Chí Chấp Nhận

1. THE EcoScan AI SHALL hỗ trợ 2 ngôn ngữ giao diện: Tiếng Việt (mặc định) và Tiếng Anh, với khả năng chuyển đổi ngay lập tức từ màn hình Cài đặt mà không cần khởi động lại ứng dụng.
2. THE EcoScan AI SHALL cung cấp tùy chọn bật/tắt thông báo nhắc nhở quét sản phẩm mới theo lịch người dùng thiết lập.
3. THE EcoScan AI SHALL hiển thị màn hình Chính sách Quyền riêng tư mô tả rõ dữ liệu nào được lưu cục bộ và dữ liệu nào được gửi đến API bên ngoài.
4. THE EcoScan AI SHALL cung cấp chức năng xóa toàn bộ dữ liệu cục bộ (lịch sử quét, hồ sơ người dùng) từ màn hình Cài đặt với xác nhận trước khi xóa.
5. THE EcoScan AI SHALL hiển thị màn hình About với thông tin phiên bản ứng dụng, thông tin nhóm phát triển, và liên kết đến mã nguồn mở.

---

### Yêu Cầu 10 — Giao Diện 100 Màn Hình

**User Story:** Là người dùng, tôi muốn có trải nghiệm giao diện đầy đủ và trực quan trên toàn bộ luồng sử dụng ứng dụng, để dễ dàng điều hướng và sử dụng mọi tính năng.

#### Tiêu Chí Chấp Nhận

1. THE EcoScan AI SHALL cung cấp đầy đủ các màn hình thuộc Nhóm A (Core Scanning): Splash, Onboarding (3 trang), Home, Scan, Scan Loading, Product Found, Product Not Found, Product Detail, Ingredient Breakdown, Score Breakdown, AI Explanation, Greenwashing Detector, Suitable Audience, Alternative Products (tổng 15 màn hình).
2. THE EcoScan AI SHALL cung cấp đầy đủ các màn hình thuộc Nhóm B (Personalization): User Profile, Edit Allergies, Edit Lifestyle, Personalized Warning, AI Personalized Analysis (tổng 5 màn hình).
3. THE EcoScan AI SHALL cung cấp đầy đủ các màn hình thuộc Nhóm C (Dashboard): Scan History, History Detail, Personal Impact, Weekly Report, Monthly Report (tổng 5 màn hình).
4. THE EcoScan AI SHALL cung cấp đầy đủ các màn hình thuộc Nhóm D (Settings): Settings, Language, Notification, Privacy Policy, About, Delete Data Confirmation (tổng 6 màn hình).
5. THE EcoScan AI SHALL cung cấp các màn hình bổ sung để đạt tổng 100 màn hình bao gồm: màn hình trạng thái lỗi, màn hình trống (empty state), màn hình chi tiết thành phần đơn lẻ, màn hình so sánh sản phẩm, màn hình huy hiệu thành tích, và các biến thể màn hình theo trạng thái dữ liệu.
