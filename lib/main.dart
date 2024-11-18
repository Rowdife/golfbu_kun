import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/firebase_options.dart';
import 'package:golfbu_kun/notification/notifications_provider.dart';
import 'package:golfbu_kun/router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterAppBadger.removeBadge();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('ja_JP');

  // アプリ起動時に　temporary_scorecardが存在する場合、そのtemporary_scorecardのデータを入れてnew_scorecardに渡したい

  final prefs = await SharedPreferences.getInstance();
  String? jsonData = prefs.getString("temporary_scorecard");
  if (jsonData != null) {
    print(jsonDecode(jsonData));
  }
  runApp(
    ProviderScope(
      overrides: [routeProvider],
      child: const GolfbukunApp(),
    ),
  );
}

class GolfbukunApp extends ConsumerWidget {
  const GolfbukunApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routeProvider),
      title: 'Golfbukun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, primary: Colors.green),
        scaffoldBackgroundColor: Colors.grey.shade900,
        useMaterial3: true,
        textTheme: Typography.whiteMountainView,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.green,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade900,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          toolbarHeight: 50,
          color: Colors.grey.shade900,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          centerTitle: true,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(fontSize: 16),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
        ),
      ),
    );
  }
}
