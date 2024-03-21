import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/authentication/vms/delete_account_vm.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static const routeName = "Setting";
  static const routeURL = "/setting";
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  void _onLogoutTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          "本当にログアウトしてよろしいですか？",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("いいえ"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => {
              ref.read(authRepo).signOut(),
              context.go("/"),
            },
            isDestructiveAction: true,
            child: const Text("ログアウト"),
          ),
        ],
      ),
    );
  }

  void _oDeleteAccountTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          "本当にアカウントを削除してよろしいですか？",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("いいえ"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => {
              ref.read(deleteAccountProvider.notifier).deleteAccount(context),
            },
            isDestructiveAction: true,
            child: const Text("アカウント削除"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            ListTile(
              onTap: _onLogoutTap,
              title: const Text(
                "ログアウト",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: _oDeleteAccountTap,
              title: const Text(
                "アカウント削除",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Theme(
              data: ThemeData(
                  listTileTheme:
                      const ListTileThemeData(textColor: Colors.white)),
              child: const AboutListTile(),
            ),
          ],
        ),
      ),
    );
  }
}
