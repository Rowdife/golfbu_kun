import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/screen/main_navigation_screen.dart';

final routeProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/home",
      routes: [
        GoRoute(
          name: MainNavigationScreen.routeName,
          path: "/:tab(home|score|calendar|chat)",
          builder: (context, state) {
            final tab = state.params["tab"]!;
            return MainNavigationScreen(tab: tab);
          },
        ),
      ],
    );
  },
);
