import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';
import 'package:golfbu_kun/features/score_card/models/scroe_card_courses_model.dart';

class ScoreCardPreview extends ConsumerStatefulWidget {
  const ScoreCardPreview({
    super.key,
    required this.scorecard,
    required this.course,
  });
  final ScoreCardModel scorecard;
  final ScoreCardcourseModel course;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardPreviewState();
}

class _ScoreCardPreviewState extends ConsumerState<ScoreCardPreview> {
  int outTotalScroe = 0;
  int inTotalScroe = 0;

  @override
  Widget build(BuildContext context) {
    final scorecard = widget.scorecard.scorecard;
    final course = widget.course;

    List<String> puttRemained = [];
    for (int i = 1; i <= 18; i++) {
      String putt = widget.scorecard.scorecard['hole$i']?['puttRemained'];
      puttRemained.add(putt);
    }

    List<String> puttMissed = [];
    for (int i = 1; i <= 18; i++) {
      String putt = widget.scorecard.scorecard['hole$i']?['puttMissed'];
      puttMissed.add(putt);
    }

    int puttMissedCount = puttMissed.where((putt) => putt.isNotEmpty).length;
    int leftCount = puttMissed.where((putt) => putt == 'left').length;
    int rightCount = puttMissed.where((putt) => putt == 'right').length;
    int noMissCount = puttMissed.where((putt) => putt == 'nomiss').length;

    double leftPercentage = (leftCount / puttMissedCount) * 100;
    double rightPercentage = (rightCount / puttMissedCount) * 100;
    double noMissPercentage = (noMissCount / puttMissedCount) * 100;

    List<String> puttDistance = [];
    for (int i = 1; i <= 18; i++) {
      String putt = widget.scorecard.scorecard['hole$i']?['puttDistance'];
      puttDistance.add(putt);
    }

    List<String> teeShotClub = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['teeShotClub'];
      teeShotClub.add(shot);
    }

    List<String> teeShotResult = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['teeShotResult'];
      teeShotResult.add(shot);
    }

    List<String> parOnShotDistance = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['parOnShotDistance'];
      parOnShotDistance.add(shot);
    }
    List<String> parOnShotClub = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['parOnShotClub'];
      parOnShotClub.add(shot);
    }
    List<bool> guardBunker = [];
    for (int i = 1; i <= 18; i++) {
      bool? shot = widget.scorecard.scorecard['hole$i']?['guardBunker'];
      shot ??= false;
      guardBunker.add(shot);
    }

    List<String> ob = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['ob'];
      ob.add(shot);
    }

    List<String> hazard = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['hazard'];
      hazard.add(shot);
    }
    List<String> penalty = [];
    for (int i = 1; i <= 18; i++) {
      String shot = widget.scorecard.scorecard['hole$i']?['penalty'];
      penalty.add(shot);
    }

    for (int i = 1; i <= 9; i++) {
      outTotalScroe +=
          int.parse(widget.scorecard.scorecard['hole$i']?['stroke'] ?? '0');
    }
    for (int i = 10; i <= 18; i++) {
      inTotalScroe +=
          int.parse(widget.scorecard.scorecard['hole$i']?['stroke'] ?? '0');
    }

    int puttRemainedCount =
        puttRemained.where((putt) => putt.isNotEmpty).length;
    int teeShotClubCount = teeShotClub.where((shot) => shot.isNotEmpty).length;
    int teeShotResultCount =
        teeShotResult.where((shot) => shot.isNotEmpty).length;
    int parOnShotDistanceCount =
        parOnShotDistance.where((shot) => shot.isNotEmpty).length;
    int guardBunkerCount = guardBunker.where((shot) => shot).length;
    int obCount = ob.where((shot) => shot.isNotEmpty).length;
    int hazardCount = hazard.where((shot) => shot.isNotEmpty).length;
    int penaltyCount = penalty.where((shot) => shot.isNotEmpty).length;

    double widthAndHeight = MediaQuery.of(context).size.width / 10;
    double totalScoreWidth = MediaQuery.of(context).size.width / 6;
    double totalScoreHeight = 100;
    int parOnCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      int putt = int.parse(scorecard['hole$i']?['putt']);
      if (stroke - putt <= course.parValues[i - 1] - 2) {
        parOnCount += 1;
      }
    }
    int birdieChanceCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      int putt = int.parse(scorecard['hole$i']?['putt']);
      if (stroke - putt <= course.parValues[i - 1] - 2) {
        if (scorecard['hole$i']?['puttRemained'] == 'pin' ||
            scorecard['hole$i']?['puttRemained'] == 'short') {
          birdieChanceCount += 1;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("スコアカード"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                  widget.course.parValues[i].toString(),
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
                          for (int i = 1; i <= 9; i++)
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: Center(
                                child: Text(
                                  (scorecard['hole$i']?['stroke']).toString(),
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
                          for (int i = 1; i <= 9; i++)
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: Center(
                                child: Text(
                                  (scorecard['hole$i']?['putt']).toString(),
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
                          for (int i = 1; i <= 9; i++)
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: Center(
                                child: Text(
                                  (int.parse(scorecard['hole$i']?['stroke'] ??
                                                  'null') -
                                              widget.course.parValues[i - 1]) >
                                          0
                                      ? "+${(int.parse(scorecard['hole$i']?['stroke'] ?? 'null') - widget.course.parValues[i - 1])}"
                                      : (int.parse(scorecard['hole$i']
                                                      ?['stroke'] ??
                                                  'null') -
                                              widget.course.parValues[i - 1])
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
                          for (int i = 10; i <= 18; i++)
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
                                  widget.course.parValues[i].toString(),
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
                          for (int i = 10; i <= 18; i++)
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: Center(
                                child: Text(
                                  (scorecard['hole$i']?['stroke']).toString(),
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
                          for (int i = 10; i <= 18; i++)
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: Center(
                                child: Text(
                                  (scorecard['hole$i']?['putt']).toString(),
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
                          for (int i = 10; i <= 18; i++)
                            Container(
                              width: widthAndHeight,
                              height: widthAndHeight,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade800),
                              child: Center(
                                child: Text(
                                  (int.parse(scorecard['hole$i']?['stroke'] ??
                                                  'null') -
                                              widget.course.parValues[i - 1]) >
                                          0
                                      ? "+${(int.parse(scorecard['hole$i']?['stroke'] ?? 'null') - widget.course.parValues[i - 1])}"
                                      : (int.parse(scorecard['hole$i']
                                                      ?['stroke'] ??
                                                  'null') -
                                              widget.course.parValues[i - 1])
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
                          "$outTotalScroe",
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
                          "$inTotalScroe",
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
                          "${inTotalScroe + outTotalScroe}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "パッとミスの傾向 \n左外し:$leftPercentage% \n右外し:$rightPercentage% \nカップイン:$noMissPercentage%",
                ),
                Text("パーオン $parOnCount / 18ホール"),
                Text("パーオン率:${" ${parOnCount / 18 * 100}".substring(0, 5)}%"),
                Text("バーディチャンス $birdieChanceCount / 18ホール(5m以内バーディパット)"),
                Text(
                    "バーディチャンス率: ${"${birdieChanceCount / 18 * 100}".substring(0, 5)}%"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
