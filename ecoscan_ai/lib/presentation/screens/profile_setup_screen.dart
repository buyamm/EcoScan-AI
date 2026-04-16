import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final _nameController = TextEditingController();
  final Set<String> _selectedAllergies = {};
  final Set<LifestyleOption> _selectedLifestyle = {};

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final profile = UserProfile(
      displayName: _nameController.text.trim(),
      allergies: _selectedAllergies.toList(),
      lifestyle: _selectedLifestyle.toList(),
    );
    await context.read<ProfileCubit>().saveProfile(profile);
    if (mounted) context.go('/profile/complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết lập hồ sơ'),
        leading: _page > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
              )
            : null,
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Bỏ qua', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i <= _page ? AppColors.primary : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                _NamePage(controller: _nameController),
                _AllergiesPage(
                  selected: _selectedAllergies,
                  onToggle: (a) => setState(() => _selectedAllergies.contains(a)
                      ? _selectedAllergies.remove(a)
                      : _selectedAllergies.add(a)),
                ),
                _LifestylePage(
                  selected: _selectedLifestyle,
                  onToggle: (l) => setState(() => _selectedLifestyle.contains(l)
                      ? _selectedLifestyle.remove(l)
                      : _selectedLifestyle.add(l)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                child: Text(_page < 2 ? 'Tiếp theo' : 'Hoàn thành'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  const _NamePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👋', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          const Text('Xin chào!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Hãy cho chúng tôi biết tên của bạn',
              style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Tên hiển thị (tùy chọn)',
              hintText: 'Ví dụ: Minh',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }
}

class _AllergiesPage extends StatelessWidget {
  final Set<String> selected;
  final void Function(String) onToggle;

  const _AllergiesPage({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('⚠️', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        const Text('Dị ứng của bạn',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Chọn các chất bạn bị dị ứng để nhận cảnh báo kịp thời',
            style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: UserProfile.standardAllergens.map((a) {
            final isSelected = selected.contains(a);
            return FilterChip(
              label: Text(_labelForAllergen(a)),
              selected: isSelected,
              onSelected: (_) => onToggle(a),
              selectedColor: AppColors.danger.withOpacity(0.15),
              checkmarkColor: AppColors.danger,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.danger : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Text('Bạn có thể thêm dị ứng tùy chỉnh sau trong phần hồ sơ',
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  String _labelForAllergen(String a) {
    const map = {
      'gluten': 'Gluten',
      'lactose': 'Lactose',
      'nuts': 'Hạt (Nuts)',
      'paraben': 'Paraben',
      'sulfate': 'Sulfate',
      'soy': 'Đậu nành',
      'eggs': 'Trứng',
      'shellfish': 'Hải sản có vỏ',
      'pollen': 'Phấn hoa',
    };
    return map[a] ?? a;
  }
}

class _LifestylePage extends StatelessWidget {
  final Set<LifestyleOption> selected;
  final void Function(LifestyleOption) onToggle;

  const _LifestylePage({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('🌱', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        const Text('Lối sống của bạn',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Chọn lối sống phù hợp để nhận phân tích cá nhân hóa',
            style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        const SizedBox(height: 24),
        ...LifestyleOption.values.map((opt) {
          final isSelected = selected.contains(opt);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: CheckboxListTile(
              value: isSelected,
              onChanged: (_) => onToggle(opt),
              title: Text(_labelForLifestyle(opt),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_descForLifestyle(opt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              secondary: Text(_emojiForLifestyle(opt),
                  style: const TextStyle(fontSize: 24)),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }),
      ],
    );
  }

  String _labelForLifestyle(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return 'Ăn chay (Vegetarian)';
      case LifestyleOption.vegan: return 'Thuần chay (Vegan)';
      case LifestyleOption.ecoConscious: return 'Eco-conscious';
      case LifestyleOption.crueltyFreeOnly: return 'Không thử nghiệm động vật';
    }
  }

  String _descForLifestyle(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return 'Không ăn thịt động vật';
      case LifestyleOption.vegan: return 'Không dùng bất kỳ sản phẩm từ động vật';
      case LifestyleOption.ecoConscious: return 'Ưu tiên sản phẩm thân thiện với môi trường';
      case LifestyleOption.crueltyFreeOnly: return 'Chỉ dùng sản phẩm không thử nghiệm trên động vật';
    }
  }

  String _emojiForLifestyle(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian: return '🥗';
      case LifestyleOption.vegan: return '🌿';
      case LifestyleOption.ecoConscious: return '♻️';
      case LifestyleOption.crueltyFreeOnly: return '🐾';
    }
  }
}
