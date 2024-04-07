import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card__my_history_vm.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_history_tile.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_view.dart';

class ScoreCardMyHistoryScreen extends ConsumerStatefulWidget {
  static const routeName = "ScoreCardMyHistory";
  static const routeUrl = "/score-card-my-history";
  const ScoreCardMyHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardMyHistoryScreenState();
}

class _ScoreCardMyHistoryScreenState
    extends ConsumerState<ScoreCardMyHistoryScreen> {
  void _onScoreCardTap(ScoreCardDataModel scoreCardData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreCardView(
          scoreCardData: scoreCardData,
        ),
      ),
    );
  }

  void _fetchMyScoreCardsData() async {
    ref.read(scoreCardMyHisotryProvider.notifier).fetchMyScoreCardsData();
  }

  @override
  void initState() {
    _fetchMyScoreCardsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("スコア分析"),
      ),
      body: ref.watch(scoreCardMyHisotryProvider).when(
            data: (scoreCardsData) {
              final scoreCard = scoreCardsData;
              return ListView.builder(
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
                            uploaderName: scoreCard[index].uploaderName,
                            uploadDate: scoreCard[index].uploadDate.toString(),
                            totalScore: scoreCard[index].totalScore.toString(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
