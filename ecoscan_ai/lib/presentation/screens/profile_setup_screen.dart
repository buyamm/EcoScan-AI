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

  final Set<String> _selectedAllergies = {};
  final Set<LifestyleOption> _selectedLifestyle = {};
  final Set<DietaryPreference> _selectedDietary = {};

  static const int _totalPages = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _totalPages - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _finish() async {
    final existing = context.read<ProfileCubit>().state.profile;
    final profile = existing.copyWith(
      allergies: _selectedAllergies.toList(),
      lifestyle: _selectedLifestyle.toList(),
      dietaryPreferences: _selectedDietary.toList(),
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
                onPressed: _back,
              )
            : null,
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Bỏ qua',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          _ProgressBar(page: _page, total: _totalPages),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              'Bước ${_page + 1} / $_totalPages',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                _AllergiesPage(
                  selected: _selectedAllergies,
                  onToggle: (a) => setState(() {
                    if (_selectedAllergies.contains(a)) {
                      _selectedAllergies.remove(a);
                    } else {
                      _selectedAllergies.add(a);
                    }
                  }),
                ),
                _LifestylePage(
                  selected: _selectedLifestyle,
                  onToggle: (l) => setState(() {
                    if (_selectedLifestyle.contains(l)) {
                      _selectedLifestyle.remove(l);
                    } else {
                      _selectedLifestyle.add(l);
                    }
                  }),
                ),
                _DietaryPage(
                  selected: _selectedDietary,
                  onToggle: (d) => setState(() {
                    if (_selectedDietary.contains(d)) {
                      _selectedDietary.remove(d);
                    } else {
                      _selectedDietary.add(d);
                    }
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + MediaQuery.of(context).viewPadding.bottom),
            child: Row(
              children: [
                if (_page > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _back,
                      child: const Text('Quay lại'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _next,
                    child: Text(
                        _page < _totalPages - 1 ? 'Tiếp theo' : 'Hoàn thành'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int page;
  final int total;
  const _ProgressBar({required this.page, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(
          total,
          (i) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: i <= page ? AppColors.primary : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step 1: Allergies ────────────────────────────────────────────────────────

class _AllergiesPage extends StatelessWidget {
  final Set<String> selected;
  final void Function(String) onToggle;

  const _AllergiesPage({required this.selected, required this.onToggle});

  static const _red = Color(0xFFC62828);

  // allergen key → (emoji, label, description)
  static const _allergens = <String, (String, String, String)>{
    'gluten': ('🌾', 'Gluten', 'Có trong lúa mì, lúa mạch, yến mạch'),
    'lactose': ('🥛', 'Lactose', 'Đường trong sữa và các sản phẩm từ sữa'),
    'nuts': ('🥜', 'Hạt (Nuts)', 'Đậu phộng, hạnh nhân, hạt điều...'),
    'paraben': ('🧴', 'Paraben', 'Chất bảo quản trong mỹ phẩm, thực phẩm'),
    'sulfate': ('⚗️', 'Sulfate', 'Chất tạo bọt trong sản phẩm làm sạch'),
    'soy': ('🫘', 'Đậu nành', 'Đậu nành và các sản phẩm từ đậu nành'),
    'eggs': ('🥚', 'Trứng', 'Trứng và các sản phẩm chứa trứng'),
    'shellfish': ('🦐', 'Hải sản có vỏ', 'Tôm, cua, sò, hàu...'),
    'pollen': ('🌸', 'Phấn hoa', 'Phấn hoa từ cây cỏ, gây dị ứng theo mùa'),
  };

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
        ...UserProfile.standardAllergens.map((key) {
          final info = _allergens[key]!;
          final isSelected = selected.contains(key);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? _red : Colors.transparent,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () => onToggle(key),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(info.$1, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.$2,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isSelected ? _red : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            info.$3,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
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
                        color: isSelected ? _red : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? _red : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        Text('Bạn có thể thêm dị ứng tùy chỉnh sau trong phần hồ sơ',
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}

// ── Step 2: Lifestyle ────────────────────────────────────────────────────────

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
                color: isSelected ? AppColors.primary : Colors.transparent,
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
      case LifestyleOption.vegetarian:
        return 'Ăn chay (Vegetarian)';
      case LifestyleOption.vegan:
        return 'Thuần chay (Vegan)';
      case LifestyleOption.ecoConscious:
        return 'Eco-conscious';
      case LifestyleOption.crueltyFreeOnly:
        return 'Không thử nghiệm động vật';
    }
  }

  String _descForLifestyle(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian:
        return 'Không ăn thịt động vật';
      case LifestyleOption.vegan:
        return 'Không dùng bất kỳ sản phẩm từ động vật';
      case LifestyleOption.ecoConscious:
        return 'Ưu tiên sản phẩm thân thiện với môi trường';
      case LifestyleOption.crueltyFreeOnly:
        return 'Chỉ dùng sản phẩm không thử nghiệm trên động vật';
    }
  }

  String _emojiForLifestyle(LifestyleOption opt) {
    switch (opt) {
      case LifestyleOption.vegetarian:
        return '🥗';
      case LifestyleOption.vegan:
        return '🌿';
      case LifestyleOption.ecoConscious:
        return '♻️';
      case LifestyleOption.crueltyFreeOnly:
        return '🐾';
    }
  }
}

// ── Step 3: Dietary Preferences ─────────────────────────────────────────────

class _DietaryPage extends StatelessWidget {
  final Set<DietaryPreference> selected;
  final void Function(DietaryPreference) onToggle;

  const _DietaryPage({required this.selected, required this.onToggle});

  static const _orange = Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('🥗', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        const Text('Chế độ ăn uống',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Chọn chế độ ăn để nhận phân tích phù hợp nhất',
            style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        const SizedBox(height: 24),
        ...DietaryPreference.values.map((pref) {
          final isSelected = selected.contains(pref);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? _orange : Colors.transparent,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () => onToggle(pref),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(_emojiForDietary(pref),
                        style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _labelForDietary(pref),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isSelected ? _orange : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _descForDietary(pref),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
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
                        color: isSelected ? _orange : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? _orange : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  String _emojiForDietary(DietaryPreference p) {
    switch (p) {
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

  String _labelForDietary(DietaryPreference p) {
    switch (p) {
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

  String _descForDietary(DietaryPreference p) {
    switch (p) {
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
