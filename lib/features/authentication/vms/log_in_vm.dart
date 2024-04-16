import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<void> login(
      {required String email, password, required BuildContext context}) async {
    const loadingSnack = SnackBar(content: Text("ログイン中です"));
    ScaffoldMessenger.of(context).showSnackBar(loadingSnack);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.signIn(email, password);
    });

    if (state.hasError) {
      const errorSnack = SnackBar(content: Text("ログイン情報が正しくありません"));
      if (!state.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
      }
    } else {
      if (!_repository.user!.emailVerified) {
        await _repository.signOut();
        const errorSnack = SnackBar(content: Text("メール認証が完了していません"));
        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
        return;
      }
      context.go("/home");
    }
  }
}

final loginProvider = AsyncNotifierProvider(
  () => LoginViewModel(),
);
