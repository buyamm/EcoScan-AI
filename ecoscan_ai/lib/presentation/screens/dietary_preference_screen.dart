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
        final selected = state.profile.dietaryPreferences;
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
                    colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
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
                      'Chế độ ăn uống',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Chọn chế độ ăn để nhận phân tích phù hợp với bạn',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const SectionHeader(title: 'Chọn chế độ ăn của bạn'),
              const SizedBox(height: 12),

              ...DietaryPreference.values.map((pref) {
                final isSelected = selected.contains(pref);
                return _DietaryCard(
                  pref: pref,
                  isSelected: isSelected,
                  onTap: () => context
                      .read<ProfileCubit>()
                      .toggleDietaryPreference(pref),
                );
              }),

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
                        'Bạn đã khai báo ${state.profile.allAllergies.length} dị ứng',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      if (state.profile.allAllergies.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: state.profile.allAllergies
                              .map((a) => Chip(
                                    label: Text(a,
                                        style: const TextStyle(fontSize: 12)),
                                    backgroundColor:
                                        AppColors.danger.withOpacity(0.1),
                                    side: BorderSide(
                                        color:
                                            AppColors.danger.withOpacity(0.3)),
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

class _DietaryCard extends StatelessWidget {
  final DietaryPreference pref;
  final bool isSelected;
  final VoidCallback onTap;

  const _DietaryCard({
    required this.pref,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFE65100);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? orange : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(_emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isSelected ? orange : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? orange : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? orange : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _emoji {
    switch (pref) {
      case DietaryPreference.glutenFree:
        return '🌾';
      case DietaryPreference.lactoseFree:
        return '🥛';
      case DietaryPreference.lowSugar:
        return '🍬';
      case DietaryPreference.lowSalt:
        return '🧂';
      case DietaryPreference.keto:
        return '🥑';
      case DietaryPreference.paleo:
        return '🥩';
    }
  }

  String get _label {
    switch (pref) {
      case DietaryPreference.glutenFree:
        return 'Không Gluten';
      case DietaryPreference.lactoseFree:
        return 'Không Lactose';
      case DietaryPreference.lowSugar:
        return 'Ít đường';
      case DietaryPreference.lowSalt:
        return 'Ít muối';
      case DietaryPreference.keto:
        return 'Keto';
      case DietaryPreference.paleo:
        return 'Paleo';
    }
  }

  String get _description {
    switch (pref) {
      case DietaryPreference.glutenFree:
        return 'Tránh lúa mì, lúa mạch và các sản phẩm chứa gluten';
      case DietaryPreference.lactoseFree:
        return 'Tránh sữa và các sản phẩm từ sữa chứa lactose';
      case DietaryPreference.lowSugar:
        return 'Hạn chế đường và thực phẩm có chỉ số đường huyết cao';
      case DietaryPreference.lowSalt:
        return 'Hạn chế natri và thực phẩm chế biến nhiều muối';
      case DietaryPreference.keto:
        return 'Chế độ ăn ít carb, nhiều chất béo lành mạnh';
      case DietaryPreference.paleo:
        return 'Chỉ thực phẩm tự nhiên, tránh thực phẩm chế biến';
    }
  }
}
