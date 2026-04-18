import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => context.read<ProfileCubit>().loadProfile(),
            child: CustomScrollView(
              slivers: [
                // ── Gradient SliverAppBar ──────────────────────────────
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.white),
                      onPressed: () => context.go('/profile/edit'),
                      tooltip: 'Chỉnh sửa',
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1B5E20), AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _AvatarWidget(profile: profile),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile.displayName.isNotEmpty
                                              ? profile.displayName
                                              : 'Người dùng',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (profile.email != null &&
                                            profile.email!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            profile.email!,
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.75),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            _StatBadge(
                                              count: profile.allAllergies.length,
                                              label: 'Dị ứng',
                                              icon: Icons.warning_amber_rounded,
                                            ),
                                            _StatBadge(
                                              count: profile.lifestyle.length,
                                              label: 'Lối sống',
                                              icon: Icons.eco_outlined,
                                            ),
                                            _StatBadge(
                                              count: profile
                                                  .dietaryPreferences.length,
                                              label: 'Chế độ ăn',
                                              icon: Icons
                                                  .restaurant_menu_outlined,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Body ───────────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Allergies
                      _SectionCard(
                        emoji: '⚠️',
                        title: 'Dị ứng',
                        accentColor: AppColors.danger,
                        onEdit: () => context.go('/profile/allergies'),
                        emptyLabel: 'Chưa khai báo dị ứng',
                        isEmpty: profile.allAllergies.isEmpty,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: profile.allAllergies
                              .map((a) => _TagChip(
                                    label: a,
                                    color: AppColors.danger,
                                    icon: Icons.warning_amber_rounded,
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Lifestyle
                      _SectionCard(
                        emoji: '🌱',
                        title: 'Lối sống',
                        accentColor: AppColors.primary,
                        onEdit: () => context.go('/profile/lifestyle'),
                        emptyLabel: 'Chưa khai báo lối sống',
                        isEmpty: profile.lifestyle.isEmpty,
                        child: Column(
                          children: profile.lifestyle
                              .map((l) => _LifestyleRow(option: l))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dietary
                      _SectionCard(
                        emoji: '🥗',
                        title: 'Chế độ ăn',
                        accentColor: const Color(0xFFE65100),
                        onEdit: () => context.go('/profile/dietary'),
                        emptyLabel: 'Chưa khai báo chế độ ăn',
                        isEmpty: profile.dietaryPreferences.isEmpty,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: profile.dietaryPreferences
                              .map((d) => _TagChip(
                                    label: _dietaryLabel(d),
                                    color: const Color(0xFFE65100),
                                    emoji: _dietaryEmoji(d),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick actions
                      Row(
                        children: [
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.summarize_outlined,
                              label: 'Tóm tắt\nhồ sơ',
                              color: AppColors.primary,
                              onTap: () => context.go('/profile/summary'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionCard(
                              icon: Icons.emoji_events_outlined,
                              label: 'Huy hiệu\nthành tích',
                              color: const Color(0xFFF9A825),
                              onTap: () => context.go('/achievements'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _dietaryLabel(DietaryPreference p) {
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

  String _dietaryEmoji(DietaryPreference p) {
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
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _AvatarWidget extends StatelessWidget {
  final UserProfile profile;
  const _AvatarWidget({required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 36,
        backgroundImage: NetworkImage(profile.photoUrl!),
        onBackgroundImageError: (_, __) {},
      );
    }
    return CircleAvatar(
      radius: 36,
      backgroundColor: Colors.white.withOpacity(0.2),
      child: Text(
        profile.displayName.isNotEmpty
            ? profile.displayName[0].toUpperCase()
            : '?',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  const _StatBadge(
      {required this.count, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: const TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final Color accentColor;
  final VoidCallback onEdit;
  final String emptyLabel;
  final bool isEmpty;
  final Widget child;

  const _SectionCard({
    required this.emoji,
    required this.title,
    required this.accentColor,
    required this.onEdit,
    required this.emptyLabel,
    required this.isEmpty,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined,
                      size: 14, color: accentColor),
                  label: Text('Sửa',
                      style: TextStyle(
                          fontSize: 13, color: accentColor)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isEmpty)
              Row(
                children: [
                  Icon(Icons.add_circle_outline,
                      size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 6),
                  Text(emptyLabel,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey[500])),
                ],
              )
            else
              child,
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final String? emoji;

  const _TagChip({required this.label, required this.color, this.icon, this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null)
            Text(emoji!, style: const TextStyle(fontSize: 12))
          else if (icon != null)
            Icon(icon!, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LifestyleRow extends StatelessWidget {
  final LifestyleOption option;
  const _LifestyleRow({required this.option});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(_emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Text(_label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String get _emoji {
    switch (option) {
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

  String get _label {
    switch (option) {
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
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
