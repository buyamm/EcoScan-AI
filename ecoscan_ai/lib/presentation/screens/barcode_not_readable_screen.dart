import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class BarcodeNotReadableScreen extends StatelessWidget {
  const BarcodeNotReadableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Không đọc được mã vạch')),
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
                child: const Icon(Icons.qr_code_2,
                    size: 52, color: AppColors.warning),
              ),
              const SizedBox(height: 24),
              const Text(
                'Không đọc được mã vạch',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                'Mã vạch có thể bị hỏng, nhòe hoặc che khuất.\nHãy thử các cách sau:',
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
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/scan/manual'),
                  icon: const Icon(Icons.keyboard),
                  label: const Text('Nhập mã thủ công'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/scan'),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Thử lại'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
