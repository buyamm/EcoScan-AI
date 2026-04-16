import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class ProfileSummaryScreen extends StatelessWidget {
  const ProfileSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          appBar: AppBar(title: const Text('Tóm tắt hồ sơ')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.displayName.isNotEmpty
                                ? profile.displayName
                                : 'Người dùng',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text('Hồ sơ cá nhân',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Allergies chips
              const SectionHeader(title: 'Dị ứng đã khai báo'),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: profile.allAllergies.isEmpty
                      ? Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: Colors.grey[400]),
                            const SizedBox(width: 8),
                            const Text('Không có dị ứng'),
                          ],
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: profile.allAllergies
                              .map((a) => _DangerChip(label: a))
                              .toList(),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Lifestyle chips
              const SectionHeader(title: 'Lối sống'),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: profile.lifestyle.isEmpty
                      ? Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey[400]),
                            const SizedBox(width: 8),
                            const Text('Chưa chọn lối sống'),
                          ],
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: profile.lifestyle
                              .map((l) => _LifestyleChip(option: l))
                              .toList(),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // How AI uses this
              Card(
                color: AppColors.primary.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_outlined,
                              color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Text('AI sử dụng hồ sơ này như thế nào?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...[
                        'Cảnh báo ngay khi phát hiện chất gây dị ứng',
                        'Highlight thành phần xung đột với lối sống',
                        'Điều chỉnh đánh giá "Phù hợp với bạn"',
                      ].map((t) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.check,
                                    size: 14, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(t,
                                        style: const TextStyle(fontSize: 13))),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/profile/setup'),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Cập nhật hồ sơ'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DangerChip extends StatelessWidget {
  final String label;
  const _DangerChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 12,
              color: AppColors.danger,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _LifestyleChip extends StatelessWidget {
  final LifestyleOption option;
  const _LifestyleChip({required this.option});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(_label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String get _emoji {
    switch (option) {
      case LifestyleOption.vegetarian: return '🥗';
      case LifestyleOption.vegan: return '🌿';
      case LifestyleOption.ecoConscious: return '♻️';
      case LifestyleOption.crueltyFreeOnly: return '🐾';
    }
  }

  String get _label {
    switch (option) {
      case LifestyleOption.vegetarian: return 'Vegetarian';
      case LifestyleOption.vegan: return 'Vegan';
      case LifestyleOption.ecoConscious: return 'Eco-conscious';
      case LifestyleOption.crueltyFreeOnly: return 'Cruelty-free';
    }
  }
}
