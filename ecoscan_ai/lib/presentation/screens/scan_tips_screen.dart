import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ScanTipsScreen extends StatelessWidget {
  const ScanTipsScreen({super.key});

  static const _tips = [
    (
      icon: Icons.wb_sunny_outlined,
      title: 'Ánh sáng đủ',
      desc:
          'Đảm bảo có đủ ánh sáng khi quét. Sử dụng đèn flash trong điều kiện tối.',
    ),
    (
      icon: Icons.straighten,
      title: 'Khoảng cách phù hợp',
      desc:
          'Giữ điện thoại cách mã vạch 10–20 cm để camera lấy nét chính xác.',
    ),
    (
      icon: Icons.crop_free,
      title: 'Căn chỉnh khung',
      desc:
          'Đặt mã vạch vào giữa khung quét, đảm bảo toàn bộ mã nằm trong khung.',
    ),
    (
      icon: Icons.do_not_touch,
      title: 'Giữ yên điện thoại',
      desc: 'Tránh rung tay khi quét để camera nhận dạng chính xác hơn.',
    ),
    (
      icon: Icons.text_fields,
      title: 'Thử OCR nếu mã vạch hỏng',
      desc:
          'Nếu mã vạch bị nhòe hoặc rách, hãy dùng chế độ quét nhãn OCR thay thế.',
    ),
    (
      icon: Icons.keyboard,
      title: 'Nhập tay khi cần',
      desc:
          'Có thể nhập trực tiếp dãy số mã vạch nếu không thể quét được.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mẹo quét sản phẩm')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _tips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final tip = _tips[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(tip.icon, color: AppColors.primary, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tip.desc,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}
