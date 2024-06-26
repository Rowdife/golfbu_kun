import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/authentication/vms/delete_account_vm.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static const routeName = "Setting";
  static const routeURL = "/setting";
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

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
            onPressed: () async => {
              await ref.read(authRepo).signOut(),
              ref.read(profileProvider.notifier).resetProfile(),
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
          "本当にアカウントを削除してよろしいですか？\n 今までアップロードしたデータは全て削除されます。",
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
  void initState() {
    super.initState();
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
              title: const Text(
                "お手数ですが、通知のOn-Offは\n「設定→ゴルフ部くん」から操作してください。",
                style: TextStyle(fontSize: 12),
              ),
            ),
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
                    listTileTheme: const ListTileThemeData(
                  textColor: Colors.white,
                )),
                child: ListTile(
                  title: const Text("About Golfbu-kun"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Theme(
                          data: Theme.of(context).copyWith(
                            cardColor: Colors.grey.shade900,
                          ),
                          child: LicensePage(
                            applicationIcon: SvgPicture.asset(
                              "assets/images/golfbukun_logo.svg",
                              width: 200,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
