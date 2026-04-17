import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    _FAQ(
      q: 'EcoScan AI hoạt động như thế nào?',
      a: 'Bạn quét mã vạch hoặc chụp ảnh nhãn sản phẩm. Ứng dụng tra cứu thông tin từ Open Food Facts và gửi danh sách thành phần đến AI (Groq) để phân tích đa chiều: sức khỏe, môi trường, đạo đức. Kết quả được hiển thị dưới dạng Eco Score 🟢🟡🔴.',
    ),
    _FAQ(
      q: 'Dữ liệu của tôi có được lưu lên server không?',
      a: 'Không. Toàn bộ dữ liệu người dùng (lịch sử quét, hồ sơ) chỉ lưu CỤC BỘ trên thiết bị. Chỉ có mã vạch và thành phần sản phẩm được gửi đến API bên ngoài.',
    ),
    _FAQ(
      q: 'Sản phẩm không tìm thấy trong cơ sở dữ liệu, phải làm gì?',
      a: 'Hãy thử chế độ OCR Scan — chụp ảnh nhãn thành phần trực tiếp. AI sẽ phân tích dựa trên text nhận được. Bạn cũng có thể đóng góp sản phẩm lên Open Food Facts.',
    ),
    _FAQ(
      q: 'Eco Score được tính như thế nào?',
      a: 'Eco Score tổng hợp từ 3 chiều: Sức khỏe (40%), Môi trường (40%), Đạo đức (20%). AI phân tích từng thành phần và cho điểm. 🟢 Tốt ≥ 70 điểm, 🟡 Trung bình 40-69 điểm, 🔴 Kém < 40 điểm.',
    ),
    _FAQ(
      q: 'OCR nhận dạng không chính xác, phải làm gì?',
      a: 'Đảm bảo ánh sáng đủ sáng, camera cách nhãn 15-25cm, giữ điện thoại ổn định. Sau khi nhận dạng, bạn có thể chỉnh sửa text trước khi gửi AI phân tích.',
    ),
    _FAQ(
      q: 'Tại sao AI đôi khi trả về lỗi?',
      a: 'Groq API có giới hạn miễn phí 30 yêu cầu/phút. Nếu bạn quét nhiều sản phẩm liên tiếp, hãy đợi 1-2 phút rồi thử lại. Lỗi mạng cũng có thể gây ra vấn đề này.',
    ),
    _FAQ(
      q: 'Làm sao để xóa một sản phẩm khỏi lịch sử?',
      a: 'Trong màn hình Lịch sử, vuốt sang trái trên sản phẩm muốn xóa để hiển thị nút xóa. Hoặc vào Cài đặt → Xóa toàn bộ dữ liệu để xóa toàn bộ lịch sử.',
    ),
    _FAQ(
      q: 'Ứng dụng có cần kết nối mạng không?',
      a: 'Cần mạng khi tra cứu sản phẩm từ Open Food Facts và khi AI phân tích. Nhưng bạn có thể xem lại lịch sử quét cũ và sản phẩm đã cache mà không cần mạng.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trợ giúp & FAQ')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm câu hỏi...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          ..._faqs.map((faq) => _FAQTile(faq: faq)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.feedback_outlined, color: AppColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Không tìm thấy câu trả lời? Gửi phản hồi cho chúng tôi qua mục Cài đặt → Gửi phản hồi.',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FAQTile extends StatelessWidget {
  final _FAQ faq;

  const _FAQTile({required this.faq});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: AppColors.primary),
        title: Text(
          faq.q,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq.a,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQ {
  final String q;
  final String a;

  const _FAQ({required this.q, required this.a});
}
