import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class EcoPreferenceScreen extends StatelessWidget {
  const EcoPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        final isEcoConscious =
            profile.lifestyle.contains(LifestyleOption.ecoConscious);
        final isCrueltyFree =
            profile.lifestyle.contains(LifestyleOption.crueltyFreeOnly);

        return Scaffold(
          appBar: AppBar(title: const Text('Ưu tiên môi trường')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.secondary
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🌍', style: TextStyle(fontSize: 36)),
                    SizedBox(height: 8),
                    Text(
                      'Ưu tiên môi trường',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Thiết lập ưu tiên để EcoScan AI nhấn mạnh yếu tố môi trường',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const SectionHeader(title: 'Cài đặt môi trường'),
              const SizedBox(height: 10),

              _EcoOptionCard(
                emoji: '♻️',
                title: 'Eco-conscious',
                description:
                    'Nhận cảnh báo khi sản phẩm có điểm môi trường thấp dưới 40/100. EcoScan AI sẽ ưu tiên hiển thị thông tin về phân hủy sinh học và vi nhựa.',
                isSelected: isEcoConscious,
                onToggle: () => context
                    .read<ProfileCubit>()
                    .toggleLifestyle(LifestyleOption.ecoConscious),
              ),
              const SizedBox(height: 10),
              _EcoOptionCard(
                emoji: '🐾',
                title: 'Không thử nghiệm động vật',
                description:
                    'Được cảnh báo khi sản phẩm chưa xác nhận cruelty-free. Chú trọng vào khía cạnh đạo đức trong phân tích AI.',
                isSelected: isCrueltyFree,
                onToggle: () => context
                    .read<ProfileCubit>()
                    .toggleLifestyle(LifestyleOption.crueltyFreeOnly),
              ),
              const SizedBox(height: 20),

              const SectionHeader(title: 'Ý nghĩa'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      _ImpactRow(
                          emoji: '🟢',
                          label: 'Điểm ≥70',
                          desc: 'Sản phẩm thân thiện môi trường'),
                      const Divider(height: 16),
                      _ImpactRow(
                          emoji: '🟡',
                          label: 'Điểm 40-69',
                          desc: 'Cần cải thiện'),
                      const Divider(height: 16),
                      _ImpactRow(
                          emoji: '🔴',
                          label: 'Điểm <40',
                          desc: 'Tác động môi trường cao'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => context.go('/profile/eco-goal'),
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Đặt mục tiêu môi trường'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EcoOptionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onToggle;

  const _EcoOptionCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4)),
                ],
              ),
            ),
            Switch(
              value: isSelected,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String desc;

  const _ImpactRow(
      {required this.emoji, required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
            child:
                Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
      ],
    );
  }
}
