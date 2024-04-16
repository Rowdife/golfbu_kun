import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final profile = ref.read(profileProvider.notifier);
    state = await AsyncValue.guard(
      () async {
        SnackBar(content: Text("登録中です"));
        final userCredential = await _authRepo.signUp(
            email: form["email"],
            password: form["password"],
            universityId: form["universityId"]);
        final university = form["university"];
        final universityId = form["universityId"];
        final position = form["position"];
        final grade = form["grade"];

        final sex = form["sex"];
        final name = form["name"];

        await profile.createProfile(
            credential: userCredential,
            university: university,
            universityId: universityId,
            position: position,
            grade: grade,
            sex: sex,
            name: name);
        if (userCredential.user != null &&
            !userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
          await _authRepo.signOut();
        }
      },
    );
    if (state.hasError) {
      const errorSnack = SnackBar(content: Text("該当するメールアドレスはすでに登録されています"));
      ScaffoldMessenger.of(context).showSnackBar(errorSnack);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "認証メールを送信しました",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  "メールを確認して、認証を完了してください",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.grey.shade900,
                actions: [
                  TextButton(
                    onPressed: () {
                      context.go("/");
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ],
              ));
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
