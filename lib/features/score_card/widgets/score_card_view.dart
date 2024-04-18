import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';

import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_data_tile.dart';

class ScoreCardView extends ConsumerStatefulWidget {
  const ScoreCardView({
    super.key,
    required this.scoreCardData,
  });
  final ScoreCardDataModel scoreCardData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScoreCardViewState();
}

class _ScoreCardViewState extends ConsumerState<ScoreCardView> {
  @override
  Widget build(BuildContext context) {
    double widthAndHeight = MediaQuery.of(context).size.width / 10;
    double totalScoreWidth = MediaQuery.of(context).size.width / 6;
    double totalScoreHeight = 100;
    final scoreCard = widget.scoreCardData;
    final parValueList = widget.scoreCardData.parValueList;
    final scoreList = widget.scoreCardData.scoreList;
    final puttList = widget.scoreCardData.puttsList;
    int outTotalScore = 0;
    int inTotalScore = 0;
    int outTotalPutt = 0;
    int inTotalPutt = 0;

    for (int i = 0; i <= 8; i++) {
      outTotalScore += scoreList[i];
      outTotalPutt += puttList[i];
    }
    for (int i = 9; i <= 17; i++) {
      inTotalScore += scoreList[i];
      inTotalPutt += puttList[i];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "スコアカード",
        ),
        actions: [
          if (scoreCard.uploaderId == ref.read(authRepo).user!.uid)
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("本当にこのスコアデータを削除してよろしいですか？"),
                    content: const Text("取り戻せなくなります。"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          context.pop();
                          return;
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref
                              .read(scoreCardRepo)
                              .deleteScoreCardByCreatedAt(
                                  scoreCard.createAtUnix);
                          await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("削除完了"),
                              content: const Text("スコア削除を完了しました"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                          context.pop();
                          context.pop();
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.trash),
            ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "コース名: ${scoreCard.courseName}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "日付: ${scoreCard.uploadDate}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "プレーヤー名: ${scoreCard.uploaderName}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(fontSize: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                              child: const Center(
                                child: Text(
                                  "Hole",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 1; i <= 9; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    const BoxDecoration(color: Colors.black),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: const Center(
                                child: Text(
                                  "Par",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 0; i <= 8; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade900),
                                child: Center(
                                  child: Text(
                                    parValueList[i].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: const Center(
                                child: Text(
                                  "Score",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 0; i <= 8; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade800),
                                child: Center(
                                  child: Text(
                                    scoreList[i].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: const Center(
                                child: Text(
                                  "Putt",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 0; i <= 8; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade900),
                                child: Center(
                                  child: Text(
                                    puttList[i].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: const Center(
                                child: Text(
                                  "To par",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 0; i <= 8; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade800),
                                child: Center(
                                  child: Text(
                                    scoreList[i] - parValueList[i] > 0
                                        ? "+${scoreList[i] - parValueList[i]}"
                                        : (scoreList[i] - parValueList[i])
                                            .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(fontSize: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                              child: const Center(
                                child: Text(
                                  "Hole",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 9; i <= 17; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    const BoxDecoration(color: Colors.black),
                                child: Center(
                                  child: Text(
                                    i.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: const Center(
                                child: Text(
                                  "Par",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 9; i <= 17; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade900),
                                child: Center(
                                  child: Text(
                                    parValueList[i].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: const Center(
                                child: Text(
                                  "Score",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 9; i <= 17; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade800),
                                child: Center(
                                  child: Text(
                                    scoreList[i].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: const Center(
                                child: Text(
                                  "Putt",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 9; i <= 17; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade900),
                                child: Center(
                                  child: Text(
                                    puttList[i].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: const Center(
                                child: Text(
                                  "To par",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            for (int i = 9; i <= 17; i++)
                              Container(
                                width: widthAndHeight,
                                height: widthAndHeight,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade800),
                                child: Center(
                                  child: Text(
                                    scoreList[i] - parValueList[i] > 0
                                        ? "+${scoreList[i] - parValueList[i]}"
                                        : (scoreList[i] - parValueList[i])
                                            .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Center(
                          child: Text(
                            "OUT\nTotal",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: BoxDecoration(color: Colors.grey.shade800),
                        child: Center(
                          child: Text(
                            "$outTotalScore",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Center(
                          child: Text(
                            "IN\nTotal",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: BoxDecoration(color: Colors.grey.shade800),
                        child: Center(
                          child: Text(
                            "$inTotalScore",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Center(
                          child: Text(
                            "Total Score",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: BoxDecoration(color: Colors.grey.shade800),
                        child: Center(
                          child: Text(
                            "${scoreCard.totalScore}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                    height: 2,
                  ),
                  Row(
                    children: [
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Center(
                          child: Text(
                            "OUT\n putt",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: BoxDecoration(color: Colors.grey.shade800),
                        child: Center(
                          child: Text(
                            "$outTotalPutt",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Center(
                          child: Text(
                            "IN\n putt",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: BoxDecoration(color: Colors.grey.shade800),
                        child: Center(
                          child: Text(
                            "$inTotalPutt",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Center(
                          child: Text(
                            "Total Putt",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: totalScoreWidth,
                        height: totalScoreHeight,
                        decoration: BoxDecoration(color: Colors.grey.shade800),
                        child: Center(
                          child: Text(
                            "${scoreCard.totalPutts}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(10),
              DefaultTextStyle(
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "天気: ${scoreCard.weather}",
                    ),
                    Text(
                      "最大風速: ${scoreCard.wind}m/s",
                    ),
                    Text(
                      "気温: ${scoreCard.temperature}",
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "スコア分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "ダブルボギー以上の数",
                        data: scoreCard.overBogeyCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "ボギーの数",
                        data: scoreCard.bogeyCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "パーの数",
                        data: scoreCard.parCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "バーディの数",
                        data: scoreCard.birdieCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "イーグル以下の数",
                        data: scoreCard.underBirdieCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "Par3平均スコア",
                        data: scoreCard.averagePar3Score.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "Par4平均スコア",
                        data: scoreCard.averagePar4Score.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "Par5平均スコア",
                        data: scoreCard.averagePar5Score.toString(),
                      ),
                      const Gap(20),
                      const Text(
                        "ティーショット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイキープ",
                        data:
                            "${scoreCard.totalFairwayFind} / ${scoreCard.totalFairwayTry}",
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイキープ率",
                        data:
                            "${(scoreCard.totalFairwayFind / scoreCard.totalFairwayTry * 100).toStringAsFixed(1)}%",
                      ),
                      // model設計ミスによって表示不可。修正要
                      ScoreCardDataTile(
                        title: "フェアウェイより左に外れた数",
                        data:
                            "${scoreCard.teeShotMissedLeft} / ${scoreCard.totalFairwayTry}",
                      ),
                      ScoreCardDataTile(
                          title: "フェアウェイより左に外れる確率",
                          data:
                              "${(scoreCard.teeShotMissedLeft / scoreCard.totalFairwayTry * 100).toStringAsFixed(1)}%"),
                      ScoreCardDataTile(
                        title: "フェアウェイより右に外れた数",
                        data:
                            "${scoreCard.teeShotMissedRight} / ${scoreCard.totalFairwayTry}",
                      ),
                      ScoreCardDataTile(
                          title: "フェアウェイより右に外れる確率",
                          data:
                              "${(scoreCard.teeShotMissedRight / scoreCard.totalFairwayTry * 100).toStringAsFixed(1)}%"),

                      ScoreCardDataTile(
                        title: "ティーショットクリティカルミス",
                        data:
                            "${scoreCard.teeShotCriticalMiss} / ${scoreCard.totalFairwayTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ティーショットクリティカルミス率",
                        data:
                            "${(scoreCard.teeShotCriticalMiss / scoreCard.totalFairwayTry * 100).toStringAsFixed(1)}%",
                      ),

                      const Gap(20),
                      const Text(
                        "クラブ別FWキープ率",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "Driver のFwキープ数",
                        data:
                            "${scoreCard.driverFairwayFind} / ${scoreCard.driverFairwayTry}",
                      ),
                      ScoreCardDataTile(
                        title: "DriverのFwキープ率",
                        data:
                            "${(scoreCard.driverFairwayFind / scoreCard.driverFairwayTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "WoodのFwキープ数",
                        data:
                            "${scoreCard.woodFairwayFind} / ${scoreCard.woodFairwayTry}",
                      ),
                      ScoreCardDataTile(
                        title: "WoodのFwキープ率",
                        data:
                            "${(scoreCard.woodFairwayFind / scoreCard.woodFairwayTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "UTのFwキープ数",
                        data:
                            "${scoreCard.utilityFairwayFind} / ${scoreCard.utilityFairwayTry}",
                      ),
                      ScoreCardDataTile(
                        title: "UTのFwキープ率",
                        data:
                            "${(scoreCard.utilityFairwayFind / scoreCard.utilityFairwayTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "IronのFwキープ数",
                        data:
                            "${scoreCard.ironFairwayFind} / ${scoreCard.ironFairwayTry}",
                      ),
                      ScoreCardDataTile(
                        title: "IronのFwキープ率",
                        data:
                            "${(scoreCard.ironFairwayFind / scoreCard.ironFairwayTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "Par3 ティーショット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const Gap(20),
                      ScoreCardDataTile(
                        title: "グリーン乗せ成功数",
                        data:
                            "${scoreCard.parThreeGreenInRegulation} / ${scoreCard.parThreeTeeshotTry}",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン乗せ成功率",
                        data:
                            "${(scoreCard.parThreeGreenInRegulation / scoreCard.parThreeTeeshotTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン左外し",
                        data:
                            "${scoreCard.parThreeGreenMissedLeft} / ${scoreCard.parThreeTeeshotTry}",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン左外し率",
                        data:
                            "${(scoreCard.parThreeGreenMissedLeft / scoreCard.parThreeTeeshotTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン右外し",
                        data:
                            "${scoreCard.parThreeGreenMissedRight} / ${scoreCard.parThreeTeeshotTry}",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン右外し率",
                        data:
                            "${(scoreCard.parThreeGreenMissedRight / scoreCard.parThreeTeeshotTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンショート",
                        data:
                            "${scoreCard.parThreeGreenMissedShort} / ${scoreCard.parThreeTeeshotTry}",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンショート率",
                        data:
                            "${(scoreCard.parThreeGreenMissedShort / scoreCard.parThreeTeeshotTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンオーバー",
                        data:
                            "${scoreCard.parThreeGreenMissedOver} / ${scoreCard.parThreeTeeshotTry}",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンオーバー率",
                        data:
                            "${(scoreCard.parThreeGreenMissedOver / scoreCard.parThreeTeeshotTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Text(
                        "パーオン分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "パーオン",
                        data: "${scoreCard.totalParOn} / 18ホール",
                      ),
                      ScoreCardDataTile(
                        title: "パーオン率",
                        data:
                            "${(scoreCard.totalParOn / 18 * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "パーオン距離別分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "50ヤード以内パーオン数",
                        data:
                            "${scoreCard.greenInRegulationIn50} / ${scoreCard.greenInRegulationIn50Try}",
                      ),
                      ScoreCardDataTile(
                        title: "50ヤード以内パーオン率",
                        data:
                            "${(scoreCard.greenInRegulationIn50 / scoreCard.greenInRegulationIn50Try * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "100ヤード以内パーオン数",
                        data:
                            "${scoreCard.greenInRegulationIn100} / ${scoreCard.greenInRegulationIn100Try}",
                      ),
                      ScoreCardDataTile(
                        title: "100ヤード以内パーオン率",
                        data:
                            "${(scoreCard.greenInRegulationIn100 / scoreCard.greenInRegulationIn100Try * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "150ヤード以内パーオン数",
                        data:
                            "${scoreCard.greenInRegulationIn150} / ${scoreCard.greenInRegulationIn150Try}",
                      ),
                      ScoreCardDataTile(
                        title: "150ヤード以内パーオン率",
                        data:
                            "${(scoreCard.greenInRegulationIn150 / scoreCard.greenInRegulationIn150Try * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以内パーオン数",
                        data:
                            "${scoreCard.greenInRegulationIn200} / ${scoreCard.greenInRegulationIn200Try}",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以内パーオン率",
                        data:
                            "${(scoreCard.greenInRegulationIn200 / scoreCard.greenInRegulationIn200Try * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以上パーオン数",
                        data:
                            "${scoreCard.greenInRegulationOver200} / ${scoreCard.greenInRegulationOver200Try}",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以上パーオン率",
                        data:
                            "${(scoreCard.greenInRegulationOver200 / scoreCard.greenInRegulationOver200Try * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "パーオンクラブ別分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "woodパーオン数",
                        data:
                            "${scoreCard.parOnByWood} / ${scoreCard.parOnByWoodTry}",
                      ),
                      ScoreCardDataTile(
                        title: "woodパーオン率",
                        data:
                            "${(scoreCard.parOnByWood / scoreCard.parOnByWoodTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "UTパーオン数",
                        data:
                            "${scoreCard.parOnByUtility} / ${scoreCard.parOnByUtilityTry}",
                      ),
                      ScoreCardDataTile(
                        title: "UTパーオン率",
                        data:
                            "${(scoreCard.parOnByUtility / scoreCard.parOnByUtilityTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "LongIronパーオン数",
                        data:
                            "${scoreCard.parOnByLongIron} / ${scoreCard.parOnByLongIronTry}",
                      ),
                      ScoreCardDataTile(
                        title: "LongIronパーオン率",
                        data:
                            "${(scoreCard.parOnByLongIron / scoreCard.parOnByLongIronTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "MiddleIronパーオン数",
                        data:
                            "${scoreCard.parOnByMiddleIron} / ${scoreCard.parOnByMiddleIronTry}",
                      ),
                      ScoreCardDataTile(
                        title: "MiddleIronパーオン率",
                        data:
                            "${(scoreCard.parOnByMiddleIron / scoreCard.parOnByMiddleIronTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ShortIronパーオン数",
                        data:
                            "${scoreCard.parOnByShortIron} / ${scoreCard.parOnByShortIronTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ShortIronパーオン率",
                        data:
                            "${(scoreCard.parOnByShortIron / scoreCard.parOnByShortIronTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "Wedgeパーオン数",
                        data:
                            "${scoreCard.parOnByWedge} / ${scoreCard.parOnByWedgeTry}",
                      ),
                      ScoreCardDataTile(
                        title: "Wedgeパーオン率",
                        data:
                            "${(scoreCard.parOnByWedge / scoreCard.parOnByWedgeTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "パットミス傾向分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "カップイン数",
                        data: "${scoreCard.puttHoleIn} / ${scoreCard.puttTry}",
                      ),
                      ScoreCardDataTile(
                        title: "カップイン率",
                        data:
                            "${(scoreCard.puttHoleIn / scoreCard.puttTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "左外し数",
                        data:
                            "${scoreCard.puttMissedLeft} / ${scoreCard.puttTry}",
                      ),
                      ScoreCardDataTile(
                        title: "左外し率",
                        data:
                            " ${(scoreCard.puttMissedLeft / scoreCard.puttTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "右外し数",
                        data:
                            "${scoreCard.puttMissedRight} / ${scoreCard.puttTry}",
                      ),
                      ScoreCardDataTile(
                        title: "右外し率",
                        data:
                            " ${(scoreCard.puttMissedRight / scoreCard.puttTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "パット距離分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "1m以内寄せ数",
                        data:
                            "${scoreCard.puttDistanceIn1m} / ${scoreCard.puttDistanceTry}",
                      ),
                      ScoreCardDataTile(
                        title: "1m以内寄せ率",
                        data:
                            "${(scoreCard.puttDistanceIn1m / scoreCard.puttDistanceTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ショート数",
                        data:
                            "${scoreCard.puttDistanceShort} / ${scoreCard.puttDistanceTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ショート率",
                        data:
                            "${(scoreCard.puttDistanceShort / scoreCard.puttDistanceTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ロング数",
                        data:
                            "${scoreCard.puttDistanceLong} / ${scoreCard.puttDistanceTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ロング率",
                        data:
                            "${(scoreCard.puttDistanceLong / scoreCard.puttDistanceTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "2.5m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "カップイン数",
                        data:
                            "${scoreCard.puttIn2and5mHoleIn} / ${scoreCard.puttIn2and5mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "カップイン率",
                        data:
                            "${(scoreCard.puttIn2and5mHoleIn / scoreCard.puttIn2and5mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "左外し数",
                        data:
                            "${scoreCard.puttIn2and5mMissedLeft} / ${scoreCard.puttIn2and5mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "左外し率",
                        data:
                            "${(scoreCard.puttIn2and5mMissedLeft / scoreCard.puttIn2and5mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "右外し数",
                        data:
                            "${scoreCard.puttIn2and5mMissedRight} / ${scoreCard.puttIn2and5mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "右外し率",
                        data:
                            "${(scoreCard.puttIn2and5mMissedRight / scoreCard.puttIn2and5mTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "5m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "カップイン数",
                        data:
                            "${scoreCard.puttIn5mHoleIn} / ${scoreCard.puttIn5mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "カップイン率",
                        data:
                            "${(scoreCard.puttIn5mHoleIn / scoreCard.puttIn5mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "左外し数",
                        data:
                            "${scoreCard.puttIn5mMissedLeft} / ${scoreCard.puttIn5mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "左外し率",
                        data:
                            "${(scoreCard.puttIn5mMissedLeft / scoreCard.puttIn5mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "右外し数",
                        data:
                            "${scoreCard.puttIn5mMissedRight} / ${scoreCard.puttIn5mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "右外し率",
                        data:
                            "${(scoreCard.puttIn5mMissedRight / scoreCard.puttIn5mTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "10m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "カップイン数",
                        data:
                            "${scoreCard.puttIn10mHoleIn} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "カップイン率",
                        data:
                            "${(scoreCard.puttIn10mHoleIn / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "左外し数",
                        data:
                            "${scoreCard.puttIn10mMissedLeft} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "左外し率",
                        data:
                            "${(scoreCard.puttIn10mMissedLeft / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "右外し数",
                        data:
                            "${scoreCard.puttIn10mMissedRight} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "右外し率",
                        data:
                            "${(scoreCard.puttIn10mMissedRight / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "1m以内寄せ数",
                        data:
                            "${scoreCard.puttIn10mJustTouch} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "1m以内寄せ率",
                        data:
                            "${(scoreCard.puttIn10mJustTouch / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ショート数",
                        data:
                            "${scoreCard.puttIn10mMissedShort} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ショート率",
                        data:
                            "${(scoreCard.puttIn10mMissedShort / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ロング数",
                        data:
                            "${scoreCard.puttIn10mMissedLong} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ロング率",
                        data:
                            "${(scoreCard.puttIn10mMissedLong / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "2パット以下数",
                        data:
                            "${scoreCard.puttIn10mTwoPutt} / ${scoreCard.puttIn10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "2パット以下率",
                        data:
                            "${(scoreCard.puttIn10mTwoPutt / scoreCard.puttIn10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "10m以上パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "カップイン数",
                        data:
                            "${scoreCard.puttInOver10mHoleIn} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "カップイン率",
                        data:
                            "${(scoreCard.puttInOver10mHoleIn / scoreCard.puttInOver10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "左外し数",
                        data:
                            "${scoreCard.puttInOver10mMissedLeft} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "左外し率",
                        data:
                            "${(scoreCard.puttInOver10mMissedLeft / scoreCard.puttInOver10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "右外し数",
                        data:
                            "${scoreCard.puttInOver10mMissedRight} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "右外し率",
                        data:
                            "${(scoreCard.puttInOver10mMissedRight / scoreCard.puttInOver10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "1m以内寄せ数",
                        data:
                            "${scoreCard.puttInOver10mJustTouch} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "1m以内寄せ率",
                        data:
                            "${(scoreCard.puttInOver10mJustTouch / scoreCard.puttInOver10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ショート数",
                        data:
                            "${scoreCard.puttInOver10mMissedShort} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ショート率",
                        data:
                            "${(scoreCard.puttInOver10mMissedShort / scoreCard.puttInOver10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "ロング数",
                        data:
                            "${scoreCard.puttInOver10mMissedLong} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "ロング率",
                        data:
                            "${(scoreCard.birdieChanceSuccess / scoreCard.birdieChanceCount * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "2パット以下",
                        data:
                            "${scoreCard.puttInOver10mTwoPutt} / ${scoreCard.puttInOver10mTry}",
                      ),
                      ScoreCardDataTile(
                        title: "2パット以下率",
                        data:
                            "${(scoreCard.puttInOver10mTwoPutt / scoreCard.puttInOver10mTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "アプローチ分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "パーセーブ数",
                        data:
                            "${scoreCard.approachParSave} / ${scoreCard.approachTry}",
                      ),
                      ScoreCardDataTile(
                        title: "パーセーブ率",
                        data:
                            "${(scoreCard.approachParSave / scoreCard.approachTry * 100).toStringAsFixed(1)}%",
                      ),
                      ScoreCardDataTile(
                        title: "チップイン数",
                        data:
                            "${scoreCard.approachChipIn} / ${scoreCard.approachTry}",
                      ),
                      const Gap(20),
                      const Text(
                        "バンカー分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "バンカーセーブ数",
                        data:
                            "${scoreCard.bunkerParSave} / ${scoreCard.bunkerTry}",
                      ),
                      ScoreCardDataTile(
                        title: "バンカーセーブ率",
                        data:
                            "${(scoreCard.bunkerParSave / scoreCard.bunkerTry * 100).toStringAsFixed(1)}%",
                      ),
                      const Gap(20),
                      const Text(
                        "バーディーチャンス分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "*Par5での2onによるバーディチャンスは除外",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const Gap(10),
                      ScoreCardDataTile(
                        title: "バーディチャンス",
                        subtitle: "(5m以内バーディパット)",
                        data: "${scoreCard.birdieChanceCount}",
                      ),
                      ScoreCardDataTile(
                        title: "バーディチャンス時ホールイン数",
                        data: "${scoreCard.birdieChanceSuccess}",
                      ),
                      ScoreCardDataTile(
                        title: "バーディチャンス成功率",
                        data:
                            "${(scoreCard.birdieChanceSuccess / scoreCard.birdieChanceCount * 100).toStringAsFixed(1)}%",
                      ),
                      const Text(
                        "ミス分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "100ヤード以内でグリーンを外した数",
                        data:
                            "${scoreCard.greenInRegulationIn50Try + scoreCard.greenInRegulationIn100Try - scoreCard.greenInRegulationIn50 - scoreCard.greenInRegulationIn100}",
                      ),
                      ScoreCardDataTile(
                        title: "3パット以上した数",
                        data: "${scoreCard.missedOverThreePutts}",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンサイドバンカーに入れた数",
                        data: "${scoreCard.missedIntoBunker}",
                      ),
                      ScoreCardDataTile(
                        title: "OBした数",
                        data: "${scoreCard.missedIntoOB}",
                      ),
                      ScoreCardDataTile(
                        title: "池に入れた数",
                        data: "${scoreCard.missedIntoWater}",
                      ),
                      ScoreCardDataTile(
                        title: "ペナルティ数",
                        data: "${scoreCard.missedGetPenalty}",
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
