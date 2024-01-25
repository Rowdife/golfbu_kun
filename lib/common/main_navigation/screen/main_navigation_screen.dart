import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/widgets/nav_tap.dart';
import 'package:golfbu_kun/features/league_relations/screen/chat_screen.dart';
import 'package:golfbu_kun/features/schedule_management/screen/calendar_screen.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_screen.dart';

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
    "chat",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
            child: const ChatScreen(),
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
            NavTap(
              tapName: 'Calendar',
              icon: FontAwesomeIcons.calendar,
              isSelected: _selectedIndex == 2,
              onTap: () => _onTap(2),
            ),
            NavTap(
              tapName: 'Chat',
              icon: FontAwesomeIcons.comment,
              isSelected: _selectedIndex == 3,
              onTap: () => _onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
