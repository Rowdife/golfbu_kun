import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/new_scorecard_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/screen/new_scorecard_view.dart';

import 'package:golfbu_kun/features/score_card/vms/score_card__my_history_vm.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card_team.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_history_tile.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_view.dart';

class ScoreCardTeamScreen extends ConsumerStatefulWidget {
  static const routeName = "ScoreCardTeam";
  static const routeUrl = "/score-card-team";
  const ScoreCardTeamScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardTeamScreenState();
}

class _ScoreCardTeamScreenState extends ConsumerState<ScoreCardTeamScreen> {
  void _onScoreCardTap(NewScoreCardDataModel scoreCardData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewScoreCardView(
          scoreCardData: scoreCardData,
        ),
      ),
    );
  }

  Future<void> _fetchTeamScoreCardsData() async {
    await ref.read(scoreCardTeamProvider.notifier).fetchTeamScoreCardsData();
  }

  @override
  void initState() {
    _fetchTeamScoreCardsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("スコア分析"),
      ),
      body: ref.watch(scoreCardTeamProvider).when(
            data: (scoreCardsData) {
              final scoreCard = scoreCardsData;
              return RefreshIndicator(
                onRefresh: _fetchTeamScoreCardsData,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: scoreCard.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _onScoreCardTap(scoreCard[index]),
                            child: ScoreCardHistoryTile(
                              courseName: scoreCard[index].courseName,
                              uploadDate:
                                  scoreCard[index].uploadDate.toString(),
                              uploaderName: scoreCard[index].uploaderName,
                              totalScore:
                                  scoreCard[index].totalScore.toString(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => const Center(
              child: Text("エラーが発生しました"),
            ),
          ),
    );
  }
}
