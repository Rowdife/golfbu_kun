import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/firebase_options.dart';
import 'package:golfbu_kun/router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('ja_JP');

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
    return MaterialApp.router(
      routerConfig: ref.watch(routeProvider),
      title: 'Golfbukun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
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
          shadowColor: Colors.green,
        ),
      ),
    );
  }
}
