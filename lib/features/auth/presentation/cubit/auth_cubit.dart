import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/core/services/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ── States ────────────────────────────────────────────────────────────────────

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? username;
  final User? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.username,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? username,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, username, user];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<User?>? _authStateSubscription;

  // ignore: unused_field
  final LocalStorage _storage;
  
  AuthCubit(this._storage, this._firebaseAuth) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    // Wait for the splash screen animation to complete
    await Future.delayed(const Duration(seconds: 3));
    
    _authStateSubscription = _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated, 
          username: user.displayName ?? user.email?.split('@')[0] ?? 'User',
          user: user,
        ));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null, username: null));
      }
    });
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'እባክዎን ሁሉንም ቦታዎች ይሙሉ',
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message ?? 'Login failed'));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
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

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      await userCredential.user?.updateDisplayName(fullName);
      // Wait a moment for the profile update to finalize across internal states
      await Future.delayed(const Duration(milliseconds: 500));
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message ?? 'Registration failed'));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> sendResetCode(String email) async {
    if (email.isEmpty) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'እባክዎን ኢሜይልዎን ያስገቡ'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      emit(state.copyWith(status: AuthStatus.initial)); // UI listens for this to proceed to CheckEmailScreen
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message ?? 'Failed to send reset email'));
    }
  }

  Future<void> verifyResetCode(String code) async {
    // With Firebase, reset is handled via the email link usually.
    // So this might not be needed depending on UI modifications, but to satisfy interface:
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: AuthStatus.initial));
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
