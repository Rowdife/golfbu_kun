import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/utils.dart';

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
        await _repository.user!.sendEmailVerification();
        await _repository.signOut();
        const errorSnack =
            SnackBar(content: Text("メール認証が完了していません、メール認証を再度送ります。"));
        ScaffoldMessenger.of(context).showSnackBar(errorSnack);
        return;
      }
      await ref.read(timelineProvider.notifier).refresh();
      context.go("/home");
    }
  }

  Future<void> resetPassword(
      {required String email, required BuildContext context}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await _repository.resetPassword(email);
      } catch (e) {
        showFirebaseErrorSnack(context, e);
      }
    });
  }
}

final loginProvider = AsyncNotifierProvider(
  () => LoginViewModel(),
);
