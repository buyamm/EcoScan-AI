part of 'ai_bloc.dart';

abstract class AIState {}

class AIInitial extends AIState {}

class AILoading extends AIState {}

class AISuccess extends AIState {
  final AIAnalysisModel analysis;

  /// The product associated with this analysis (null for OCR-only flows).
  final ProductModel? product;

  /// The saved scan record id (set after auto-save).
  final String? scanRecordId;

  /// Milestones newly unlocked by this scan.
  final List<AchievementMilestone> newAchievements;

  AISuccess(
    this.analysis, {
    this.product,
    this.scanRecordId,
    this.newAchievements = const [],
  });
}

class AIError extends AIState {
  final String message;
  final AIErrorType type;

  AIError({required this.message, required this.type});
}

enum AIErrorType {
  rateLimit,
  apiError,
  networkError,
  unknown,
}
