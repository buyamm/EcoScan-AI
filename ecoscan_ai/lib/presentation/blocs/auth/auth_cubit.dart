import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepo;

  AuthCubit({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(const AuthState()) {
    _init();
  }

  void _init() {
    final user = _authRepo.getCurrentUser();
    if (user != null) {
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    }
    // Otherwise stays at initial — SplashScreen will decide routing
  }

  /// Sign in with Google. On first login, sets [isFirstLogin] = true.
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final isNew = !_authRepo.isSignedIn;
      final user = await _authRepo.signInWithGoogle();
      if (user == null) {
        // User cancelled
        emit(state.copyWith(status: AuthStatus.initial));
        return;
      }
      emit(AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isFirstLogin: isNew,
      ));
    } catch (e) {
      emit(AuthState(
        status: AuthStatus.error,
        errorMessage: 'Đăng nhập thất bại: $e',
      ));
    }
  }

  /// Continue as guest without signing in.
  void continueAsGuest() {
    emit(const AuthState(status: AuthStatus.guest));
  }

  /// Sign out and clear Google user info.
  Future<void> signOut() async {
    await _authRepo.signOut();
    emit(const AuthState(status: AuthStatus.initial));
  }
}
