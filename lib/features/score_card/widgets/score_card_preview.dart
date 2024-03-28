import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';
import 'package:golfbu_kun/features/score_card/models/scroe_card_courses_model.dart';

class ScoreCardPreview extends ConsumerStatefulWidget {
  const ScoreCardPreview({
    super.key,
    required this.scorecard,
    required this.course,
    required this.date,
    required this.weather,
    required this.wind,
    required this.temperature,
  });
  final ScoreCardModel scorecard;
  final ScoreCardcourseModel course;
  final String date;
  final String weather;
  final int wind;
  final String temperature;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardPreviewState();
}

class _ScoreCardPreviewState extends ConsumerState<ScoreCardPreview> {
  int outTotalScroe = 0;
  int outTotalPutt = 0;
  int inTotalScroe = 0;
  int inTotalPutt = 0;

  @override
  Widget build(BuildContext context) {
    final scorecard = widget.scorecard.scorecard;
    final course = widget.course;

    for (int i = 1; i <= 9; i++) {
      outTotalScroe +=
          int.parse(widget.scorecard.scorecard['hole$i']?['stroke'] ?? '0');
      outTotalPutt +=
          int.parse(widget.scorecard.scorecard['hole$i']?['putt'] ?? '0');
    }
    for (int i = 10; i <= 18; i++) {
      inTotalScroe +=
          int.parse(widget.scorecard.scorecard['hole$i']?['stroke'] ?? '0');
      inTotalPutt +=
          int.parse(widget.scorecard.scorecard['hole$i']?['putt'] ?? '0');
    }

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

    int puttRemainedCount =
        puttRemained.where((putt) => putt.isNotEmpty).length;
    int teeShotClubCount = teeShotClub.where((shot) => shot.isNotEmpty).length;
    int teeShotResultCount = teeShotResult
        .where((shot) =>
            shot.isNotEmpty &&
            shot != 'greenOn' &&
            shot != 'greenOver' &&
            shot != 'greenShort' &&
            shot != 'greenLeft' &&
            shot != 'greenRight')
        .length;

    int parThreeTeeShotCount = teeShotResult
        .where((shot) =>
            shot.isNotEmpty &&
            (shot == 'greenOn' ||
                shot == 'greenOver' ||
                shot == 'greenShort' ||
                shot == 'greenLeft' ||
                shot == 'greenRight'))
        .length;

    print(parThreeTeeShotCount);
    int parOnShotDistanceCount =
        parOnShotDistance.where((shot) => shot.isNotEmpty).length;
    int guardBunkerCount = guardBunker.where((shot) => shot).length;
    int obCount = ob.where((shot) => shot.isNotEmpty).length;
    int hazardCount = hazard.where((shot) => shot.isNotEmpty).length;
    int penaltyCount = penalty.where((shot) => shot.isNotEmpty).length;

    double widthAndHeight = MediaQuery.of(context).size.width / 10;
    double totalScoreWidth = MediaQuery.of(context).size.width / 6;
    double totalScoreHeight = 100;

    // スコア分析
    int overBogeyCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      if (stroke - course.parValues[i - 1] >= 2) {
        overBogeyCount += 1;
      }
    }
    int bogeyCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      if (stroke - course.parValues[i - 1] == 1) {
        bogeyCount += 1;
      }
    }

    int parCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      if (stroke - course.parValues[i - 1] == 0) {
        parCount += 1;
      }
    }

    int birdieCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      if (stroke - course.parValues[i - 1] == -1) {
        birdieCount += 1;
      }
    }
    int underBirdieCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      if (stroke - course.parValues[i - 1] <= -2) {
        underBirdieCount += 1;
      }
    }

    int par3Count = 0;
    int par3TotalScore = 0;
    for (int i = 1; i <= 18; i++) {
      if (course.parValues[i - 1] == 3) {
        par3Count += 1;
        par3TotalScore += int.parse(scorecard['hole$i']?['stroke']);
      }
    }
    double par3AverageScore = par3TotalScore / par3Count;

    int par4Count = 0;
    int par4TotalScore = 0;
    for (int i = 1; i <= 18; i++) {
      if (course.parValues[i - 1] == 4) {
        par4Count += 1;
        par4TotalScore += int.parse(scorecard['hole$i']?['stroke']);
      }
    }
    double par4AverageScore = par4TotalScore / par4Count;

    int par5Count = 0;
    int par5TotalScore = 0;
    for (int i = 1; i <= 18; i++) {
      if (course.parValues[i - 1] == 5) {
        par5Count += 1;
        par5TotalScore += int.parse(scorecard['hole$i']?['stroke']);
      }
    }
    double par5AverageScore = par5TotalScore / par5Count;

    // teeShot分析
    int teeShotFairwayCount =
        teeShotResult.where((shot) => shot == 'fw').length;
    int teeShotLeftCount = teeShotResult.where((shot) => shot == 'left').length;
    int teeShotRightCount =
        teeShotResult.where((shot) => shot == 'right').length;
    int teeShotCriticalMissCount = teeShotResult
        .where((shot) =>
            shot == 'chipping' ||
            shot == 'top' ||
            shot == 'tenpura' ||
            shot == 'duff')
        .length;

    double teeShotFairwayPercentage =
        (teeShotFairwayCount / teeShotResultCount) * 100;
    double teeShotLeftPercentage =
        (teeShotLeftCount / teeShotResultCount) * 100;
    double teeShotRightPercentage =
        (teeShotRightCount / teeShotResultCount) * 100;
    double teeShotCriticalMissPercentage =
        (teeShotCriticalMissCount / teeShotResultCount) * 100;

    // パット分析

    int puttMissedCount = puttMissed.where((putt) => putt.isNotEmpty).length;
    int puttLeftCount = puttMissed.where((putt) => putt == 'left').length;
    int puttRightCount = puttMissed.where((putt) => putt == 'right').length;
    int puttNoMissCount = puttMissed.where((putt) => putt == 'nomiss').length;
    int puttOverThreePutt = 0;

    double puttLeftPercentage = (puttLeftCount / puttMissedCount) * 100;
    double puttRightPercentage = (puttRightCount / puttMissedCount) * 100;
    double puttNoMissPercentage = (puttNoMissCount / puttMissedCount) * 100;

    List<String> puttDistance = [];
    for (int i = 1; i <= 18; i++) {
      String putt = widget.scorecard.scorecard['hole$i']?['puttDistance'];
      puttDistance.add(putt);
    }

    int puttDistanceCount =
        puttDistance.where((putt) => putt.isNotEmpty).length;
    int puttDistancePinCount =
        puttDistance.where((putt) => putt == 'nomiss').length;
    int puttDistanceShortCount =
        puttDistance.where((putt) => putt == 'short').length;
    int puttDistanceLongCount =
        puttDistance.where((putt) => putt == 'long').length;

    double puttDistancePinPercentage =
        (puttDistancePinCount / puttDistanceCount) * 100;
    double puttDistanceShortPercentage =
        (puttDistanceShortCount / puttDistanceCount) * 100;
    double puttDistanceLongPercentage =
        (puttDistanceLongCount / puttDistanceCount) * 100;

// 2.5m以内パット分析
    int puttInAPinCount = 0;
    int puttInAPinCupInCount = 0;
    int puttInAPinLeftMissCount = 0;
    int puttInAPinRightMissCount = 0;

// 5m 以内パット分析
    int puttInShortCount = 0;
    int puttInShortCupInCount = 0;
    int puttInShortLeftMissCount = 0;
    int puttInShortRightMissCount = 0;

// 10m 以内パット分析

    int puttInMiddleCount = 0;
    int puttInMiddleCupInCount = 0;
    int puttInMiddleLeftMissCount = 0;
    int puttInMiddleRightMissCount = 0;

    int puttInMiddleWellCount = 0;
    int puttInMiddleShortCount = 0;
    int puttInMiddleLongCount = 0;
    int puttInMiddleTwoPuttCount = 0;

// 10m 以上パット分析
    int puttInLongCount = 0;
    int puttInLongCupInCount = 0;
    int puttInLongLeftMissCount = 0;
    int puttInLongRightMissCount = 0;

    int puttInLongWellCount = 0;
    int puttInLongShortCount = 0;
    int puttInLongLongCount = 0;
    int puttInLongTwoPuttCount = 0;

    for (int i = 1; i <= 18; i++) {
      int putt = int.parse(scorecard['hole$i']?['putt']);
      if (putt >= 3) {
        puttOverThreePutt += 1;
      }
      if (scorecard['hole$i']?['puttRemained'] == 'pin') {
        puttInAPinCount += 1;
        if (scorecard['hole$i']?['puttMissed'] == 'nomiss') {
          puttInAPinCupInCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'left') {
          puttInAPinLeftMissCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'right') {
          puttInAPinRightMissCount += 1;
        }
      }
      if (scorecard['hole$i']?['puttRemained'] == 'short') {
        puttInShortCount += 1;
        if (scorecard['hole$i']?['puttMissed'] == 'nomiss') {
          puttInShortCupInCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'left') {
          puttInShortLeftMissCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'right') {
          puttInShortRightMissCount += 1;
        }
      }
      if (scorecard['hole$i']?['puttRemained'] == 'middle') {
        puttInMiddleCount += 1;
        if (scorecard['hole$i']?['puttMissed'] == 'nomiss') {
          puttInMiddleCupInCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'left') {
          puttInMiddleLeftMissCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'right') {
          puttInMiddleRightMissCount += 1;
        }
        if (scorecard['hole$i']?['puttDistance'] == 'nomiss') {
          puttInMiddleWellCount += 1;
        }
        if (scorecard['hole$i']?['puttDistance'] == 'short') {
          puttInMiddleShortCount += 1;
        }
        if (scorecard['hole$i']?['puttDistance'] == 'long') {
          puttInMiddleLongCount += 1;
        }
        if (putt <= 2) {
          puttInMiddleTwoPuttCount += 1;
        }
      }
      if (scorecard['hole$i']?['puttRemained'] == 'long') {
        puttInLongCount += 1;
        if (scorecard['hole$i']?['puttMissed'] == 'nomiss') {
          puttInLongCupInCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'left') {
          puttInLongLeftMissCount += 1;
        }
        if (scorecard['hole$i']?['puttMissed'] == 'right') {
          puttInLongRightMissCount += 1;
        }
        if (scorecard['hole$i']?['puttDistance'] == 'nomiss') {
          puttInLongWellCount += 1;
        }
        if (scorecard['hole$i']?['puttDistance'] == 'short') {
          puttInLongShortCount += 1;
        }
        if (scorecard['hole$i']?['puttDistance'] == 'long') {
          puttInLongLongCount += 1;
        }
        if (putt <= 2) {
          puttInLongTwoPuttCount += 1;
        }
      }
    }

    double puttInAPinCupInPercentage =
        (puttInAPinCupInCount / puttInAPinCount) * 100;
    double puttInAPinLeftMissPercentage =
        (puttInAPinLeftMissCount / puttInAPinCount) * 100;
    double puttInAPinRightMissPercentage =
        (puttInAPinRightMissCount / puttInAPinCount) * 100;

    double puttInShortCupInPercentage =
        (puttInShortCupInCount / puttInShortCount) * 100;
    double puttInShortLeftMissPercentage =
        (puttInShortLeftMissCount / puttInShortCount) * 100;
    double puttInShortRightMissPercentage =
        (puttInShortRightMissCount / puttInShortCount) * 100;

    double puttInMiddleCupInPercentage =
        (puttInMiddleCupInCount / puttInMiddleCount) * 100;
    double puttInMiddleLeftMissPercentage =
        (puttInMiddleLeftMissCount / puttInMiddleCount) * 100;
    double puttInMiddleRightMissPercentage =
        (puttInMiddleRightMissCount / puttInMiddleCount) * 100;
    double puttInMiddleWellPercentage =
        (puttInMiddleWellCount / puttInMiddleCount) * 100;
    double puttInMiddleShortPercentage =
        (puttInMiddleShortCount / puttInMiddleCount) * 100;
    double puttInMiddleLongPercentage =
        (puttInMiddleLongCount / puttInMiddleCount) * 100;
    double puttInMiddleTwoPutPercentage =
        (puttInMiddleTwoPuttCount / puttInMiddleCount) * 100;

    double puttInLongCupInPercentage =
        (puttInLongCupInCount / puttInLongCount) * 100;
    double puttInLongLeftMissPercentage =
        (puttInLongLeftMissCount / puttInLongCount) * 100;
    double puttInLongRightMissPercentage =
        (puttInLongRightMissCount / puttInLongCount) * 100;
    double puttInLongWellPercentage =
        (puttInLongWellCount / puttInLongCount) * 100;
    double puttInLongShortPercentage =
        (puttInLongShortCount / puttInLongCount) * 100;
    double puttInLongLongPercentage =
        (puttInLongLongCount / puttInLongCount) * 100;
    double puttInLongTwoPutPercentage =
        (puttInLongTwoPuttCount / puttInLongCount) * 100;

    //パーオン分析
    int parOnCount = 0;
    int parOnUnder50Count = 0;
    int parOnUder50OnGreenCount = 0;
    int parOnUnder100Count = 0;
    int parOnUnder100OnGreenCount = 0;
    int parOnUnder150Count = 0;
    int parOnUnder150OnGreenCount = 0;
    int parOnUnder200Count = 0;
    int parOnUnder200OnGreenCount = 0;
    int parOnOver200Count = 0;
    int parOnOver200OnGreenCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      int putt = int.parse(scorecard['hole$i']?['putt']);
      if (stroke - putt <= course.parValues[i - 1] - 2) {
        parOnCount += 1;
        if (scorecard['hole$i']?['parOnShotDistance'] != null &&
            scorecard['hole$i']?['parOnShotDistance'].isNotEmpty) {
          int parOnShotDistance =
              int.parse(scorecard['hole$i']?['parOnShotDistance']);

          if (parOnShotDistance < 50) {
            parOnUnder50Count += 1;
          }
          if (parOnShotDistance >= 50 && parOnShotDistance < 100) {
            parOnUnder100Count += 1;
          }
          if (parOnShotDistance >= 100 && parOnShotDistance < 150) {
            parOnUnder150Count += 1;
          }
          if (parOnShotDistance >= 150 && parOnShotDistance < 200) {
            parOnUnder200Count += 1;
          }
          if (parOnShotDistance >= 200) {
            parOnOver200Count += 1;
          }
        }
      }
    }
    // アプローチ分析
    int approachCount = 0;
    int approachParSaveCount = 0;
    int approachChipInCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      int putt = int.parse(scorecard['hole$i']?['putt']);
      if (!guardBunker[i - 1]) if (putt == 1) {
        approachCount += 1;
        if (stroke == course.parValues[i - 1]) {
          approachParSaveCount += 1;
        }
      }
      if (putt == 0) {
        approachCount += 1;
        approachChipInCount += 1;
      }
    }
    //バンカー分析
    int bunkerCount = 0;
    int bunkerParSaveCount = 0;
    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      if (guardBunker[i - 1]) {
        bunkerCount += 1;
        if (stroke == course.parValues[i - 1]) {
          bunkerParSaveCount += 1;
        }
      }
    }

    // バーディーチャンス分析
    int birdieChanceCount = 0;
    int birdieChanceHoleInCount = 0;

    for (int i = 1; i <= 18; i++) {
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      int putt = int.parse(scorecard['hole$i']?['putt']);
      if (stroke - putt <= course.parValues[i - 1] - 2) {
        if (scorecard['hole$i']?['puttRemained'] == 'pin' ||
            scorecard['hole$i']?['puttRemained'] == 'short') {
          birdieChanceCount += 1;
          if (stroke < course.parValues[i - 1]) {
            birdieChanceHoleInCount += 1;
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("スコアカード"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "コース名: ${widget.course.courseName}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "日付: ${widget.date}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
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
                                                widget
                                                    .course.parValues[i - 1]) >
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
                                                widget
                                                    .course.parValues[i - 1]) >
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
                            "${inTotalPutt + outTotalPutt}",
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
                    Text("天気: ${widget.weather}"),
                    Text("最大風速: ${widget.wind}m/s"),
                    Text("気温: ${widget.temperature}"),
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
                      ListTile(
                        tileColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: const Text(
                          "ダブルボギー以上の数:",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          "$overBogeyCount",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Text("ダブルボギー以上の数: $overBogeyCount"),
                      Text("ボギーの数: $bogeyCount"),
                      Text("パーの数: $parCount"),
                      Text("バーディの数: $birdieCount"),
                      Text("イーグル以下の数: $underBirdieCount"),
                      Text("Par3平均スコア: $par3AverageScore"),
                      Text("Par4平均スコア: $par4AverageScore"),
                      Text("Par5平均スコア: $par5AverageScore"),
                      const Gap(20),
                      const Text(
                        "ティーショット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "フェアウェイキープ: $teeShotFairwayCount / $teeShotResultCount"),
                      Text("フェアウェイキープ率: $teeShotFairwayPercentage%"),
                      Text(
                          "フェアウェイより左に外れた数: $teeShotLeftCount / $teeShotResultCount"),
                      Text("フェアウェイより左に外れる確率: $teeShotLeftPercentage%"),
                      Text(
                          "フェアウェイより右に外れた数: $teeShotRightCount / $teeShotResultCount"),
                      Text("フェアウェイより右に外れる確率: $teeShotRightPercentage%"),
                      Text(
                          "ティーショットクリティカルミス: $teeShotCriticalMissCount / $teeShotResultCount"),
                      Text("ティーショットクリティカルミス率: $teeShotCriticalMissPercentage%"),
                      const Gap(20),
                      const Text(
                        "パーオン分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("パーオン $parOnCount / 18ホール"),
                      Text("パーオン率: ${parOnCount / 18 * 100}%"),
                      const Gap(20),
                      const Text(
                        "パーオン距離別分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "50ヤード以内パーオン数: $parOnUder50OnGreenCount / $parOnUnder50Count"),
                      Text(
                          "50ヤード以内パーオン率: ${parOnUder50OnGreenCount / parOnUnder50Count * 100}%"),
                      Text(
                          "100ヤード以内パーオン数: $parOnUnder100OnGreenCount / $parOnUnder100Count"),
                      Text(
                          "100ヤード以内パーオン率: ${parOnUnder100OnGreenCount / parOnUnder100Count * 100}%"),
                      Text(
                          "150ヤード以内パーオン数: $parOnUnder150OnGreenCount / $parOnUnder150Count"),
                      Text(
                          "150ヤード以内パーオン率: ${parOnUnder150OnGreenCount / parOnUnder150Count * 100}%"),
                      Text(
                          "200ヤード以内パーオン数: $parOnUnder200OnGreenCount / $parOnUnder200Count"),
                      Text(
                          "200ヤード以内パーオン率: ${parOnUnder200OnGreenCount / parOnUnder200Count * 100}%"),
                      Text(
                          "200ヤード以上パーオン数: $parOnOver200OnGreenCount / $parOnOver200Count"),
                      Text(
                          "200ヤード以上パーオン率: ${parOnOver200OnGreenCount / parOnOver200Count * 100}%"),
                      const Gap(20),
                      const Text(
                        "パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("カップイン数: $puttNoMissCount / $puttMissedCount"),
                      Text(
                        "カップイン:$puttNoMissPercentage%",
                      ),
                      Text("左外し数: $puttLeftCount / $puttMissedCount"),
                      Text("左外し率:$puttLeftPercentage%"),
                      Text("右外し数: $puttRightCount / $puttMissedCount"),
                      Text("右外し率:$puttRightPercentage%"),
                      const Gap(20),
                      const Text(
                        "パット距離分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "1m以内寄せ数: $puttDistancePinCount / $puttDistanceCount"),
                      Text("1m以内寄せ率: $puttDistancePinPercentage%"),
                      Text(
                          "ショート数: $puttDistanceShortCount / $puttDistanceCount"),
                      Text("ショート率: $puttDistanceShortPercentage%"),
                      Text("ロング数: $puttDistanceLongCount / $puttDistanceCount"),
                      Text("ロング率: $puttDistanceLongPercentage%"),
                      const Gap(20),
                      const Text(
                        "2.5m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("カップイン数: $puttInAPinCupInCount / $puttInAPinCount"),
                      Text("カップイン率: $puttInAPinCupInPercentage%"),
                      Text("左外し数: $puttInAPinLeftMissCount / $puttInAPinCount"),
                      Text("左外し率: $puttInAPinLeftMissPercentage%"),
                      Text(
                          "右外し数: $puttInAPinRightMissCount / $puttInAPinCount"),
                      Text("右外し率: $puttInAPinRightMissPercentage%"),
                      const Gap(20),
                      const Text(
                        "5m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "カップイン数: $puttInShortCupInCount / $puttInShortCount"),
                      Text("カップイン率: $puttInShortCupInPercentage%"),
                      Text(
                          "左外し数: $puttInShortLeftMissCount / $puttInShortCount"),
                      Text("左外し率: $puttInShortLeftMissPercentage%"),
                      Text(
                          "右外し数: $puttInShortRightMissCount / $puttInShortCount"),
                      Text("右外し率: $puttInShortRightMissPercentage%"),
                      const Gap(20),
                      const Text(
                        "10m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "カップイン数: $puttInMiddleCupInCount / $puttInMiddleCount"),
                      Text("カップイン率: $puttInMiddleCupInPercentage%"),
                      Text(
                          "左外し数: $puttInMiddleLeftMissCount / $puttInMiddleCount"),
                      Text("左外し率: $puttInMiddleLeftMissPercentage%"),
                      Text(
                          "右外し数: $puttInMiddleRightMissCount / $puttInMiddleCount"),
                      Text("右外し率: $puttInMiddleRightMissPercentage%"),
                      Text(
                          "1m以内寄せ数: $puttInMiddleWellCount / $puttInMiddleCount"),
                      Text("1m以内寄せ率: $puttInMiddleWellPercentage%"),
                      Text(
                          "ショート数: $puttInMiddleShortCount / $puttInMiddleCount"),
                      Text("ショート率: $puttInMiddleShortPercentage%"),
                      Text("ロング数: $puttInMiddleLongCount / $puttInMiddleCount"),
                      Text("ロング率: $puttInMiddleLongPercentage%"),
                      Text(
                          "2パット以下数: $puttInMiddleTwoPuttCount / $puttInMiddleCount"),
                      Text("2パット以下率: $puttInMiddleTwoPutPercentage%"),
                      const Gap(20),
                      const Text(
                        "10m以上パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("カップイン数: $puttInLongCupInCount / $puttInLongCount"),
                      Text("カップイン率: $puttInLongCupInPercentage%"),
                      Text("左外し数: $puttInLongLeftMissCount / $puttInLongCount"),
                      Text("左外し率: $puttInLongLeftMissPercentage%"),
                      Text(
                          "右外し数: $puttInLongRightMissCount / $puttInLongCount"),
                      Text("右外し率: $puttInLongRightMissPercentage%"),
                      Text("1m以内寄せ数: $puttInLongWellCount / $puttInLongCount"),
                      Text("1m以内寄せ率: $puttInLongWellPercentage%"),
                      Text("ショート数: $puttInLongShortCount / $puttInLongCount"),
                      Text("ショート率: $puttInLongShortPercentage%"),
                      Text("ロング数: $puttInLongLongCount / $puttInLongCount"),
                      Text("ロング率: $puttInLongLongPercentage%"),
                      Text(
                          "2パット以下: $puttInLongTwoPuttCount / $puttInLongCount"),
                      Text("2パット以下率: $puttInLongTwoPutPercentage%"),
                      const Gap(20),
                      const Text(
                        "アプローチ分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("アプローチセーブ数: $approachParSaveCount / $approachCount"),
                      Text(
                          "アプローチセーブ率: ${approachParSaveCount / approachCount * 100}%"),
                      Text("チップイン数: $approachChipInCount / $approachCount"),
                      Text(
                          "チップイン率: ${approachChipInCount / approachCount * 100}%"),
                      const Gap(20),
                      const Text(
                        "バンカー分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("バンカーセーブ数: $bunkerParSaveCount / $bunkerCount"),
                      Text(
                          "バンカーセーブ率: ${bunkerParSaveCount / bunkerCount * 100}%"),
                      const Gap(20),
                      const Text(
                        "バーディーチャンス分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("バーディチャンス $birdieChanceCount / 18ホール(5m以内バーディパット)"),
                      Text("バーディチャンス率: ${birdieChanceCount / 18 * 100}%"),
                      Text(
                          "バーディチャンス時ホールイン数: $birdieChanceHoleInCount / $birdieChanceCount"),
                      Text(
                          "バーディチャンス成功率: ${birdieChanceHoleInCount / birdieChanceCount * 100}%"),
                      const Text(
                        "ミス分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "100ヤード以内でグリーンを外した数: ${parOnUnder50Count + parOnUnder100Count - parOnUder50OnGreenCount - parOnUnder100OnGreenCount}"),
                      Text("3パット以上した数: $puttOverThreePutt"),
                      Text("グリーンサイドバンカーに入れた数: $bunkerCount"),
                      Text("OBした数: $obCount"),
                      Text("池に入れた数: $hazardCount"),
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
