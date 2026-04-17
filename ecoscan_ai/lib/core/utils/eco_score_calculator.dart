import '../../data/models/ai_analysis_model.dart';

/// Calculates the composite Eco Score from the three sub-scores:
///   - Health       : 40%
///   - Environment  : 40%
///   - Ethics       : 20%
///
/// Returns an integer in [0, 100] and the corresponding [EcoScoreLevel].
class EcoScoreCalculator {
  EcoScoreCalculator._();

  static const double _healthWeight = 0.4;
  static const double _environmentWeight = 0.4;
  static const double _ethicsWeight = 0.2;

  /// Computes the weighted overall score from sub-scores.
  static int calculate({
    required int healthScore,
    required int environmentScore,
    required int ethicsScore,
  }) {
    final weighted = healthScore * _healthWeight +
        environmentScore * _environmentWeight +
        ethicsScore * _ethicsWeight;
    return weighted.round().clamp(0, 100);
  }

  /// Derives the [EcoScoreLevel] from a numeric score.
  static EcoScoreLevel levelFromScore(int score) {
    if (score >= AppEcoScoreThresholds.good) return EcoScoreLevel.green;
    if (score >= AppEcoScoreThresholds.average) return EcoScoreLevel.yellow;
    return EcoScoreLevel.red;
  }

  /// Recalculates and returns an updated [AIAnalysisModel] with the weighted
  /// overall_score replacing whatever the LLM returned.
  static AIAnalysisModel recalculate(AIAnalysisModel model) {
    final score = calculate(
      healthScore: model.health.score,
      environmentScore: model.environment.score,
      ethicsScore: model.ethics.score,
    );
    return AIAnalysisModel(
      overallScore: score,
      level: levelFromScore(score),
      health: model.health,
      environment: model.environment,
      ethics: model.ethics,
      greenwashing: model.greenwashing,
      ingredients: model.ingredients,
      suitableFor: model.suitableFor,
      notSuitableFor: model.notSuitableFor,
      summary: model.summary,
      rawText: model.rawText,
    );
  }
}

/// Re-export thresholds so callers don't need to import AppConstants.
class AppEcoScoreThresholds {
  AppEcoScoreThresholds._();
  static const int good = 70;
  static const int average = 40;
}
