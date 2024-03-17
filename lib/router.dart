import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/screen/main_navigation_screen.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/authentication/screens/login_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/onboarding_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/sign_up_screen.dart';
import 'package:golfbu_kun/features/profile/screens/profile_screen.dart';
import 'package:golfbu_kun/features/profile/screens/setting_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_add_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';

final routeProvider = Provider(
  (ref) {
    ref.watch(authState);
    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != OnboardingScreen.routeURL &&
              state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return "/";
          } else {
            return null;
          }
        }
        return null;
      },
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
          path: "/:tab(home|score|calendar|chat|profile)",
          builder: (context, state) {
            final tab = state.params["tab"]!;
            return MainNavigationScreen(tab: tab);
          },
        ),
        GoRoute(
          name: ScoreCardAddScreen.routeName,
          path: ScoreCardAddScreen.routeUrl,
          builder: (context, state) => const ScoreCardAddScreen(),
        ),
        GoRoute(
          name: SettingScreen.routeName,
          path: SettingScreen.routeURL,
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          name: ProfileScreen.routeName,
          path: ProfileScreen.routeURL,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: TimelineUploadQuestionScreen.routeName,
          path: TimelineUploadQuestionScreen.routeUrl,
          builder: (context, state) => const TimelineUploadQuestionScreen(),
        ),
      ],
    );
  },
);
