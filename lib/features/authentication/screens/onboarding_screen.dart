import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/screens/login_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/sign_up_screen.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';

class OnboardingScreen extends ConsumerWidget {
  static const routeName = "onboarding";
  static const routeURL = "/";
  const OnboardingScreen({super.key});

  void _onSignUpTap(BuildContext context) {
    context.pushNamed(SignUpScreen.routeName);
  }

  void _onLoginTap(BuildContext context) {
    context.pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.network(
                    "https://avatars.githubusercontent.com/u/76625609?v=4"),
              ),
              const Gap(30),
              Column(
                children: [
                  const Text(
                    "はじめまして\nゴルフ部くんです！",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(30),
                  const Text(
                    "このアプリはゴルフ部の活動をサポートするために作られました。",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                  const Gap(30),
                  GestureDetector(
                    onTap: () => _onSignUpTap(context),
                    child: const AuthButton(
                      color: Colors.green,
                      text: "会員登録",
                    ),
                  ),
                  const Gap(30),
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: const AuthButton(
                      color: Colors.blueAccent,
                      text: "ログイン",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
