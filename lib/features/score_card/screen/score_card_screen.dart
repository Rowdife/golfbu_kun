import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_add_screen.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_button.dart';

class ScoreCardScreen extends ConsumerStatefulWidget {
  const ScoreCardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardScreenState();
}

class _ScoreCardScreenState extends ConsumerState<ScoreCardScreen> {
  void _onScoreAddTap(BuildContext context) {
    context.pushNamed(ScoreCardAddScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("スコア管理")),
      body: SafeArea(
        child: Center(
          child: Container(
            height: size.height * 0.75,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black87,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _onScoreAddTap(context),
                  child: const ScoreButton(
                    icon: FontAwesomeIcons.plus,
                    text: "スコアを新規登録",
                    color: Colors.green,
                  ),
                ),
                const ScoreButton(
                  icon: FontAwesomeIcons.magnifyingGlassChart,
                  text: "自分のスコアを分析",
                  color: Colors.blueAccent,
                ),
                const ScoreButton(
                  icon: FontAwesomeIcons.rankingStar,
                  text: "部内のスコアを分析",
                  color: Colors.cyan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
