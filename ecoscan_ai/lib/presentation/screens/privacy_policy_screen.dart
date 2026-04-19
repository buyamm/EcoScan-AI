import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chính sách quyền riêng tư')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Section(
            title: '1. Dữ liệu lưu trữ trên thiết bị',
            content: 'EcoScan AI lưu trữ toàn bộ dữ liệu người dùng CỤC BỘ trên thiết bị của bạn, bao gồm:\n\n'
                '• Lịch sử quét sản phẩm (tối đa 500 bản ghi)\n'
                '• Hồ sơ cá nhân: tên, danh sách dị ứng, lối sống\n'
                '• Kết quả phân tích AI đã lưu cache\n'
                '• Cài đặt ứng dụng: ngôn ngữ, giao diện, cỡ chữ\n\n'
                'Dữ liệu này KHÔNG được gửi lên bất kỳ server nào của chúng tôi.',
          ),
          const _Section(
            title: '2. Dữ liệu gửi đến API bên ngoài',
            content: 'Khi bạn quét sản phẩm, ứng dụng gửi dữ liệu sau đến API bên ngoài:\n\n'
                '• Mã vạch sản phẩm → Open Food Facts API (openfoodfacts.org)\n'
                '• Danh sách thành phần sản phẩm → Groq API (api.groq.com) để phân tích AI\n\n'
                'Chúng tôi KHÔNG gửi tên, email, hoặc thông tin cá nhân nào đến các API này.',
          ),
          _Section(
            title: '3. Open Food Facts API',
            content: 'Dữ liệu sản phẩm được lấy từ Open Food Facts — cơ sở dữ liệu mở, phi lợi nhuận. '
                'Mã vạch bạn quét sẽ được gửi đến server của họ để tra cứu thông tin. '
                'Xem thêm: https://world.openfoodfacts.org/privacy',
          ),
          _Section(
            title: '4. Groq API (Phân tích AI)',
            content: 'Danh sách thành phần sản phẩm được gửi đến Groq API để phân tích AI. '
                'Thông tin người dùng (tên, dị ứng) KHÔNG được đưa vào prompt gửi API. '
                'Chỉ có thành phần kỹ thuật của sản phẩm được gửi đi. '
                'Xem thêm: https://groq.com/privacy-policy',
          ),
          _Section(
            title: '5. Quyền truy cập thiết bị',
            content: 'Ứng dụng yêu cầu các quyền sau:\n\n'
                '• Camera: để quét mã vạch và OCR nhãn sản phẩm\n'
                '• Thư viện ảnh: để chọn ảnh từ thư viện khi dùng OCR\n\n'
                'Không có quyền nào khác được yêu cầu.',
          ),
          _Section(
            title: '6. Xóa dữ liệu',
            content: 'Bạn có thể xóa toàn bộ dữ liệu cục bộ bất kỳ lúc nào từ màn hình '
                'Cài đặt → Xóa toàn bộ dữ liệu. '
                'Gỡ cài đặt ứng dụng cũng sẽ xóa tất cả dữ liệu cục bộ.',
          ),
          _Section(
            title: '7. Liên hệ',
            content: 'Nếu có câu hỏi về quyền riêng tư, vui lòng liên hệ qua mục Gửi phản hồi trong Cài đặt.',
          ),
          SizedBox(height: 24),
          Text(
            'Cập nhật lần cuối: Tháng 4, 2026',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
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
