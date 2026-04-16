import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/ocr/ocr_bloc.dart';
import '../blocs/ai/ai_bloc.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';

class OCRResultScreen extends StatelessWidget {
  final String ocrText;

  const OCRResultScreen({super.key, required this.ocrText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả OCR'),
        actions: [
          TextButton(
            onPressed: () => context.go('/scan/ocr/edit', extra: ocrText),
            child: const Text(
              'Chỉnh sửa',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_snippet_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'Văn bản nhận dạng được',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      ocrText,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'AI sẽ phân tích văn bản này. Bạn có thể chỉnh sửa trước khi gửi.',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final syntheticProduct = ProductModel(
                        barcode: '',
                        name: 'Sản phẩm OCR',
                        brand: '',
                        ingredientsText: ocrText,
                      );
                      context
                          .read<AIBloc>()
                          .add(AnalyzeProduct(syntheticProduct));
                      context.go('/ai/loading');
                    },
                    icon: const Icon(Icons.psychology),
                    label: const Text('Phân tích với AI'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<OCRBloc>().add(ResetOCR());
                      context.go('/scan/ocr');
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Quét lại'),
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
