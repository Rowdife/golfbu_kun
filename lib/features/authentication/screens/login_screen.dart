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

    void resetPassword(BuildContext context) {
      final _formKey = GlobalKey<FormState>();
      String? emailAdress;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('登録しているメールアドレスを入力してください'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレス';
                  }
                  return null;
                },
                onSaved: (value) {
                  emailAdress = value;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child:
                    Text('Cancel', style: TextStyle(color: Colors.greenAccent)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.greenAccent),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (emailAdress != null) {
                      await ref
                          .read(loginProvider.notifier)
                          .resetPassword(email: emailAdress!, context: context);
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "再設定メールを送信しました",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            "メールを確認して、再設定を完了してください",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey.shade900,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ],
          );
        },
      );
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
              Gap(20),
              GestureDetector(
                onTap: () {
                  resetPassword(context);
                },
                child: Text(
                  "パスワードを忘れた場合はこちら",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const Gap(20),
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
