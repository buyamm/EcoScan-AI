import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/profile/profile_cubit.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class AIPersonalizedScreen extends StatelessWidget {
  final ProductModel product;
  final AIAnalysisModel analysis;

  const AIPersonalizedScreen({
    super.key,
    required this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        final allergenMatches = _findAllergenMatches(profile, analysis);
        final lifestyleIssues = _findLifestyleIssues(profile, analysis);

        return Scaffold(
          appBar: AppBar(title: const Text('Phân tích cá nhân hóa')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Personalization info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Phân tích dựa trên hồ sơ của bạn: ${profile.allAllergies.length} dị ứng, ${profile.lifestyle.length} lối sống',
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Overall score
              const SectionHeader(title: 'Điểm phù hợp với bạn'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ScoreGauge(
                        score: _personalizedScore(analysis, allergenMatches, lifestyleIssues),
                        label: 'Phù hợp',
                        size: 80,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _personalRating(allergenMatches, lifestyleIssues),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _personalComment(
                                  allergenMatches, lifestyleIssues, profile),
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600], height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Allergen matches
              if (allergenMatches.isNotEmpty) ...[
                const SectionHeader(title: 'Dị ứng của bạn'),
                Card(
                  color: AppColors.danger.withOpacity(0.04),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: allergenMatches
                          .map((a) => _AllergenRow(allergen: a))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Lifestyle issues
              if (lifestyleIssues.isNotEmpty) ...[
                const SectionHeader(title: 'Xung đột lối sống'),
                Card(
                  color: AppColors.warning.withOpacity(0.04),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: lifestyleIssues
                          .map((l) => _LifestyleIssueRow(option: l))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Relevant ingredients
              if (allergenMatches.isNotEmpty) ...[
                const SectionHeader(title: 'Thành phần cần chú ý'),
                ...analysis.ingredients
                    .where((i) => i.safety == IngredientSafety.avoid ||
                        i.safety == IngredientSafety.caution)
                    .take(5)
                    .map((i) => IngredientCard(ingredient: i)),
                const SizedBox(height: 16),
              ],

              // AI summary
              if (analysis.summary.isNotEmpty) ...[
                const SectionHeader(title: 'Tóm tắt AI'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      analysis.summary,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Actions
              if (allergenMatches.isNotEmpty || lifestyleIssues.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/product/alternatives', extra: {
                      'product': product,
                      'analysis': analysis,
                    }),
                    child: const Text('Tìm sản phẩm thay thế'),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/product/detail', extra: {
                    'product': product,
                    'analysis': analysis,
                  }),
                  child: const Text('Xem chi tiết đầy đủ'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _findAllergenMatches(
      UserProfile profile, AIAnalysisModel analysis) {
    final userAllergies = profile.allAllergies.map((a) => a.toLowerCase());
    final ingredientNames =
        analysis.ingredients.map((i) => i.name.toLowerCase()).join(' ');
    return userAllergies
        .where((a) => ingredientNames.contains(a))
        .toList();
  }

  List<LifestyleOption> _findLifestyleIssues(
      UserProfile profile, AIAnalysisModel analysis) {
    final issues = <LifestyleOption>[];
    if (profile.lifestyle.contains(LifestyleOption.vegan) &&
        analysis.ethics.vegan == false) {
      issues.add(LifestyleOption.vegan);
    }
    if (profile.lifestyle.contains(LifestyleOption.crueltyFreeOnly) &&
        analysis.ethics.crueltyFree == false) {
      issues.add(LifestyleOption.crueltyFreeOnly);
    }
    if (profile.lifestyle.contains(LifestyleOption.ecoConscious) &&
        analysis.environment.score < 40) {
      issues.add(LifestyleOption.ecoConscious);
    }
    return issues;
  }

  int _personalizedScore(AIAnalysisModel analysis,
      List<String> allergens, List<LifestyleOption> lifestyle) {
    int score = analysis.overallScore;
    score -= allergens.length * 15;
    score -= lifestyle.length * 10;
    return score.clamp(0, 100);
  }

  String _personalRating(
      List<String> allergens, List<LifestyleOption> lifestyle) {
    if (allergens.isNotEmpty) return '🔴 Không phù hợp';
    if (lifestyle.isNotEmpty) return '🟡 Cần xem xét';
    return '🟢 Phù hợp với bạn';
  }

  String _personalComment(List<String> allergens,
      List<LifestyleOption> lifestyle, UserProfile profile) {
    if (allergens.isNotEmpty) {
      return 'Sản phẩm chứa ${allergens.join(", ")} - chất bạn đã khai báo dị ứng.';
    }
    if (lifestyle.isNotEmpty) {
      return 'Một số thành phần có thể không phù hợp với lối sống của bạn.';
    }
    return 'Dựa trên hồ sơ của bạn, sản phẩm này có vẻ phù hợp.';
  }
}

class _AllergenRow extends StatelessWidget {
  final String allergen;
  const _AllergenRow({required this.allergen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Text(allergen,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Dị ứng',
                style: TextStyle(fontSize: 11, color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _LifestyleIssueRow extends StatelessWidget {
  final LifestyleOption option;
  const _LifestyleIssueRow({required this.option});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(_emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(_label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Xung đột',
                style:
                    TextStyle(fontSize: 11, color: AppColors.warning)),
          ),
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
