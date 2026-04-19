import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/ai/ai_bloc.dart';
import '../../core/theme/app_theme.dart';

class OCREditScreen extends StatefulWidget {
  final String initialText;

  const OCREditScreen({super.key, required this.initialText});

  @override
  State<OCREditScreen> createState() => _OCREditScreenState();
}

class _OCREditScreenState extends State<OCREditScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyze() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung thành phần trước khi phân tích.'),
        ),
      );
      return;
    }
    if (text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Văn bản quá ngắn. Hãy nhập đầy đủ danh sách thành phần để AI phân tích chính xác.',
          ),
        ),
      );
      return;
    }
    context.read<AIBloc>().add(AnalyzeOCRText(text));
    context.push('/ai/loading');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa văn bản OCR'),
        actions: [
          TextButton(
            onPressed: _analyze,
            child: const Text(
              'Phân tích',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewPadding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chỉnh sửa danh sách thành phần',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy sửa lỗi OCR nếu có, đảm bảo danh sách thành phần chính xác trước khi gửi AI phân tích.',
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[600], height: 1.4),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Nhập hoặc chỉnh sửa danh sách thành phần...',
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _analyze,
                icon: const Icon(Icons.psychology),
                label: const Text('Xác nhận và phân tích'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
