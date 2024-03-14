import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/screen/main_navigation_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/login_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/onboarding_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/sign_up_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_add_screen.dart';

final routeProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
          name: OnboardingScreen.routeName,
          path: "/",
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: MainNavigationScreen.routeName,
          path: "/:tab(home|score|calendar|chat)",
          builder: (context, state) {
            final tab = state.params["tab"]!;
            return MainNavigationScreen(tab: tab);
          },
        ),
        GoRoute(
          name: ScoreCardAddScreen.routeName,
          path: ScoreCardAddScreen.routeUrl,
          builder: (context, state) => const ScoreCardAddScreen(),
        )
      ],
    );
  },
);
