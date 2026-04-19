import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';

class EditAllergiesScreen extends StatelessWidget {
  const EditAllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          appBar: AppBar(title: const Text('Chỉnh sửa dị ứng')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.danger, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Chọn các chất bạn bị dị ứng. EcoScan AI sẽ cảnh báo khi phát hiện trong sản phẩm.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[700], height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Dị ứng tiêu chuẩn',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...UserProfile.standardAllergens.map((allergen) {
                final isSelected = profile.allergies.contains(allergen);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.danger
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(_emojiFor(allergen),
                        style: const TextStyle(fontSize: 22)),
                    title: Text(_labelFor(allergen),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(_descFor(allergen),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (_) =>
                          context.read<ProfileCubit>().toggleAllergen(allergen),
                      activeColor: AppColors.danger,
                    ),
                    onTap: () =>
                        context.push('/profile/allergies/detail', extra: allergen),
                  ),
                );
              }),
              const SizedBox(height: 20),
              // Custom allergens section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dị ứng tùy chỉnh',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  TextButton.icon(
                    onPressed: () => context.push('/profile/allergies/custom'),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Thêm'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (profile.customAllergies.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Chưa có dị ứng tùy chỉnh',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                )
              else
                ...profile.customAllergies.map((custom) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_outlined,
                            color: AppColors.danger),
                        title: Text(custom),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.danger),
                          onPressed: () => context
                              .read<ProfileCubit>()
                              .removeCustomAllergen(custom),
                        ),
                      ),
                    )),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        );
      },
    );
  }

  String _emojiFor(String a) {
    const map = {
      'gluten': '🌾',
      'lactose': '🥛',
      'nuts': '🥜',
      'paraben': '🧴',
      'sulfate': '⚗️',
      'soy': '🫘',
      'eggs': '🥚',
      'shellfish': '🦐',
      'pollen': '🌸',
    };
    return map[a] ?? '⚠️';
  }

  String _labelFor(String a) {
    const map = {
      'gluten': 'Gluten',
      'lactose': 'Lactose',
      'nuts': 'Hạt (Nuts)',
      'paraben': 'Paraben',
      'sulfate': 'Sulfate',
      'soy': 'Đậu nành (Soy)',
      'eggs': 'Trứng (Eggs)',
      'shellfish': 'Hải sản có vỏ',
      'pollen': 'Phấn hoa (Pollen)',
    };
    return map[a] ?? a;
  }

  String _descFor(String a) {
    const map = {
      'gluten': 'Có trong lúa mì, lúa mạch',
      'lactose': 'Có trong sữa và các sản phẩm sữa',
      'nuts': 'Đậu phộng, hạnh nhân, óc chó,...',
      'paraben': 'Chất bảo quản trong mỹ phẩm',
      'sulfate': 'Có trong dầu gội, xà phòng',
      'soy': 'Đậu nành và các sản phẩm đậu nành',
      'eggs': 'Trứng và các sản phẩm từ trứng',
      'shellfish': 'Tôm, cua, sò, hàu,...',
      'pollen': 'Phấn hoa từ cây, cỏ',
    };
    return map[a] ?? '';
  }
}
