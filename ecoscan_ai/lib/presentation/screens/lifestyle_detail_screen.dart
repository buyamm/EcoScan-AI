import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/profile/profile_cubit.dart';
import '../widgets/widgets.dart';

class LifestyleDetailScreen extends StatelessWidget {
  final LifestyleOption option;

  const LifestyleDetailScreen({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final info = _infoFor(option);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isSelected = state.profile.lifestyle.contains(option);
        return Scaffold(
          appBar: AppBar(title: Text(info.label)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(info.emoji, style: const TextStyle(fontSize: 52)),
                      const SizedBox(height: 12),
                      Text(info.label,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Text(info.description,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.6),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: 'Lợi ích'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: info.benefits.map((b) => _BulletRow(
                      text: b,
                      color: AppColors.primary,
                      icon: Icons.check_circle_outline,
                    )).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: 'Điều cần biết'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: info.considerations.map((c) => _BulletRow(
                      text: c,
                      color: AppColors.warning,
                      icon: Icons.info_outline,
                    )).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.grey[400] : AppColors.primary,
                  ),
                  onPressed: () =>
                      context.read<ProfileCubit>().toggleLifestyle(option),
                  child: Text(isSelected
                      ? 'Bỏ chọn lối sống này'
                      : 'Áp dụng lối sống này'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _LifestyleInfo _infoFor(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian:
        return const _LifestyleInfo(
          label: 'Ăn chay (Vegetarian)',
          emoji: '🥗',
          description:
              'Người ăn chay không ăn thịt, gia cầm và hải sản, nhưng có thể dùng các sản phẩm từ động vật như sữa và trứng.',
          benefits: [
            'Giảm tác động môi trường so với chế độ ăn thịt',
            'Có liên quan đến nguy cơ bệnh tim thấp hơn',
            'Giảm lượng khí thải carbon cá nhân',
          ],
          considerations: [
            'Cần bổ sung protein từ nguồn thực vật',
            'Chú ý vitamin B12 và sắt',
            'Một số sản phẩm "chay" vẫn có gelatin',
          ],
        );
      case LifestyleOption.vegan:
        return const _LifestyleInfo(
          label: 'Thuần chay (Vegan)',
          emoji: '🌿',
          description:
              'Người thuần chay không sử dụng bất kỳ sản phẩm nào từ động vật, bao gồm thịt, sữa, trứng, mật ong và da động vật.',
          benefits: [
            'Tác động môi trường thấp nhất trong các chế độ ăn',
            'Không gây hại cho động vật',
            'Thường giàu chất xơ và vitamin từ thực vật',
          ],
          considerations: [
            'Cần bổ sung B12, D, Omega-3, Canxi',
            'Cần lập kế hoạch bữa ăn cẩn thận',
            'Một số phụ gia thực phẩm có nguồn gốc động vật',
          ],
        );
      case LifestyleOption.ecoConscious:
        return const _LifestyleInfo(
          label: 'Eco-conscious',
          emoji: '♻️',
          description:
              'Người có ý thức sinh thái ưu tiên các sản phẩm và thực hành có tác động môi trường thấp, giảm rác thải và tiêu dùng bền vững.',
          benefits: [
            'Giảm dấu chân carbon cá nhân',
            'Hỗ trợ các thương hiệu bền vững',
            'Đóng góp cho môi trường lành mạnh hơn',
          ],
          considerations: [
            'Sản phẩm eco thường đắt hơn',
            'Cần nghiên cứu để tránh "greenwashing"',
            'Không phải sản phẩm "xanh" nào cũng thực sự bền vững',
          ],
        );
      case LifestyleOption.crueltyFreeOnly:
        return const _LifestyleInfo(
          label: 'Không thử nghiệm động vật',
          emoji: '🐾',
          description:
              'Chỉ sử dụng sản phẩm không được thử nghiệm trên động vật trong bất kỳ giai đoạn nào của quá trình sản xuất.',
          benefits: [
            'Bảo vệ quyền lợi động vật',
            'Thúc đẩy các phương pháp thử nghiệm thay thế',
            'Nhiều thương hiệu cruelty-free cũng thân thiện môi trường',
          ],
          considerations: [
            'Kiểm tra chứng nhận PETA hoặc Leaping Bunny',
            'Cruelty-free không đồng nghĩa với vegan',
            'Sản phẩm bán tại Trung Quốc có thể phải thử nghiệm trên động vật',
          ],
        );
    }
  }
}

class _LifestyleInfo {
  final String label;
  final String emoji;
  final String description;
  final List<String> benefits;
  final List<String> considerations;

  const _LifestyleInfo({
    required this.label,
    required this.emoji,
    required this.description,
    required this.benefits,
    required this.considerations,
  });
}

class _BulletRow extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _BulletRow({required this.text, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }
}
