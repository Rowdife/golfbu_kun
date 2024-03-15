import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/profile/screens/setting_screen.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_menu.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _onSettingTap(BuildContext context) {
    context.pushNamed(SettingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            DefaultTextStyle(
              style: const TextStyle(fontSize: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileMenu(
                    icon: FontAwesomeIcons.solidUser,
                    text: 'プロフィール情報',
                  ),
                  const ProfileMenu(
                    icon: FontAwesomeIcons.golfBallTee,
                    text: "スイングアーカイブ",
                  ),
                  GestureDetector(
                    onTap: () => _onSettingTap(context),
                    child: const ProfileMenu(
                      icon: FontAwesomeIcons.gear,
                      text: "設定",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
