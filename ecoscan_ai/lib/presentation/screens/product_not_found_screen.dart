import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ProductNotFoundScreen extends StatelessWidget {
  final String? barcode;

  const ProductNotFoundScreen({super.key, this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy sản phẩm')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off,
                    size: 52, color: AppColors.warning),
              ),
              const SizedBox(height: 24),
              const Text(
                'Không tìm thấy sản phẩm',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              if (barcode != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Mã vạch: $barcode',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[500]),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Sản phẩm này chưa có trong cơ sở dữ liệu Open Food Facts. '
                'Hãy thử quét nhãn thành phần hoặc đóng góp sản phẩm.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/scan/ocr'),
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Thử quét nhãn OCR'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.go('/product/contribute'),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Đóng góp sản phẩm'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/scan'),
                child: const Text('Quét lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
