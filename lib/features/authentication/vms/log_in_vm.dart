import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = await AsyncValue.guard(
        () async => await _repository.signIn(email, password));
    if (state.hasError) {
      const errorSnack = SnackBar(content: Text("ログイン情報が正しくありません"));
      ScaffoldMessenger.of(context).showSnackBar(errorSnack);
    }
  }
}

final loginProvider = AsyncNotifierProvider(
  () => LoginViewModel(),
);
