import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/widgets/nav_tap.dart';
import 'package:golfbu_kun/features/league_relations/screen/chat_screen.dart';
import 'package:golfbu_kun/features/profile/screens/profile_nav_screen.dart';
import 'package:golfbu_kun/features/profile/screens/profile_screen.dart';
import 'package:golfbu_kun/features/schedule_management/screen/calendar_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_choice_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static const routeURL = "/home";
  static const routeName = "MainNavigation";
  const MainNavigationScreen({super.key, required this.tab});
  final String tab;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "score",
    "calendar",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onUploadTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimelineUploadChoiceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const TimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const ScoreCardScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const CalendarScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const ProfileScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.grey.shade900,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavTap(
              tapName: 'Home',
              icon: FontAwesomeIcons.house,
              isSelected: _selectedIndex == 0,
              onTap: () => _onTap(0),
            ),
            NavTap(
              tapName: 'Score',
              icon: FontAwesomeIcons.chartColumn,
              isSelected: _selectedIndex == 1,
              onTap: () => _onTap(1),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white24,
                        offset: Offset(0, 0),
                        blurRadius: 5.0,
                        spreadRadius: 0.1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => _onUploadTap(context),
                    icon: FaIcon(
                      FontAwesomeIcons.upload,
                      color: Colors.white,
                    ),
                  ),
                ),
                Gap(10),
              ],
            ),
            NavTap(
              tapName: 'Calendar',
              icon: FontAwesomeIcons.calendar,
              isSelected: _selectedIndex == 2,
              onTap: () => _onTap(2),
            ),
            NavTap(
              tapName: 'Profile',
              icon: FontAwesomeIcons.user,
              isSelected: _selectedIndex == 3,
              onTap: () => _onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
