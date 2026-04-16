import 'package:hive_flutter/hive_flutter.dart';

part 'ai_analysis_model.g.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

@HiveType(typeId: 2)
enum EcoScoreLevel {
  @HiveField(0)
  green,
  @HiveField(1)
  yellow,
  @HiveField(2)
  red,
}

@HiveType(typeId: 3)
enum GreenwashingLevel {
  @HiveField(0)
  none,
  @HiveField(1)
  suspected,
  @HiveField(2)
  confirmed,
}

@HiveType(typeId: 4)
enum IngredientSafety {
  @HiveField(0)
  safe,
  @HiveField(1)
  caution,
  @HiveField(2)
  avoid,
}

// ─── Sub-models ───────────────────────────────────────────────────────────────

@HiveType(typeId: 5)
class HealthAnalysis extends HiveObject {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final List<String> concerns;

  @HiveField(2)
  final List<String> positives;

  HealthAnalysis({
    required this.score,
    this.concerns = const [],
    this.positives = const [],
  });

  factory HealthAnalysis.fromJson(Map<String, dynamic> json) => HealthAnalysis(
        score: (json['score'] as num?)?.toInt() ?? 50,
        concerns: List<String>.from(json['concerns'] ?? []),
        positives: List<String>.from(json['positives'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'concerns': concerns,
        'positives': positives,
      };
}

@HiveType(typeId: 6)
class EnvironmentAnalysis extends HiveObject {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final List<String> concerns;

  @HiveField(2)
  final List<String> positives;

  EnvironmentAnalysis({
    required this.score,
    this.concerns = const [],
    this.positives = const [],
  });

  factory EnvironmentAnalysis.fromJson(Map<String, dynamic> json) =>
      EnvironmentAnalysis(
        score: (json['score'] as num?)?.toInt() ?? 50,
        concerns: List<String>.from(json['concerns'] ?? []),
        positives: List<String>.from(json['positives'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'concerns': concerns,
        'positives': positives,
      };
}

@HiveType(typeId: 7)
class EthicsAnalysis extends HiveObject {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final bool? crueltyFree;

  @HiveField(2)
  final bool? vegan;

  @HiveField(3)
  final List<String> concerns;

  EthicsAnalysis({
    required this.score,
    this.crueltyFree,
    this.vegan,
    this.concerns = const [],
  });

  factory EthicsAnalysis.fromJson(Map<String, dynamic> json) => EthicsAnalysis(
        score: (json['score'] as num?)?.toInt() ?? 50,
        crueltyFree: json['cruelty_free'] as bool?,
        vegan: json['vegan'] as bool?,
        concerns: List<String>.from(json['concerns'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'cruelty_free': crueltyFree,
        'vegan': vegan,
        'concerns': concerns,
      };
}

@HiveType(typeId: 8)
class GreenwashingClaim extends HiveObject {
  @HiveField(0)
  final String claim;

  @HiveField(1)
  final String reality;

  GreenwashingClaim({required this.claim, required this.reality});

  factory GreenwashingClaim.fromJson(Map<String, dynamic> json) =>
      GreenwashingClaim(
        claim: json['claim']?.toString() ?? '',
        reality: json['reality']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'claim': claim, 'reality': reality};
}

@HiveType(typeId: 9)
class GreenwashingResult extends HiveObject {
  @HiveField(0)
  final GreenwashingLevel level;

  @HiveField(1)
  final List<GreenwashingClaim> claims;

  GreenwashingResult({
    required this.level,
    this.claims = const [],
  });

  factory GreenwashingResult.fromJson(Map<String, dynamic> json) {
    final levelStr = json['level']?.toString() ?? 'none';
    final level = GreenwashingLevel.values.firstWhere(
      (e) => e.name == levelStr,
      orElse: () => GreenwashingLevel.none,
    );
    return GreenwashingResult(
      level: level,
      claims: (json['claims'] as List? ?? [])
          .map((e) => GreenwashingClaim.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level.name,
        'claims': claims.map((c) => c.toJson()).toList(),
      };
}

@HiveType(typeId: 10)
class IngredientAnalysis extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String explanation;

  @HiveField(2)
  final IngredientSafety safety;

  IngredientAnalysis({
    required this.name,
    required this.explanation,
    required this.safety,
  });

  factory IngredientAnalysis.fromJson(Map<String, dynamic> json) {
    final safetyStr = json['safety']?.toString() ?? 'safe';
    final safety = IngredientSafety.values.firstWhere(
      (e) => e.name == safetyStr,
      orElse: () => IngredientSafety.safe,
    );
    return IngredientAnalysis(
      name: json['name']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      safety: safety,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'explanation': explanation,
        'safety': safety.name,
      };
}

// ─── Root model ───────────────────────────────────────────────────────────────

@HiveType(typeId: 11)
class AIAnalysisModel extends HiveObject {
  @HiveField(0)
  final int overallScore;

  @HiveField(1)
  final EcoScoreLevel level;

  @HiveField(2)
  final HealthAnalysis health;

  @HiveField(3)
  final EnvironmentAnalysis environment;

  @HiveField(4)
  final EthicsAnalysis ethics;

  @HiveField(5)
  final GreenwashingResult greenwashing;

  @HiveField(6)
  final List<IngredientAnalysis> ingredients;

  @HiveField(7)
  final List<String> suitableFor;

  @HiveField(8)
  final List<String> notSuitableFor;

  @HiveField(9)
  final String summary;

  @HiveField(10)
  final String? rawText;

  AIAnalysisModel({
    required this.overallScore,
    required this.level,
    required this.health,
    required this.environment,
    required this.ethics,
    required this.greenwashing,
    this.ingredients = const [],
    this.suitableFor = const [],
    this.notSuitableFor = const [],
    required this.summary,
    this.rawText,
  });

  static EcoScoreLevel _levelFromScore(int score) {
    if (score >= 70) return EcoScoreLevel.green;
    if (score >= 40) return EcoScoreLevel.yellow;
    return EcoScoreLevel.red;
  }

  factory AIAnalysisModel.fromJson(Map<String, dynamic> json) {
    final overallScore = (json['overall_score'] as num?)?.toInt() ?? 50;
    return AIAnalysisModel(
      overallScore: overallScore,
      level: _levelFromScore(overallScore),
      health: json['health'] != null
          ? HealthAnalysis.fromJson(json['health'] as Map<String, dynamic>)
          : HealthAnalysis(score: 50),
      environment: json['environment'] != null
          ? EnvironmentAnalysis.fromJson(
              json['environment'] as Map<String, dynamic>)
          : EnvironmentAnalysis(score: 50),
      ethics: json['ethics'] != null
          ? EthicsAnalysis.fromJson(json['ethics'] as Map<String, dynamic>)
          : EthicsAnalysis(score: 50),
      greenwashing: json['greenwashing'] != null
          ? GreenwashingResult.fromJson(
              json['greenwashing'] as Map<String, dynamic>)
          : GreenwashingResult(level: GreenwashingLevel.none),
      ingredients: (json['ingredients_analysis'] as List? ?? [])
          .map((e) => IngredientAnalysis.fromJson(e as Map<String, dynamic>))
          .toList(),
      suitableFor: List<String>.from(json['suitable_for'] ?? []),
      notSuitableFor: List<String>.from(json['not_suitable_for'] ?? []),
      summary: json['summary']?.toString() ?? '',
    );
  }

  factory AIAnalysisModel.fallback(String rawText) => AIAnalysisModel(
        overallScore: 50,
        level: EcoScoreLevel.yellow,
        health: HealthAnalysis(score: 50),
        environment: EnvironmentAnalysis(score: 50),
        ethics: EthicsAnalysis(score: 50),
        greenwashing: GreenwashingResult(level: GreenwashingLevel.none),
        summary: 'Không thể phân tích tự động.',
        rawText: rawText,
      );

  Map<String, dynamic> toJson() => {
        'overall_score': overallScore,
        'level': level.name,
        'health': health.toJson(),
        'environment': environment.toJson(),
        'ethics': ethics.toJson(),
        'greenwashing': greenwashing.toJson(),
        'ingredients_analysis': ingredients.map((i) => i.toJson()).toList(),
        'suitable_for': suitableFor,
        'not_suitable_for': notSuitableFor,
        'summary': summary,
        'raw_text': rawText,
      };
}
