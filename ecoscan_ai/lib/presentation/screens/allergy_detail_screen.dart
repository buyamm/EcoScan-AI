import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class AllergyDetailScreen extends StatelessWidget {
  final String allergen;

  const AllergyDetailScreen({super.key, required this.allergen});

  @override
  Widget build(BuildContext context) {
    final info = _allergenInfo[allergen] ??
        _AllergenInfo(
          name: allergen,
          emoji: '⚠️',
          description: 'Chất gây dị ứng cần tránh trong sản phẩm.',
          commonSources: [],
          symptoms: [],
          avoidTips: [],
        );

    return Scaffold(
      appBar: AppBar(title: Text(info.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(info.emoji, style: const TextStyle(fontSize: 52)),
                  const SizedBox(height: 12),
                  Text(
                    info.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info.description,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey[600], height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Common sources
          if (info.commonSources.isNotEmpty) ...[
            const SectionHeader(title: 'Nguồn phổ biến'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: info.commonSources
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.fiber_manual_record,
                                    size: 8, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Expanded(child: Text(s, style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Symptoms
          if (info.symptoms.isNotEmpty) ...[
            const SectionHeader(title: 'Triệu chứng dị ứng'),
            Card(
              color: AppColors.danger.withOpacity(0.04),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: info.symptoms
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.circle,
                                    size: 8, color: AppColors.danger),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Text(s,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Avoid tips
          if (info.avoidTips.isNotEmpty) ...[
            const SectionHeader(title: 'Lời khuyên'),
            Card(
              color: AppColors.primary.withOpacity(0.04),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: info.avoidTips
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 16, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Text(s,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}

class _AllergenInfo {
  final String name;
  final String emoji;
  final String description;
  final List<String> commonSources;
  final List<String> symptoms;
  final List<String> avoidTips;

  const _AllergenInfo({
    required this.name,
    required this.emoji,
    required this.description,
    required this.commonSources,
    required this.symptoms,
    required this.avoidTips,
  });
}

const _allergenInfo = <String, _AllergenInfo>{
  'gluten': _AllergenInfo(
    name: 'Gluten',
    emoji: '🌾',
    description: 'Protein tìm thấy trong lúa mì, lúa mạch và lúa mạch đen. Gây bệnh celiac ở người nhạy cảm.',
    commonSources: ['Bánh mì', 'Mì ống', 'Ngũ cốc', 'Bia', 'Nước sốt'],
    symptoms: ['Đau bụng', 'Tiêu chảy', 'Đầy hơi', 'Mệt mỏi', 'Đau đầu'],
    avoidTips: ['Tìm nhãn "Gluten-free"', 'Kiểm tra nguyên liệu bánh mì', 'Hỏi kỹ tại nhà hàng'],
  ),
  'lactose': _AllergenInfo(
    name: 'Lactose',
    emoji: '🥛',
    description: 'Đường tự nhiên trong sữa. Người không dung nạp lactose thiếu enzyme lactase để tiêu hóa.',
    commonSources: ['Sữa', 'Phô mai', 'Kem', 'Bơ', 'Sữa chua'],
    symptoms: ['Đau bụng', 'Buồn nôn', 'Đầy hơi', 'Tiêu chảy'],
    avoidTips: ['Chọn sản phẩm "Lactose-free"', 'Dùng sữa thực vật thay thế', 'Đọc kỹ thành phần'],
  ),
  'nuts': _AllergenInfo(
    name: 'Hạt (Nuts)',
    emoji: '🥜',
    description: 'Dị ứng hạt là một trong những dị ứng thực phẩm phổ biến và nguy hiểm nhất.',
    commonSources: ['Đậu phộng', 'Hạnh nhân', 'Óc chó', 'Hạt điều', 'Dầu hạt'],
    symptoms: ['Mề đay', 'Sưng phù', 'Khó thở', 'Sốc phản vệ (nghiêm trọng)'],
    avoidTips: ['Tránh tất cả sản phẩm có thể chứa hạt', 'Mang theo EpiPen nếu dị ứng nặng', 'Cẩn thận với nhiễm chéo'],
  ),
  'soy': _AllergenInfo(
    name: 'Đậu nành (Soy)',
    emoji: '🫘',
    description: 'Đậu nành và các sản phẩm từ đậu nành có thể gây dị ứng ở một số người.',
    commonSources: ['Đậu phụ', 'Sữa đậu nành', 'Tương', 'Miso', 'Edamame'],
    symptoms: ['Mề đay', 'Ngứa', 'Đau bụng', 'Khó thở'],
    avoidTips: ['Kiểm tra nhãn "Contains soy"', 'Hỏi về nguyên liệu khi ăn ngoài'],
  ),
  'eggs': _AllergenInfo(
    name: 'Trứng',
    emoji: '🥚',
    description: 'Dị ứng trứng thường gặp ở trẻ em, nhiều trường hợp có thể hết khi lớn lên.',
    commonSources: ['Trứng tươi', 'Bánh ngọt', 'Mayonnaise', 'Mì sợi', 'Kem'],
    symptoms: ['Mề đay', 'Chàm da', 'Đau bụng', 'Phản ứng hô hấp'],
    avoidTips: ['Tìm "egg-free" hoặc "vegan"', 'Chú ý albumin, lecithin trên nhãn'],
  ),
  'shellfish': _AllergenInfo(
    name: 'Hải sản có vỏ',
    emoji: '🦐',
    description: 'Bao gồm tôm, cua, sò, hàu, mực. Dị ứng thường dai dẳng suốt đời.',
    commonSources: ['Tôm', 'Cua', 'Sò', 'Hàu', 'Nước mắm', 'Mắm tôm'],
    symptoms: ['Mề đay', 'Sưng môi', 'Đau bụng', 'Sốc phản vệ'],
    avoidTips: ['Tránh hoàn toàn', 'Cẩn thận với nước dùng hải sản', 'Kiểm tra nhãn sản phẩm'],
  ),
  'pollen': _AllergenInfo(
    name: 'Phấn hoa',
    emoji: '🌸',
    description: 'Phấn hoa trong các nguyên liệu thực vật có thể gây phản ứng chéo với dị ứng phấn hoa môi trường.',
    commonSources: ['Mật ong', 'Sản phẩm từ hoa', 'Một số loại trái cây', 'Hạt điều'],
    symptoms: ['Ngứa miệng', 'Ngứa họng', 'Hắt hơi', 'Nghẹt mũi'],
    avoidTips: ['Tránh sản phẩm thụ phấn từ hoa', 'Hỏi bác sĩ về dị ứng chéo'],
  ),
  'paraben': _AllergenInfo(
    name: 'Paraben',
    emoji: '🧴',
    description: 'Chất bảo quản tổng hợp dùng trong mỹ phẩm và một số thực phẩm chế biến.',
    commonSources: ['Kem dưỡng da', 'Dầu gội', 'Kem đánh răng', 'Một số thực phẩm chế biến sẵn'],
    symptoms: ['Kích ứng da', 'Viêm da tiếp xúc', 'Ngứa', 'Đỏ da'],
    avoidTips: ['Tìm nhãn "Paraben-free"', 'Kiểm tra methylparaben, propylparaben trên bao bì'],
  ),
  'sulfate': _AllergenInfo(
    name: 'Sulfate',
    emoji: '⚗️',
    description: 'Sulfate (SLS/SLES) là chất tạo bọt trong nhiều sản phẩm vệ sinh. Có thể kích ứng da nhạy cảm.',
    commonSources: ['Dầu gội', 'Sữa tắm', 'Kem đánh răng', 'Nước rửa chén'],
    symptoms: ['Kích ứng da', 'Khô da', 'Ngứa da đầu', 'Lở miệng'],
    avoidTips: ['Chọn sản phẩm "Sulfate-free"', 'Phù hợp cho da nhạy cảm'],
  ),
};
