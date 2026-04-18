part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authenticated, guest, error }

class AuthState {
  final AuthStatus status;
  final GoogleUser? user;
  final String? errorMessage;
  final bool isFirstLogin;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isFirstLogin = false,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.guest;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    GoogleUser? user,
    String? errorMessage,
    bool? isFirstLogin,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      );
}
