import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _steps = [
    _TutorialStep(
      emoji: '📱',
      title: 'Quét mã vạch',
      description:
          'Mở EcoScan AI và nhấn nút Quét ở thanh điều hướng. Hướng camera vào mã vạch sản phẩm. Ứng dụng sẽ tự động nhận dạng và tra cứu thông tin.',
      tip: 'Đảm bảo mã vạch nằm trong khung ngắm và được chiếu sáng tốt.',
    ),
    _TutorialStep(
      emoji: '🔍',
      title: 'Quét nhãn bằng OCR',
      description:
          'Nếu sản phẩm không có mã vạch, chọn chế độ OCR. Hướng camera vào phần "Thành phần" trên nhãn sản phẩm. ML Kit sẽ nhận dạng văn bản tự động.',
      tip: 'Giữ camera cách nhãn 15-25cm. Bạn có thể chỉnh sửa text trước khi phân tích.',
    ),
    _TutorialStep(
      emoji: '🤖',
      title: 'AI phân tích thành phần',
      description:
          'Sau khi có dữ liệu sản phẩm, AI sẽ phân tích từng thành phần theo 3 chiều: Sức khỏe, Môi trường và Đạo đức. Kết quả hiển thị dưới dạng Eco Score.',
      tip: 'Phân tích thường mất 3-8 giây. Cần kết nối mạng để AI hoạt động.',
    ),
    _TutorialStep(
      emoji: '🟢',
      title: 'Hiểu Eco Score',
      description:
          '🟢 Tốt (≥70 điểm): Sản phẩm an toàn và thân thiện môi trường.\n🟡 Trung bình (40-69): Cần cân nhắc.\n🔴 Kém (<40): Nên tìm sản phẩm thay thế.',
      tip: 'Nhấn vào Eco Score để xem chi tiết từng thành phần.',
    ),
    _TutorialStep(
      emoji: '👤',
      title: 'Cá nhân hóa cảnh báo',
      description:
          'Vào Hồ sơ để thêm dị ứng (gluten, lactose, nuts...) và lối sống (vegan, eco-conscious). Ứng dụng sẽ tự động cảnh báo khi phát hiện thành phần không phù hợp.',
      tip: 'Dữ liệu hồ sơ chỉ lưu cục bộ, không gửi lên server.',
    ),
    _TutorialStep(
      emoji: '📊',
      title: 'Theo dõi tác động cá nhân',
      description:
          'Tab Lịch sử lưu toàn bộ sản phẩm đã quét. Tab Hồ sơ → Tác động cá nhân hiển thị thống kê tiêu dùng của bạn theo tuần và tháng.',
      tip: 'Bạn có thể xuất dữ liệu dưới dạng CSV/JSON từ Cài đặt → Xuất dữ liệu.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn sử dụng'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Bỏ qua',
                style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _steps.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) =>
                  _StepPage(step: _steps[index]),
            ),
          ),

          // Dots indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_steps.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + MediaQuery.of(context).viewPadding.bottom),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('Trước'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _steps.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.pop();
                      }
                    },
                    child: Text(_currentPage == _steps.length - 1
                        ? 'Bắt đầu dùng'
                        : 'Tiếp theo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  final _TutorialStep step;

  const _StepPage({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(step.emoji,
                  style: const TextStyle(fontSize: 52)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            step.title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            step.description,
            style: TextStyle(
                fontSize: 14, height: 1.7, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    step.tip,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialStep {
  final String emoji;
  final String title;
  final String description;
  final String tip;

  const _TutorialStep({
    required this.emoji,
    required this.title,
    required this.description,
    required this.tip,
  });
}
