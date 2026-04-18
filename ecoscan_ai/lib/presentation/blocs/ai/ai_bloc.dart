import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/achievement_service.dart';
import '../../../core/utils/eco_score_calculator.dart';
import '../../../data/models/ai_analysis_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/scan_record.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/ai_analysis_cache_repository.dart';
import '../../../data/repositories/scan_history_repository.dart';
import '../../../data/repositories/user_profile_repository.dart';
import '../../../data/services/groq_service.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final GroqService _groqService;
  final UserProfileRepository _profileRepo;
  final ScanHistoryRepository _historyRepo;
  final AIAnalysisCacheRepository _analysisCache;

  /// Cached last event for retry support.
  AIEvent? _lastEvent;

  AIBloc({
    required GroqService groqService,
    required UserProfileRepository profileRepo,
    required ScanHistoryRepository historyRepo,
    required AIAnalysisCacheRepository analysisCache,
  })  : _groqService = groqService,
        _profileRepo = profileRepo,
        _historyRepo = historyRepo,
        _analysisCache = analysisCache,
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
  /// Only flags a conflict when the AI explicitly marks an ingredient as
  /// [IngredientSafety.avoid] AND its name matches a user allergy, OR when
  /// the ingredient name is a close match (whole-word) to the allergy term.
  List<String> _detectAllergenConflicts(
      AIAnalysisModel analysis, UserProfile profile) {
    if (profile.allAllergies.isEmpty) return const [];

    final userAllergies =
        profile.allAllergies.map((a) => a.toLowerCase().trim()).toList();

    final conflicting = <String>{};

    for (final ingredient in analysis.ingredients) {
      final name = ingredient.name.toLowerCase().trim();

      for (final allergy in userAllergies) {
        // Only match when the ingredient name contains the allergy term as a
        // whole word (not a substring of a longer word).
        // e.g. "lactose" matches "lactose monohydrate" but NOT "lac" or "lactic acid"
        final nameContainsAllergy = _containsWholeWord(name, allergy);
        final allergyContainsName =
            name.length >= 4 && _containsWholeWord(allergy, name);

        if (nameContainsAllergy || allergyContainsName) {
          // Only flag if AI also considers this ingredient problematic,
          // or if the ingredient name is a direct/strong match.
          if (ingredient.safety == IngredientSafety.avoid ||
              ingredient.safety == IngredientSafety.caution ||
              name == allergy ||
              name.startsWith('$allergy ') ||
              name.startsWith('${allergy}-')) {
            conflicting.add(allergy);
          }
        }
      }
    }

    return conflicting.toList();
  }

  /// Returns true if [text] contains [word] as a whole word (space/punctuation boundary).
  bool _containsWholeWord(String text, String word) {
    if (word.isEmpty) return false;
    // Use a simple boundary check: word must be preceded/followed by
    // start/end of string, space, comma, dash, or parenthesis.
    final pattern = RegExp(
      r'(^|[\s,\-\(\)])' + RegExp.escape(word) + r'($|[\s,\-\(\)])',
    );
    return pattern.hasMatch(text);
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
  }) async {
    try {
      // Use barcode as cache key; skip cache for OCR (no stable barcode)
      final cacheKey = product.barcode;
      final cached = cacheKey.isNotEmpty ? _analysisCache.get(cacheKey) : null;

      final AIAnalysisModel analysis;
      final bool fromCache;

      if (cached != null) {
        // Cache hit — skip Groq call entirely
        analysis = cached;
        fromCache = true;
      } else {
        // Cache miss — call Groq and store result
        final rawAnalysis = await _groqService.analyzeProduct(
          product,
          userProfile: userProfile,
        );
        analysis = EcoScoreCalculator.recalculate(rawAnalysis);
        if (cacheKey.isNotEmpty) {
          await _analysisCache.put(cacheKey, analysis);
        }
        fromCache = false;
      }

      // Auto-save scan record (always, even on cache hit — it's a new scan event)
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
        fromCache: fromCache,
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
