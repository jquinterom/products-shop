import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_app/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_app/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout(e.toString());
    }
  }

  void registerUser(String email, String password, String name) async {}

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout(e.toString());
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      status: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKeyValue('token');

    state = state.copyWith(
      user: null,
      status: AuthStatus.unauthenticated,
      errorMessage: errorMessage,
    );
  }
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      authStatus: status ?? authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
