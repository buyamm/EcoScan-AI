import 'package:flutter/material.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class GreenwashingDetailScreen extends StatelessWidget {
  final GreenwashingClaim claim;
  final GreenwashingLevel level;

  const GreenwashingDetailScreen({
    super.key,
    required this.claim,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final color = level == GreenwashingLevel.confirmed
        ? AppColors.danger
        : AppColors.warning;

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết tuyên bố')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Level badge
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    level == GreenwashingLevel.confirmed
                        ? Icons.gpp_bad_outlined
                        : Icons.help_outline,
                    color: color,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      level == GreenwashingLevel.confirmed
                          ? 'Greenwashing xác nhận'
                          : 'Greenwashing nghi ngờ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // The claim
          const SectionHeader(title: 'Tuyên bố marketing'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      '"${claim.claim}"',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // The reality
          const SectionHeader(title: 'Thực tế'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.fact_check_outlined,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          claim.reality,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // What to do
          const SectionHeader(title: 'Bạn nên làm gì?'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: AppColors.warning, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tip,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _tips = [
    'Đọc kỹ danh sách thành phần thay vì chỉ tin vào nhãn mác.',
    'Tìm kiếm các chứng nhận độc lập như Ecocert, COSMOS, hay Leaping Bunny.',
    'So sánh với sản phẩm thay thế có thành phần minh bạch hơn.',
  ];
}
