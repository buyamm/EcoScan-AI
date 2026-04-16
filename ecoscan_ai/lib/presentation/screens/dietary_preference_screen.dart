import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class DietaryPreferenceScreen extends StatelessWidget {
  const DietaryPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          appBar: AppBar(title: const Text('Chế độ ăn')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🥗', style: TextStyle(fontSize: 36)),
                    SizedBox(height: 8),
                    Text(
                      'Chế độ ăn',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Cài đặt sở thích ăn uống để nhận phân tích phù hợp',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const SectionHeader(title: 'Lựa chọn chế độ ăn'),
              const SizedBox(height: 10),

              _DietaryOption(
                emoji: '🥗',
                title: 'Ăn chay (Vegetarian)',
                subtitle: 'Không thịt, cá. Vẫn dùng sữa, trứng.',
                isSelected: profile.lifestyle.contains(LifestyleOption.vegetarian),
                onTap: () => context.read<ProfileCubit>().toggleLifestyle(LifestyleOption.vegetarian),
                onDetailTap: () => context.go('/profile/lifestyle/detail', extra: LifestyleOption.vegetarian),
              ),
              _DietaryOption(
                emoji: '🌿',
                title: 'Thuần chay (Vegan)',
                subtitle: 'Không dùng bất kỳ sản phẩm từ động vật.',
                isSelected: profile.lifestyle.contains(LifestyleOption.vegan),
                onTap: () => context.read<ProfileCubit>().toggleLifestyle(LifestyleOption.vegan),
                onDetailTap: () => context.go('/profile/lifestyle/detail', extra: LifestyleOption.vegan),
              ),
              const SizedBox(height: 20),

              const SectionHeader(title: 'Dị ứng thực phẩm'),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bạn đã khai báo ${profile.allAllergies.length} dị ứng',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      if (profile.allAllergies.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: profile.allAllergies
                              .map((a) => Chip(
                                    label: Text(a,
                                        style: const TextStyle(fontSize: 12)),
                                    backgroundColor:
                                        AppColors.danger.withOpacity(0.1),
                                    side: BorderSide(
                                        color: AppColors.danger
                                            .withOpacity(0.3)),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => context.go('/profile/allergies'),
                        child: const Text('Quản lý dị ứng'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DietaryOption extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDetailTap;

  const _DietaryOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 26)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onDetailTap,
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.info_outline,
                    color: AppColors.primary, size: 18),
              ),
            ),
            Switch(
              value: isSelected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
