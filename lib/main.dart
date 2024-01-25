import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/common/main_navigation/screen/main_navigation_screen.dart';
import 'package:golfbu_kun/router.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
