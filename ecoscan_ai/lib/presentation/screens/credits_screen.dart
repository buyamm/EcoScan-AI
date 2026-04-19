import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credits')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text('💚', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text(
                  'EcoScan AI',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Made with love for the planet',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          _CreditSection(
            title: 'Nhóm phát triển',
            items: const [
              _CreditItem('EcoScan Team', 'Phát triển & Thiết kế', '👨‍💻'),
            ],
          ),
          const SizedBox(height: 16),

          _CreditSection(
            title: 'Dữ liệu & API',
            items: const [
              _CreditItem(
                  'Open Food Facts',
                  'Cơ sở dữ liệu sản phẩm toàn cầu (CC BY-SA)',
                  '🌍'),
              _CreditItem(
                  'Groq API',
                  'Phân tích AI với Llama 3.3 70B',
                  '🤖'),
              _CreditItem(
                  'Google ML Kit',
                  'Nhận dạng văn bản OCR offline',
                  '🔍'),
            ],
          ),
          const SizedBox(height: 16),

          _CreditSection(
            title: 'Mã nguồn mở',
            items: const [
              _CreditItem(
                  'Flutter & Dart', 'Framework phát triển đa nền tảng', '💙'),
              _CreditItem(
                  'flutter_bloc', 'State management', '🧩'),
              _CreditItem('go_router', 'Navigation', '🧭'),
              _CreditItem('Hive', 'Local storage', '🐝'),
              _CreditItem('fl_chart', 'Biểu đồ dashboard', '📊'),
              _CreditItem('Google Fonts (Inter)', 'Typography', '🔤'),
            ],
          ),
          const SizedBox(height: 16),

          _CreditSection(
            title: 'Cảm ơn đặc biệt',
            items: const [
              _CreditItem(
                  'Cộng đồng Open Food Facts',
                  'Hàng triệu tình nguyện viên đóng góp dữ liệu sản phẩm',
                  '🙏'),
              _CreditItem(
                  'UN SDG 12',
                  'Mục tiêu Tiêu dùng có trách nhiệm — nguồn cảm hứng',
                  '🌱'),
            ],
          ),
          const SizedBox(height: 24),

          Center(
            child: Text(
              '© 2026 EcoScan AI Team\nAll rights reserved',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}

class _CreditSection extends StatelessWidget {
  final String title;
  final List<_CreditItem> items;

  const _CreditSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: items
                  .asMap()
                  .entries
                  .map(
                    (e) => Column(
                      children: [
                        if (e.key > 0) const Divider(height: 1, indent: 52),
                        ListTile(
                          leading: Text(e.value.emoji,
                              style: const TextStyle(fontSize: 24)),
                          title: Text(e.value.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          subtitle: Text(e.value.description,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CreditItem {
  final String name;
  final String description;
  final String emoji;

  const _CreditItem(this.name, this.description, this.emoji);
}
