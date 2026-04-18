import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/achievement_service.dart';
import '../../../core/utils/eco_score_calculator.dart';
import '../../../data/models/ai_analysis_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/scan_record.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/scan_history_repository.dart';
import '../../../data/repositories/user_profile_repository.dart';
import '../../../data/services/groq_service.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final GroqService _groqService;
  final UserProfileRepository _profileRepo;
  final ScanHistoryRepository _historyRepo;

  /// Cached last event for retry support.
  AIEvent? _lastEvent;

  AIBloc({
    required GroqService groqService,
    required UserProfileRepository profileRepo,
    required ScanHistoryRepository historyRepo,
  })  : _groqService = groqService,
        _profileRepo = profileRepo,
        _historyRepo = historyRepo,
        super(AIInitial()) {
    on<AnalyzeProduct>(_onAnalyzeProduct);
    on<AnalyzeOCRText>(_onAnalyzeOCRText);
    on<RetryAnalysis>(_onRetryAnalysis);
  }

  Future<void> _onAnalyzeProduct(
      AnalyzeProduct event, Emitter<AIState> emit) async {
    _lastEvent = event;
    emit(AILoading());

    final profile = _profileRepo.getProfile();
    await _runAnalysis(
      product: event.product,
      userProfile: profile,
      emit: emit,
      scanMethod: event.scanMethod,
    );
  }

  Future<void> _onAnalyzeOCRText(
      AnalyzeOCRText event, Emitter<AIState> emit) async {
    _lastEvent = event;
    emit(AILoading());

    // Build a minimal ProductModel from OCR text for the service call
    final syntheticProduct = ProductModel(
      barcode: '',
      name: 'Sản phẩm OCR',
      brand: '',
      ingredientsText: event.text,
    );

    final profile = _profileRepo.getProfile();
    await _runAnalysis(
      product: syntheticProduct,
      userProfile: profile,
      emit: emit,
      scanMethod: 'ocr',
    );
  }

  Future<void> _onRetryAnalysis(
      RetryAnalysis event, Emitter<AIState> emit) async {
    final last = _lastEvent;
    if (last == null) return;

    if (last is AnalyzeProduct) {
      add(AnalyzeProduct(last.product));
    } else if (last is AnalyzeOCRText) {
      add(AnalyzeOCRText(last.text));
    }
  }

  // ─── Conflict detection helpers ─────────────────────────────────────────

  /// Returns allergen names (from user profile) found in the AI ingredient list.
  List<String> _detectAllergenConflicts(
      AIAnalysisModel analysis, UserProfile profile) {
    if (profile.allAllergies.isEmpty) return const [];

    final userAllergies =
        profile.allAllergies.map((a) => a.toLowerCase()).toList();

    final conflicting = <String>{};
    for (final ingredient in analysis.ingredients) {
      final name = ingredient.name.toLowerCase();
      for (final allergy in userAllergies) {
        if (name.contains(allergy) || allergy.contains(name)) {
          conflicting.add(allergy);
        }
      }
    }
    // Also check summary text for allergen mentions
    final summaryLower = analysis.summary.toLowerCase();
    for (final allergy in userAllergies) {
      if (summaryLower.contains(allergy)) {
        conflicting.add(allergy);
      }
    }
    return conflicting.toList();
  }

  /// Returns lifestyle options that conflict with the analysis result.
  List<LifestyleOption> _detectLifestyleConflicts(
      AIAnalysisModel analysis, UserProfile profile) {
    if (profile.lifestyle.isEmpty) return const [];

    final conflicts = <LifestyleOption>[];
    final notSuitableLower =
        analysis.notSuitableFor.map((s) => s.toLowerCase()).toList();

    for (final option in profile.lifestyle) {
      switch (option) {
        case LifestyleOption.vegan:
          if (analysis.ethics.vegan == false ||
              notSuitableLower.any((s) =>
                  s.contains('vegan') || s.contains('thuần chay'))) {
            conflicts.add(option);
          }
          break;
        case LifestyleOption.vegetarian:
          if (notSuitableLower.any((s) =>
              s.contains('vegetarian') || s.contains('ăn chay'))) {
            conflicts.add(option);
          }
          break;
        case LifestyleOption.crueltyFreeOnly:
          if (analysis.ethics.crueltyFree == false) {
            conflicts.add(option);
          }
          break;
        case LifestyleOption.ecoConscious:
          if (analysis.environment.score < 40) {
            conflicts.add(option);
          }
          break;
      }
    }
    return conflicts;
  }

  Future<void> _runAnalysis({
    required ProductModel product,
    required UserProfile userProfile,
    required Emitter<AIState> emit,
    String scanMethod = 'barcode',
  }) async {    try {
      final rawAnalysis = await _groqService.analyzeProduct(
        product,
        userProfile: userProfile,
      );

      // Recalculate overall score using weighted formula (health 40%, env 40%, ethics 20%)
      final analysis = EcoScoreCalculator.recalculate(rawAnalysis);

      // Auto-save scan record
      final previousTotal = _historyRepo.getAll().length;
      final record = ScanRecord(
        id: const Uuid().v4(),
        scannedAt: DateTime.now(),
        product: product,
        analysis: analysis,
        scanMethod: scanMethod,
      );
      await _historyRepo.save(record);

      // Check for newly unlocked achievements
      final allRecords = _historyRepo.getAll();
      final newAchievements = AchievementService.checkNewAchievements(
        allRecords: allRecords,
        previousTotal: previousTotal,
      );

      // Detect allergen conflicts: compare ingredient names against user allergies
      final allergenConflicts = _detectAllergenConflicts(analysis, userProfile);

      // Detect lifestyle conflicts using ethics + suitableFor/notSuitableFor
      final lifestyleConflicts = _detectLifestyleConflicts(analysis, userProfile);

      emit(AISuccess(
        analysis,
        product: product,
        scanRecordId: record.id,
        newAchievements: newAchievements,
        allergenConflicts: allergenConflicts,
        lifestyleConflicts: lifestyleConflicts,
      ));
    } on RateLimitException catch (e) {
      emit(AIError(
        message:
            'Đã đạt giới hạn yêu cầu. Vui lòng thử lại sau ${e.retryAfterSeconds} giây.',
        type: AIErrorType.rateLimit,
      ));
    } on GroqApiException catch (e) {
      emit(AIError(
        message: 'Lỗi phân tích AI: ${e.message}',
        type: AIErrorType.apiError,
      ));
    } catch (e) {
      emit(AIError(
        message: 'Lỗi không xác định: $e',
        type: AIErrorType.unknown,
      ));
    }
  }
}
