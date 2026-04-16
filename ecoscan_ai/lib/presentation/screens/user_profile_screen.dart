import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hồ sơ của tôi'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.go('/profile/edit'),
                tooltip: 'Chỉnh sửa',
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar + name card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary.withOpacity(0.12),
                        child: Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.displayName.isNotEmpty
                                  ? profile.displayName
                                  : 'Người dùng',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.allAllergies.length} dị ứng • ${profile.lifestyle.length} lối sống',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Allergies section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeader(title: 'Dị ứng'),
                  TextButton.icon(
                    onPressed: () => context.go('/profile/allergies'),
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Chỉnh sửa'),
                  ),
                ],
              ),
              if (profile.allAllergies.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.grey[400]),
                        const SizedBox(width: 10),
                        Text('Chưa khai báo dị ứng',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.allAllergies
                          .map((a) => _AllergenChip(label: a))
                          .toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Lifestyle section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeader(title: 'Lối sống'),
                  TextButton.icon(
                    onPressed: () => context.go('/profile/lifestyle'),
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Chỉnh sửa'),
                  ),
                ],
              ),
              if (profile.lifestyle.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.grey[400]),
                        const SizedBox(width: 10),
                        Text('Chưa khai báo lối sống',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: profile.lifestyle
                          .map((l) => _LifestyleTile(option: l))
                          .toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Actions
              OutlinedButton.icon(
                onPressed: () => context.go('/profile/summary'),
                icon: const Icon(Icons.summarize_outlined),
                label: const Text('Xem tóm tắt hồ sơ'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.go('/achievements'),
                icon: const Icon(Icons.emoji_events_outlined),
                label: const Text('Huy hiệu thành tích'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AllergenChip extends StatelessWidget {
  final String label;
  const _AllergenChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.danger.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.danger, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.danger,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _LifestyleTile extends StatelessWidget {
  final LifestyleOption option;
  const _LifestyleTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(_emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Text(_label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
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
      case LifestyleOption.vegetarian: return 'Ăn chay (Vegetarian)';
      case LifestyleOption.vegan: return 'Thuần chay (Vegan)';
      case LifestyleOption.ecoConscious: return 'Eco-conscious';
      case LifestyleOption.crueltyFreeOnly: return 'Không thử nghiệm động vật';
    }
  }
}
