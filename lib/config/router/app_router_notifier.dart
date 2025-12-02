import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  set authStatus(AuthStatus status) {
    _authStatus = status;
    notifyListeners();
  }

  AuthStatus get authStatus => _authStatus;
}
