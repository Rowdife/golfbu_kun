import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';

class LoginScreen extends ConsumerWidget {
  static const routeName = "Login";
  static const routeURL = "/login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Map<String, String> formData = {};

    void onLoginTap(BuildContext context) {
      if (formKey.currentState != null) {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          print(formData);
          // fire base 로 여기에 loginWithId 구현 예정. 임시로 홈 화면에 보내주도록 함.
          context.go("/home");
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
                "学生番号兼IDをご入力ください。",
                style: TextStyle(fontSize: 18),
              ),
              const Gap(20),
              TextFormField(
                decoration: const InputDecoration(
                  errorStyle: TextStyle(color: Colors.cyanAccent),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "学生番号を入力してください";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData["stuId"] = newValue;
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
                  child: const AuthButton(color: Colors.green, text: "ログイン"))
            ],
          ),
        ),
      ),
    );
  }
}
