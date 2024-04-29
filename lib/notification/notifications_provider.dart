import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/authentication/vms/sign_up_getschool_vm.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationsProvider extends AsyncNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _db
        .collection("university")
        .doc(user!.displayName)
        .collection("users")
        .doc(user.uid)
        .update({"token": token});
  }

  Future<void> initListeners() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );
    final initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    final notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 0,
      ),
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _notificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });

    final user = ref.read(authRepo).user;
    final userUniversityId = user?.displayName;
    if (user == null) return;
    if (userUniversityId == 'agu') {
      final universityMap = await ref
          .read(getSchoolListProvider.notifier)
          .getUniversityNameList();
      final universityName = universityMap[userUniversityId];
      _scheduleNotification(universityName);
      print("通知が設定されました!");
    } else {
      print("通知が設定されませんでした。");
    }
  }

//agu calendar
  void _scheduleNotification(String universityName) async {
    final everySaturdayEightPm = tz.TZDateTime(tz.local, 2024, 4, 22, 20, 0, 0);
    final notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 0,
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      1,
      '投稿Day!',
      '本日は$universityNameのスイング動画投稿Dayです、投稿をお忘れなく!',
      everySaturdayEightPm,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  @override
  FutureOr build() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
    await initListeners();
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
