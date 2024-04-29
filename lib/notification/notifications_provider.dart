import 'dart:async';
import 'dart:math';

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
      _promoteVideoUploadNotification(universityName);
      _aguCalendarNotification();
    } else {}
  }

  void _promoteVideoUploadNotification(String universityName) async {
    final everySaturdayEightPm = tz.TZDateTime(tz.local, 2024, 4, 22, 21, 0, 0);
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

  void _aguCalendarNotification() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot =
        await firestore.collection('university/agu/calendar').get();

    for (var doc in querySnapshot.docs) {
      DateTime date = DateTime.parse(doc['date']);
      String title = doc['title'];

      _scheduleNotification(date.subtract(Duration(days: 3)), '$titleの3日前です');
      _scheduleNotification(date.subtract(Duration(days: 1)), '$titleの前日です');
    }
  }

  void _scheduleNotification(DateTime date, String message) async {
    if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) return;
    final scheduledTzTime = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      20,
      00,
    );

    final notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 0,
      ),
    );

    print(scheduledTzTime);
    print(message);

    await _notificationsPlugin.zonedSchedule(
      Random().nextInt(100),
      '部内カレンダー通知',
      message,
      scheduledTzTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
