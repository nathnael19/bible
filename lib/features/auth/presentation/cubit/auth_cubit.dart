import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/core/services/local_storage.dart';

// ── States ────────────────────────────────────────────────────────────────────

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? username;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.username,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? username,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, username];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AuthCubit extends Cubit<AuthState> {
  final LocalStorage _storage;

  AuthCubit(this._storage) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    // Wait for the splash screen animation to complete
    await Future.delayed(const Duration(seconds: 3));
    
    final isLoggedIn = _storage.isLoggedIn();
    if (isLoggedIn) {
      final username = _storage.getUsername();
      emit(state.copyWith(status: AuthStatus.authenticated, username: username));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'እባክዎን ሁሉንም ቦታዎች ይሙሉ',
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock success - any non-empty credentials work
    await _storage.setLoggedIn(true);
    await _storage.setUsername(username);

    emit(state.copyWith(status: AuthStatus.authenticated, username: username));
  }

  Future<void> register(String fullName, String email, String password) async {
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'እባክዎን ሁሉንም ቦታዎች ይሙሉ',
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    await _storage.setLoggedIn(true);
    await _storage.setUsername(fullName);

    emit(state.copyWith(status: AuthStatus.authenticated, username: fullName));
  }

  Future<void> sendResetCode(String email) async {
    if (email.isEmpty) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'እባክዎን ኢሜይልዎን ያስገቡ'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    // Mock success
    emit(state.copyWith(status: AuthStatus.initial)); // Reset for next step
  }

  Future<void> verifyResetCode(String code) async {
    if (code.length < 4) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'እባክዎን ትክክለኛ ኮድ ያስገቡ'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    // Mock success
    emit(state.copyWith(status: AuthStatus.initial));
  }

  Future<void> logout() async {
    await _storage.setLoggedIn(false);
    await _storage.clearUsername();
    emit(state.copyWith(status: AuthStatus.unauthenticated, username: null));
  }
}
