import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/screen/main_navigation_screen.dart';
import 'package:golfbu_kun/common/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/authentication/screens/login_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/onboarding_screen.dart';
import 'package:golfbu_kun/features/authentication/screens/sign_up_screen.dart';
import 'package:golfbu_kun/features/profile/screens/profile_by_user_id_screen.dart';
import 'package:golfbu_kun/features/profile/screens/profile_screen.dart';
import 'package:golfbu_kun/features/profile/screens/setting_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_add_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_my_history_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_team_screen.dart';
import 'package:golfbu_kun/features/score_card/widgets/new_scorecard.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';

final routeProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: "/",
      redirect: (context, state) async {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (isLoggedIn) {
          if (state.matchedLocation == OnboardingScreen.routeURL ||
              state.matchedLocation == SignUpScreen.routeURL ||
              state.matchedLocation == LoginScreen.routeURL) {
            return "/home";
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
          path: "/:tab(home|score|calendar|profile)",
          builder: (context, state) {
            final tab = state.pathParameters["tab"]!;
            return MainNavigationScreen(tab: tab);
          },
        ),
        GoRoute(
          name: ScoreCardAddScreen.routeName,
          path: ScoreCardAddScreen.routeUrl,
          builder: (context, state) => const ScoreCardAddScreen(),
        ),
        GoRoute(
          name: ScoreCardMyHistoryScreen.routeName,
          path: ScoreCardMyHistoryScreen.routeUrl,
          builder: (context, state) => const ScoreCardMyHistoryScreen(),
        ),
        GoRoute(
          name: ScoreCardTeamScreen.routeName,
          path: ScoreCardTeamScreen.routeUrl,
          builder: (context, state) => const ScoreCardTeamScreen(),
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
          path: '${ProfileByUserIdScreen.routeURL}/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProfileByUserIdScreen(userId: id);
          },
        ),
        GoRoute(
          name: TimelineUploadQuestionScreen.routeName,
          path: TimelineUploadQuestionScreen.routeUrl,
          builder: (context, state) => const TimelineUploadQuestionScreen(),
        ),
        GoRoute(
          name: PrivacyPolicyScreen.routeName,
          path: PrivacyPolicyScreen.routeURL,
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
      ],
    );
  },
);
