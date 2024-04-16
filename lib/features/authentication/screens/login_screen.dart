import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/vms/log_in_vm.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';

class LoginScreen extends ConsumerWidget {
  static const routeName = "Login";
  static const routeURL = "/login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Map<String, String> formData = {};
    bool isLoggingIn = false;

    void onLoginTap(BuildContext context) async {
      if (isLoggingIn) return;
      if (formKey.currentState != null) {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          isLoggingIn = true;

          await ref.read(loginProvider.notifier).login(
              email: formData["email"]!,
              password: formData["password"],
              context: context);
          isLoggingIn = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ログイン"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Gap(10),
              const Text(
                "メールアドレスをご入力ください。",
                style: TextStyle(fontSize: 18),
              ),
              const Gap(20),
              TextFormField(
                decoration: const InputDecoration(
                  errorStyle: TextStyle(color: Colors.cyanAccent),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "メールアドレスを入力してください";
                  } else if (!EmailValidator.validate(value!)) {
                    return "メールアドレスを正しく入力してください";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData["email"] = newValue;
                  }
                },
              ),
              const Gap(20),
              const Text(
                "パスワードをご入力ください",
                style: TextStyle(fontSize: 18),
              ),
              const Gap(10),
              TextFormField(
                decoration: const InputDecoration(
                  errorStyle: TextStyle(color: Colors.cyanAccent),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "パスワードを入力してください";
                  }
                  return null;
                },
                obscureText: true,
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData["password"] = newValue;
                  }
                },
              ),
              const Gap(50),
              GestureDetector(
                  onTap: () => onLoginTap(context),
                  child: const AuthButton(
                    color: Colors.green,
                    text: "ログイン",
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
