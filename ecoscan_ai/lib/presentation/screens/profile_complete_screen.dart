import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../core/theme/app_theme.dart';

class ProfileCompleteScreen extends StatelessWidget {
  const ProfileCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🎉', style: TextStyle(fontSize: 56)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Hồ sơ đã được thiết lập!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.displayName.isNotEmpty
                        ? 'Xin chào ${profile.displayName}! EcoScan AI sẽ cá nhân hóa trải nghiệm cho bạn.'
                        : 'EcoScan AI sẽ cá nhân hóa phân tích dựa trên hồ sơ của bạn.',
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey[600], height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Summary chips
                  if (profile.allAllergies.isNotEmpty) ...[
                    _SummaryRow(
                      icon: Icons.warning_amber_outlined,
                      color: AppColors.danger,
                      label:
                          '${profile.allAllergies.length} dị ứng đã khai báo',
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (profile.lifestyle.isNotEmpty) ...[
                    _SummaryRow(
                      icon: Icons.eco_outlined,
                      color: AppColors.primary,
                      label:
                          '${profile.lifestyle.length} lối sống đã chọn',
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Bắt đầu quét sản phẩm'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/profile'),
                      child: const Text('Xem hồ sơ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _SummaryRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(
                  fontSize: 14, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
