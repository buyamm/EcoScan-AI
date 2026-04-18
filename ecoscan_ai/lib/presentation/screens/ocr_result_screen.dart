import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/ocr/ocr_bloc.dart';
import '../blocs/ai/ai_bloc.dart';
import '../../core/theme/app_theme.dart';

class OCRResultScreen extends StatelessWidget {
  final String ocrText;

  const OCRResultScreen({super.key, required this.ocrText});

  void _analyzeNow(BuildContext context) {
    final trimmed = ocrText.trim();
    if (trimmed.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Văn bản quá ngắn. Hãy chụp lại hoặc chỉnh sửa để thêm nội dung thành phần.',
          ),
        ),
      );
      return;
    }
    context.read<AIBloc>().add(AnalyzeOCRText(trimmed));
    context.go('/ai/loading');
  }

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
                    children: const [
                      Icon(Icons.text_snippet_outlined,
                          color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Văn bản nhận dạng được',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Scrollable text container
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 120),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      ocrText.isEmpty ? '(Không nhận dạng được văn bản)' : ocrText,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: ocrText.isEmpty ? Colors.grey : null,
                      ),
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
                      children: const [
                        Icon(Icons.info_outline,
                            color: AppColors.primary, size: 18),
                        SizedBox(width: 8),
                        Expanded(
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
                    onPressed: () => _analyzeNow(context),
                    icon: const Icon(Icons.psychology),
                    label: const Text('Phân tích ngay'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.go('/scan/ocr/edit', extra: ocrText),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Chỉnh sửa văn bản'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
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
