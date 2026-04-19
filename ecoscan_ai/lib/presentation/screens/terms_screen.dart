import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điều khoản sử dụng')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Section(
            title: '1. Chấp nhận điều khoản',
            content:
                'Bằng việc tải xuống và sử dụng EcoScan AI, bạn đồng ý với các điều khoản sử dụng này. Nếu không đồng ý, vui lòng gỡ cài đặt ứng dụng.',
          ),
          _Section(
            title: '2. Mục đích sử dụng',
            content:
                'EcoScan AI được thiết kế để cung cấp thông tin tham khảo về sản phẩm tiêu dùng. Thông tin phân tích từ AI chỉ mang tính chất tham khảo và không thay thế tư vấn y tế hoặc dinh dưỡng chuyên nghiệp.',
          ),
          _Section(
            title: '3. Giới hạn trách nhiệm',
            content:
                'Độ chính xác của dữ liệu sản phẩm phụ thuộc vào cơ sở dữ liệu Open Food Facts — một dự án cộng đồng mở. EcoScan AI không chịu trách nhiệm về tính chính xác của dữ liệu từ nguồn bên ngoài.\n\n'
                'Phân tích AI được tạo tự động bởi mô hình ngôn ngữ lớn và có thể chứa sai sót. Không nên đưa ra quyết định y tế dựa hoàn toàn vào kết quả phân tích này.',
          ),
          _Section(
            title: '4. Quyền sở hữu trí tuệ',
            content:
                'EcoScan AI và toàn bộ nội dung giao diện thuộc quyền sở hữu của nhóm phát triển. Bạn được phép sử dụng ứng dụng cho mục đích cá nhân, phi thương mại.',
          ),
          _Section(
            title: '5. Dịch vụ bên thứ ba',
            content:
                'Ứng dụng sử dụng các dịch vụ bên thứ ba:\n'
                '• Open Food Facts (openfoodfacts.org) — dữ liệu sản phẩm\n'
                '• Groq API (groq.com) — phân tích AI\n'
                '• Google ML Kit — nhận dạng văn bản OCR\n\n'
                'Mỗi dịch vụ có điều khoản riêng. Bằng cách sử dụng EcoScan AI, bạn cũng chấp nhận các điều khoản của các dịch vụ này.',
          ),
          _Section(
            title: '6. Thay đổi điều khoản',
            content:
                'Chúng tôi có thể cập nhật điều khoản này theo thời gian. Phiên bản mới nhất luôn có trong ứng dụng. Tiếp tục sử dụng sau khi cập nhật đồng nghĩa với việc chấp nhận điều khoản mới.',
          ),
          _Section(
            title: '7. Luật áp dụng',
            content:
                'Các điều khoản này được điều chỉnh theo pháp luật Việt Nam.',
          ),
          SizedBox(height: 8),
          Text(
            'Cập nhật lần cuối: Tháng 4, 2026',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
