import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/score_card/courses/sevenhundred.dart';
import 'package:golfbu_kun/features/score_card/courses/suginosato.dart';

class ScoreCardAddScreen extends ConsumerStatefulWidget {
  static const routeName = "addscore";
  static const routeUrl = "/addscore";
  const ScoreCardAddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardAddScreenState();
}

class _ScoreCardAddScreenState extends ConsumerState<ScoreCardAddScreen> {
  void _onSevenhundredTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Sevenhundred(),
      ),
    );
  }

  void _onSuginosatoTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Suginosato(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("スコアを登録"),
      ),
      body: Column(
        children: [
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  color: Colors.black54,
                  width: size.width * 0.8,
                  height: size.height * 0.8,
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () => _onSevenhundredTap(context),
                        child: const ListTile(
                          iconColor: Colors.white,
                          title: Text(
                            "セブンハンドレッドクラブ",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: FaIcon(FontAwesomeIcons.chevronRight),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _onSuginosatoTap(context),
                        child: const ListTile(
                          iconColor: Colors.white,
                          title: Text(
                            "杉の郷カントリークラブ",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: FaIcon(FontAwesomeIcons.chevronRight),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
