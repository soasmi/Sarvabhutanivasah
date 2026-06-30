import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class AuthState {
  final User? user;
  final String? userRole;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.userRole,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    String? userRole,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthStateNotifier() : super(AuthState(isLoading: true)) {
    _init();
  }

  void _init() {
    _supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final event = data.event;
      
      if (session?.user != null) {
        if (event == AuthChangeEvent.initialSession || event == AuthChangeEvent.signedIn) {
          await _fetchRole(session!.user);
        }
      } else {
        state = AuthState(user: null, userRole: null, isLoading: false);
      }
    });
  }

  Future<void> _fetchRole(User user) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        state = AuthState(
          user: user,
          userRole: response['role'] as String,
          isLoading: false,
        );
      } else {
        await _supabase.auth.signOut();
        state = AuthState(
          user: null,
          userRole: null,
          isLoading: false,
          error: 'No user profile found. Please contact administration.',
        );
      }
    } catch (e) {
      await _supabase.auth.signOut();
      state = AuthState(
        user: null,
        userRole: null,
        isLoading: false,
        error: _parseError(e),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _parseError(e));
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _supabase.auth.signOut();
    } catch (_) {}
    state = AuthState(user: null, userRole: null, isLoading: false);
  }
  
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
  
  String _parseError(dynamic e) {
    if (e is AuthException) {
      if (e.message.toLowerCase().contains('invalid login') || e.message.toLowerCase().contains('invalid credentials')) {
        return 'Incorrect email or password.';
      }
      return e.message;
    } else if (e is SocketException || e.toString().contains('Failed to fetch') || e.toString().contains('ClientException') || e.toString().contains('SocketException')) {
      return 'Unable to connect to the server. Please check your internet connection and try again.';
    }
    return 'An unexpected error occurred. Please try again later.';
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

final isManagerProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.userRole == 'Manager';
});

// Controls when the splash screen has completely finished its 6-second animation
final splashFinishedProvider = StateProvider<bool>((ref) => false);
