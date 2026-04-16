import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ai_analysis_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_profile_repository.dart';
import '../../../data/services/groq_service.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final GroqService _groqService;
  final UserProfileRepository _profileRepo;

  /// Cached last event for retry support.
  AIEvent? _lastEvent;

  AIBloc({
    required GroqService groqService,
    required UserProfileRepository profileRepo,
  })  : _groqService = groqService,
        _profileRepo = profileRepo,
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

  Future<void> _runAnalysis({
    required ProductModel product,
    required UserProfile userProfile,
    required Emitter<AIState> emit,
  }) async {
    try {
      final analysis = await _groqService.analyzeProduct(
        product,
        userProfile: userProfile,
      );
      emit(AISuccess(analysis, product: product));
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
