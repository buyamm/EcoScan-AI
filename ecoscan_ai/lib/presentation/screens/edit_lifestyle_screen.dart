import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';

class EditLifestyleScreen extends StatelessWidget {
  const EditLifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          appBar: AppBar(title: const Text('Chỉnh sửa lối sống')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Lối sống của bạn sẽ được dùng để cá nhân hóa phân tích AI và cảnh báo phù hợp.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[700], height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...LifestyleOption.values.map((option) {
                final isSelected = profile.lifestyle.contains(option);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () =>
                        context.read<ProfileCubit>().toggleLifestyle(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(_emojiFor(option),
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_labelFor(option),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(_descFor(option),
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600])),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () => context.go(
                                      '/profile/lifestyle/detail',
                                      extra: option),
                                  child: Text('Tìm hiểu thêm →',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) => context
                                .read<ProfileCubit>()
                                .toggleLifestyle(option),
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _emojiFor(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return '🥗';
      case LifestyleOption.vegan: return '🌿';
      case LifestyleOption.ecoConscious: return '♻️';
      case LifestyleOption.crueltyFreeOnly: return '🐾';
    }
  }

  String _labelFor(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return 'Ăn chay (Vegetarian)';
      case LifestyleOption.vegan: return 'Thuần chay (Vegan)';
      case LifestyleOption.ecoConscious: return 'Eco-conscious';
      case LifestyleOption.crueltyFreeOnly: return 'Không thử nghiệm động vật';
    }
  }

  String _descFor(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian:
        return 'Không ăn thịt, cá. Vẫn dùng sữa và trứng.';
      case LifestyleOption.vegan:
        return 'Không dùng bất kỳ sản phẩm nào từ động vật.';
      case LifestyleOption.ecoConscious:
        return 'Ưu tiên sản phẩm thân thiện môi trường, hạn chế nhựa.';
      case LifestyleOption.crueltyFreeOnly:
        return 'Chỉ dùng sản phẩm không thử nghiệm trên động vật.';
    }
  }
}
