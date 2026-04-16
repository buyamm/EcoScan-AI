import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EcoScoreExplainScreen extends StatelessWidget {
  const EcoScoreExplainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cách tính Eco Score')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExplainCard(
            color: AppColors.primary,
            icon: Icons.eco,
            title: 'Eco Score là gì?',
            body:
                'Eco Score là điểm tổng hợp (0–100) đánh giá mức độ bền vững của sản phẩm dựa trên ba chiều: Sức khỏe, Môi trường và Đạo đức. Điểm được tính bởi AI phân tích danh sách thành phần.',
          ),
          const SizedBox(height: 12),
          _ExplainCard(
            color: AppColors.primary,
            icon: Icons.calculate_outlined,
            title: 'Công thức tính',
            body: 'Eco Score = Sức khỏe × 40% + Môi trường × 40% + Đạo đức × 20%\n\nMỗi chiều được chấm từ 0 đến 100 điểm.',
          ),
          const SizedBox(height: 12),
          _ScoreLevelCard(
            color: AppColors.primary,
            emoji: '🟢',
            label: 'Tốt (≥ 70 điểm)',
            description: 'Sản phẩm có thành phần an toàn, thân thiện với môi trường và đạt tiêu chuẩn đạo đức.',
          ),
          const SizedBox(height: 8),
          _ScoreLevelCard(
            color: AppColors.warning,
            emoji: '🟡',
            label: 'Trung bình (40–69 điểm)',
            description: 'Sản phẩm có một số điểm cần lưu ý, có thể có thành phần gây lo ngại nhẹ.',
          ),
          const SizedBox(height: 8),
          _ScoreLevelCard(
            color: AppColors.danger,
            emoji: '🔴',
            label: 'Kém (< 40 điểm)',
            description: 'Sản phẩm có nhiều thành phần đáng lo ngại về sức khỏe, môi trường hoặc đạo đức.',
          ),
          const SizedBox(height: 16),
          _ExplainCard(
            color: Colors.grey,
            icon: Icons.favorite_outline,
            title: 'Chiều Sức khỏe (40%)',
            body:
                'Đánh giá độ an toàn của các thành phần đối với sức khỏe con người, bao gồm:\n• Độc tính (toxicity)\n• Chất gây dị ứng (allergens)\n• Chất bảo quản và phụ gia\n• Thành phần có lợi',
          ),
          const SizedBox(height: 12),
          _ExplainCard(
            color: Colors.grey,
            icon: Icons.eco_outlined,
            title: 'Chiều Môi trường (40%)',
            body:
                'Đánh giá tác động của thành phần đến môi trường:\n• Khả năng phân hủy sinh học\n• Vi nhựa (microplastics)\n• Hóa chất độc hại cho hệ sinh thái\n• Nguồn nguyên liệu bền vững',
          ),
          const SizedBox(height: 12),
          _ExplainCard(
            color: Colors.grey,
            icon: Icons.balance_outlined,
            title: 'Chiều Đạo đức (20%)',
            body:
                'Đánh giá các tiêu chí đạo đức:\n• Không thử nghiệm trên động vật (cruelty-free)\n• Thành phần thuần chay (vegan)\n• Nguồn gốc có đạo đức',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lưu ý: Đây là đánh giá được thực hiện bởi AI dựa trên danh sách thành phần. Kết quả mang tính tham khảo và có thể không hoàn toàn chính xác.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
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

class _ExplainCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;

  const _ExplainCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            Text(body, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.6)),
          ],
        ),
      ),
    );
  }
}

class _ScoreLevelCard extends StatelessWidget {
  final Color color;
  final String emoji;
  final String label;
  final String description;

  const _ScoreLevelCard({
    required this.color,
    required this.emoji,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600], height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
