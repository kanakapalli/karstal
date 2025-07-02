import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/hive_service.dart';
import '../model/user.dart';

class AuthState {
  final User? user;
  final String? error;
  const AuthState({this.user, this.error});
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState());

  Future<void> login(String username, String password, BuildContext context) async {
    if (username == 'admin' && password == 'admin') {
      state = AuthState(user: User(username: username));
      await HiveService.setIsLoggedIn(true);
      context.go('/dashboard');
    } else {
      state = const AuthState(error: 'Invalid credentials');
    }
  }

  Future<void> logout(BuildContext context) async {
    state = const AuthState();
    await HiveService.setIsLoggedIn(false);
    context.go('/login');
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) => AuthController());
