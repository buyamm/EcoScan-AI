import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedCategory = 'Báo lỗi';

  static const _categories = [
    'Báo lỗi',
    'Đề xuất tính năng',
    'Dữ liệu sản phẩm',
    'Khác',
  ];

  static const _email = 'feedback@ecoscan.ai';

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: _email));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã sao chép địa chỉ email'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gửi phản hồi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
                    'Ý kiến của bạn giúp chúng tôi cải thiện EcoScan AI. Cảm ơn bạn đã dành thời gian phản hồi!',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Danh mục',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((cat) {
              final selected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: FontWeight.w500),
                onSelected: (_) => setState(() => _selectedCategory = cat),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          const Text('Tiêu đề',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Tóm tắt vấn đề hoặc đề xuất',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          const Text('Chi tiết',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _bodyController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Mô tả chi tiết...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Email contact
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Liên hệ qua email',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _email,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: _copyEmail,
                        tooltip: 'Sao chép',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gửi email với tiêu đề: "[$_selectedCategory] ${_subjectController.text.isNotEmpty ? _subjectController.text : "..."}"',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _copyEmail,
              icon: const Icon(Icons.email_outlined),
              label: const Text('Sao chép địa chỉ email'),
            ),
          ),
        ],
      ),
    );
  }
}
