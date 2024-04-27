import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_data_tile.dart';

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
  final ScoreCardCourseModel course;
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
  int totalScore = 0;
  int totalPutt = 0;
  bool isTapped = false;
  late final ProfileModel profile;

  Future<void> _onUploadScoreTap(
      ScoreCardDataModel scoreCardData, BuildContext context) async {
    await ref.read(scoreCardRepo).uploadScoreCard(scoreCardData: scoreCardData);
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "スコア登録を完了しました。",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey.shade900,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
    context.go("/score");
  }

  void _getProfile() async {
    profile = await ref.read(profileProvider.notifier).fetchProfile();
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final scorecard = widget.scorecard.scorecard;
    final course = widget.course;

    List<int> scoreList = [];
    List<int> puttList = [];
    List<int> parValueList = [];

    List<String> puttRemained = [];

    List<String> puttMissed = [];

    List<String> teeShotClub = [];

    List<String> teeShotResult = [];

    List<String> parOnShotDistance = [];

    List<String> parOnShotClub = [];

    List<bool> guardBunker = [];

    List<String> ob = [];

    List<String> hazard = [];

    List<String> penalty = [];

    int puttRemainedCount =
        puttRemained.where((putt) => putt.isNotEmpty).length;
    int teeShotClubCount = teeShotClub.where((shot) => shot.isNotEmpty).length;

    int parOnShotDistanceCount =
        parOnShotDistance.where((shot) => shot.isNotEmpty).length;

    double widthAndHeight = MediaQuery.of(context).size.width / 10;
    double totalScoreWidth = MediaQuery.of(context).size.width / 6;
    double totalScoreHeight = 100;

    // スコア分析
    int overBogeyCount = 0;

    int bogeyCount = 0;

    int parCount = 0;

    int birdieCount = 0;

    int underBirdieCount = 0;

    int par3Count = 0;
    int par3TotalScore = 0;

    int par4Count = 0;
    int par4TotalScore = 0;

    int par5Count = 0;
    int par5TotalScore = 0;

    // teeShotResult分析

    //teeShot Club分析
    int teeShotDriverCount = 0;
    int teeShotDriverFwCount = 0;
    int teeShotWoodCount = 0;
    int teeShotWoodFwCount = 0;
    int teeShotUtCount = 0;
    int teeShotUtFwCount = 0;
    int teeShotIronCount = 0;
    int teeShotIronFwCount = 0;

    // Par3 TeeShot分析

    // パット分析

    int puttOverThreePutt = 0;

    List<String> puttDistance = [];

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

    int puttInMiddleJustTouchCount = 0;
    int puttInMiddleShortCount = 0;
    int puttInMiddleLongCount = 0;
    int puttInMiddleTwoPuttCount = 0;

// 10m 以上パット分析
    int puttInLongCount = 0;
    int puttInLongCupInCount = 0;
    int puttInLongLeftMissCount = 0;
    int puttInLongRightMissCount = 0;

    int puttInLongJustTouchCount = 0;
    int puttInLongShortCount = 0;
    int puttInLongLongCount = 0;
    int puttInLongTwoPuttCount = 0;

    //パーオン分析
    int parOnCount = 0;
    int parOnUnder50Count = 0;
    int parOnUnder50OnGreenCount = 0;
    int parOnUnder100Count = 0;
    int parOnUnder100OnGreenCount = 0;
    int parOnUnder150Count = 0;
    int parOnUnder150OnGreenCount = 0;
    int parOnUnder200Count = 0;
    int parOnUnder200OnGreenCount = 0;
    int parOnOver200Count = 0;
    int parOnOver200OnGreenCount = 0;

    // par on shot club 分析

    int parOnWoodCount = 0;
    int parOnUtCount = 0;
    int parOnLongIronCount = 0;
    int parOnMiddleIronCount = 0;
    int parOnShortIronCount = 0;
    int parOnWedgeCount = 0;

    // アプローチ分析
    int approachCount = 0;
    int approachParSaveCount = 0;
    int approachChipInCount = 0;

    //バンカー分析
    int bunkerCount = 0;
    int bunkerParSaveCount = 0;

    // バーディーチャンス分析
    int birdieChanceCount = 0;
    int birdieChanceHoleInCount = 0;

// 重複するForの処理をまとめる

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

    for (int i = 1; i <= 18; i++) {
      scoreList.add(int.parse(scorecard['hole$i']?['stroke']));
      puttList.add(int.parse(scorecard['hole$i']?['putt']));
      parValueList.add(course.parValues[i - 1]);

      String puttRemain = widget.scorecard.scorecard['hole$i']?['puttRemained'];
      String puttMissedCount =
          widget.scorecard.scorecard['hole$i']?['puttMissed'];
      puttRemained.add(puttRemain);
      puttMissed.add(puttMissedCount);

      String tClub = widget.scorecard.scorecard['hole$i']?['teeShotClub'];
      teeShotClub.add(tClub);

      String tShotResult =
          widget.scorecard.scorecard['hole$i']?['teeShotResult'];
      teeShotResult.add(tShotResult);

      String pShotDistance =
          widget.scorecard.scorecard['hole$i']?['parOnShotDistance'];
      parOnShotDistance.add(pShotDistance);

      String pShotClub = widget.scorecard.scorecard['hole$i']?['parOnShotClub'];
      parOnShotClub.add(pShotClub);

      bool? bunkerShot = widget.scorecard.scorecard['hole$i']?['guardBunker'];
      bunkerShot ??= false;
      guardBunker.add(bunkerShot);

      String obShot = widget.scorecard.scorecard['hole$i']?['ob'];
      ob.add(obShot);

      String hzShot = widget.scorecard.scorecard['hole$i']?['hazard'];
      hazard.add(hzShot);

      String penaltyShot = widget.scorecard.scorecard['hole$i']?['penalty'];
      penalty.add(penaltyShot);

      // stroke, putt, parOn, ParThree
      int stroke = int.parse(scorecard['hole$i']?['stroke']);
      int putt = int.parse(scorecard['hole$i']?['putt']);
      bool parThree = course.parValues[i - 1] == 3;
      bool parOn = stroke - putt <= course.parValues[i - 1] - 2;

      if (stroke - course.parValues[i - 1] >= 2) {
        overBogeyCount += 1;
      }
      if (stroke - course.parValues[i - 1] == 1) {
        bogeyCount += 1;
      }

      if (stroke - course.parValues[i - 1] == 0) {
        parCount += 1;
      }

      if (stroke - course.parValues[i - 1] == -1) {
        birdieCount += 1;
      }

      if (stroke - course.parValues[i - 1] <= -2) {
        underBirdieCount += 1;
      }

      if (course.parValues[i - 1] == 3) {
        par3Count += 1;
        par3TotalScore += int.parse(scorecard['hole$i']?['stroke']);
      }

      if (course.parValues[i - 1] == 4) {
        par4Count += 1;
        par4TotalScore += int.parse(scorecard['hole$i']?['stroke']);
      }

      if (course.parValues[i - 1] == 5) {
        par5Count += 1;
        par5TotalScore += int.parse(scorecard['hole$i']?['stroke']);
      }

      if (course.parValues[i - 1] != 3) {
        if (teeShotClub[i - 1] == 'driver') {
          teeShotDriverCount += 1;
          if (teeShotResult[i - 1] == 'fw') {
            teeShotDriverFwCount += 1;
          }
        }
        if (teeShotClub[i - 1] == 'wood') {
          teeShotWoodCount += 1;
          if (teeShotResult[i - 1] == 'fw') {
            teeShotWoodFwCount += 1;
          }
        }
        if (teeShotClub[i - 1] == 'ut') {
          teeShotUtCount += 1;
          if (teeShotResult[i - 1] == 'fw') {
            teeShotUtFwCount += 1;
          }
        }
        if (teeShotClub[i - 1] == 'longiron' ||
            teeShotClub[i - 1] == 'middleiron' ||
            teeShotClub[i - 1] == 'shortiron') {
          teeShotIronCount += 1;
          if (teeShotResult[i - 1] == 'fw') {
            teeShotIronFwCount += 1;
          }
        }
      }

      String puttTouch = widget.scorecard.scorecard['hole$i']?['puttDistance'];
      puttDistance.add(puttTouch);

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
          puttInMiddleJustTouchCount += 1;
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
          puttInLongJustTouchCount += 1;
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

      if (parOn) {
        parOnCount += 1;
      }

      if (scorecard['hole$i']?['parOnShotDistance'] != null &&
          scorecard['hole$i']?['parOnShotDistance'].isNotEmpty) {
        int parOnShotDistance =
            int.parse(scorecard['hole$i']?['parOnShotDistance']);

        if (parOnShotDistance < 50) {
          parOnUnder50Count += 1;
          if (parOn) {
            parOnUnder50OnGreenCount += 1;
          }
        }
        if (parOnShotDistance >= 50 && parOnShotDistance < 100) {
          parOnUnder100Count += 1;
          if (parOn) {
            parOnUnder100OnGreenCount += 1;
          }
        }
        if (parOnShotDistance >= 100 && parOnShotDistance < 150) {
          parOnUnder150Count += 1;
          if (parOn) {
            parOnUnder150OnGreenCount += 1;
          }
        }
        if (parOnShotDistance >= 150 && parOnShotDistance < 200) {
          parOnUnder200Count += 1;
          if (parOn) {
            parOnUnder200OnGreenCount += 1;
          }
        }
        if (parOnShotDistance >= 200) {
          parOnOver200Count += 1;
          if (parOn) {
            parOnOver200OnGreenCount += 1;
          }
        }
      }

      if (parOn) {
        if (scorecard['hole$i']?['parOnShotClub'] == 'wood') {
          parOnWoodCount += 1;
        }
        if (scorecard['hole$i']?['parOnShotClub'] == 'ut') {
          parOnUtCount += 1;
        }
        if (scorecard['hole$i']?['parOnShotClub'] == 'longiron') {
          parOnLongIronCount += 1;
        }
        if (scorecard['hole$i']?['parOnShotClub'] == 'middleiron') {
          parOnMiddleIronCount += 1;
        }
        if (scorecard['hole$i']?['parOnShotClub'] == 'shortiron') {
          parOnShortIronCount += 1;
        }
        if (scorecard['hole$i']?['parOnShotClub'] == 'wedge') {
          parOnWedgeCount += 1;
        }
        if (parThree) {
          if (scorecard['hole$i']?['teeShotClub'] == 'wood') {
            parOnWoodCount += 1;
          }
          if (scorecard['hole$i']?['teeShotClub'] == 'ut') {
            parOnUtCount += 1;
          }
          if (scorecard['hole$i']?['teeShotClub'] == 'longiron') {
            parOnLongIronCount += 1;
          }
          if (scorecard['hole$i']?['teeShotClub'] == 'middleiron') {
            parOnMiddleIronCount += 1;
          }
          if (scorecard['hole$i']?['teeShotClub'] == 'shortiron') {
            parOnShortIronCount += 1;
          }
          if (scorecard['hole$i']?['teeShotClub'] == 'wedge') {
            parOnWedgeCount += 1;
          }
        }
      }

      if (putt == 1) {
        if (stroke == course.parValues[i - 1]) {
          approachCount += 1;
          approachParSaveCount += 1;
        }
      }
      if (putt == 0) {
        approachChipInCount += 1;
      }
      if (guardBunker[i - 1]) {
        bunkerCount += 1;
        if (stroke <= course.parValues[i - 1]) {
          bunkerParSaveCount += 1;
        }
      }

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

    int obCount = ob.where((shot) => shot.isNotEmpty).length;
    int hazardCount = hazard.where((shot) => shot.isNotEmpty).length;
    int penaltyCount = penalty.where((shot) => shot.isNotEmpty).length;
    int teeShotResultCount = teeShotResult
        .where((shot) =>
            shot.isNotEmpty &&
            shot != 'greenOn' &&
            shot != 'greenOver' &&
            shot != 'greenShort' &&
            shot != 'greenLeft' &&
            shot != 'greenRight')
        .length;
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
    int parThreeTeeShotCount = teeShotResult
        .where((shot) =>
            shot.isNotEmpty &&
            (shot == 'greenOn' ||
                shot == 'greenOver' ||
                shot == 'greenShort' ||
                shot == 'greenLeft' ||
                shot == 'greenRight'))
        .length;

    int parThreeTeeShotGreenOnCount = teeShotResult
        .where(
          (shot) => shot.isNotEmpty && (shot == 'greenOn'),
        )
        .length;
    int parThreeTeeShotGreenOverCount = teeShotResult
        .where(
          (shot) => shot.isNotEmpty && (shot == 'greenOver'),
        )
        .length;
    int parThreeTeeShotGreenShortCount = teeShotResult
        .where(
          (shot) => shot.isNotEmpty && (shot == 'greenShort'),
        )
        .length;
    int parThreeTeeShotGreenLeftCount = teeShotResult
        .where(
          (shot) => shot.isNotEmpty && (shot == 'greenLeft'),
        )
        .length;
    int parThreeTeeShotGreenRightCount = teeShotResult
        .where(
          (shot) => shot.isNotEmpty && (shot == 'greenRight'),
        )
        .length;
    int puttTryCount = puttMissed.where((putt) => putt.isNotEmpty).length;
    int puttLeftCount = puttMissed.where((putt) => putt == 'left').length;
    int puttRightCount = puttMissed.where((putt) => putt == 'right').length;
    int puttNoMissCount = puttMissed.where((putt) => putt == 'nomiss').length;
    int puttDistanceCount =
        puttDistance.where((putt) => putt.isNotEmpty).length;
    int puttDistanceNoMissCount =
        puttDistance.where((putt) => putt == 'nomiss').length;
    int puttDistanceShortCount =
        puttDistance.where((putt) => putt == 'short').length;
    int puttDistanceLongCount =
        puttDistance.where((putt) => putt == 'long').length;

    int parOnShotClubCount =
        parOnShotClub.where((shot) => shot.isNotEmpty).length;
    int parOnWoodTryCount =
        parOnShotClub.where((shot) => shot == 'wood').length +
            teeShotClub.where((shot) => shot == 'wood').length;
    int parOnUtTryCount = parOnShotClub.where((shot) => shot == 'ut').length +
        teeShotClub.where((shot) => shot == 'ut').length;
    int parOnLongIronTryCount =
        parOnShotClub.where((shot) => shot == 'longiron').length +
            teeShotClub.where((shot) => shot == 'longiron').length;
    int parOnMiddleIronTryCount =
        parOnShotClub.where((shot) => shot == 'middleiron').length +
            teeShotClub.where((shot) => shot == 'middleiron').length;
    int parOnShortIronTryCount =
        parOnShotClub.where((shot) => shot == 'shortiron').length +
            teeShotClub.where((shot) => shot == 'shortiron').length;
    int parOnWedgeTryCount =
        parOnShotClub.where((shot) => shot == 'wedge').length +
            teeShotClub.where((shot) => shot == 'wedge').length;

    double par3AverageScore = par3TotalScore / par3Count;
    double par4AverageScore = par4TotalScore / par4Count;
    double par5AverageScore = par5TotalScore / par5Count;

    String parOnWoodPercentage =
        ((parOnWoodCount / parOnWoodTryCount) * 100).toStringAsFixed(1);
    String parOnUtPercentage =
        ((parOnUtCount / parOnUtTryCount) * 100).toStringAsFixed(1);
    String parOnLongIronPercentage =
        ((parOnLongIronCount / parOnLongIronTryCount) * 100).toStringAsFixed(1);
    String parOnMiddleIronPercentage =
        ((parOnMiddleIronCount / parOnMiddleIronTryCount) * 100)
            .toStringAsFixed(1);
    String parOnShortIronPercentage =
        ((parOnShortIronCount / parOnShortIronTryCount) * 100)
            .toStringAsFixed(1);
    String parOnWedgePercentage =
        ((parOnWedgeCount / parOnWedgeTryCount) * 100).toStringAsFixed(1);

    String teeShotFairwayPercentage =
        ((teeShotFairwayCount / teeShotResultCount) * 100).toStringAsFixed(1);
    String teeShotLeftPercentage =
        (teeShotLeftCount / teeShotResultCount * 100).toStringAsFixed(1);
    String teeShotRightPercentage =
        (teeShotRightCount / teeShotResultCount * 100).toStringAsFixed(1);
    String teeShotCriticalMissPercentage =
        (teeShotCriticalMissCount / teeShotResultCount * 100)
            .toStringAsFixed(1);
    String teeShotDriverFwPercentage =
        ((teeShotDriverFwCount / teeShotDriverCount) * 100).toStringAsFixed(1);
    String teeShotWoodFwPercentage =
        ((teeShotWoodFwCount / teeShotWoodCount) * 100).toStringAsFixed(1);
    String teeShotUtFwPercentage =
        ((teeShotUtFwCount / teeShotUtCount) * 100).toStringAsFixed(1);
    String teeShotIronFwPercentage =
        ((teeShotIronFwCount / teeShotIronCount) * 100).toStringAsFixed(1);
    String parThreeTeeShotGreenOnPercentage =
        ((parThreeTeeShotGreenOnCount / parThreeTeeShotCount) * 100)
            .toStringAsFixed(1);
    String parThreeTeeShotGreenOverPercentage =
        ((parThreeTeeShotGreenOverCount / parThreeTeeShotCount) * 100)
            .toStringAsFixed(1);
    String parThreeTeeShotGreenShortPercentage =
        ((parThreeTeeShotGreenShortCount / parThreeTeeShotCount) * 100)
            .toStringAsFixed(1);
    String parThreeTeeShotGreenLeftPercentage =
        ((parThreeTeeShotGreenLeftCount / parThreeTeeShotCount) * 100)
            .toStringAsFixed(1);
    String parThreeTeeShotGreenRightPercentage =
        ((parThreeTeeShotGreenRightCount / parThreeTeeShotCount) * 100)
            .toStringAsFixed(1);
    String puttLeftPercentage =
        ((puttLeftCount / puttTryCount) * 100).toStringAsFixed(1);
    String puttRightPercentage =
        ((puttRightCount / puttTryCount) * 100).toStringAsFixed(1);
    String puttNoMissPercentage =
        ((puttNoMissCount / puttTryCount) * 100).toStringAsFixed(1);
    String puttDistancePinPercentage =
        ((puttDistanceNoMissCount / puttDistanceCount) * 100)
            .toStringAsFixed(1);
    String puttDistanceShortPercentage =
        ((puttDistanceShortCount / puttDistanceCount) * 100).toStringAsFixed(1);
    String puttDistanceLongPercentage =
        ((puttDistanceLongCount / puttDistanceCount) * 100).toStringAsFixed(1);
    String puttInAPinCupInPercentage =
        ((puttInAPinCupInCount / puttInAPinCount) * 100).toStringAsFixed(1);
    String puttInAPinLeftMissPercentage =
        ((puttInAPinLeftMissCount / puttInAPinCount) * 100).toStringAsFixed(1);
    String puttInAPinRightMissPercentage =
        ((puttInAPinRightMissCount / puttInAPinCount) * 100).toStringAsFixed(1);

    String puttInShortCupInPercentage =
        ((puttInShortCupInCount / puttInShortCount) * 100).toStringAsFixed(1);
    String puttInShortLeftMissPercentage =
        ((puttInShortLeftMissCount / puttInShortCount) * 100)
            .toStringAsFixed(1);
    String puttInShortRightMissPercentage =
        ((puttInShortRightMissCount / puttInShortCount) * 100)
            .toStringAsFixed(1);

    String puttInMiddleCupInPercentage =
        ((puttInMiddleCupInCount / puttInMiddleCount) * 100).toStringAsFixed(1);
    String puttInMiddleLeftMissPercentage =
        ((puttInMiddleLeftMissCount / puttInMiddleCount) * 100)
            .toStringAsFixed(1);
    String puttInMiddleRightMissPercentage =
        ((puttInMiddleRightMissCount / puttInMiddleCount) * 100)
            .toStringAsFixed(1);
    String puttInMiddleJustTouchPercentage =
        ((puttInMiddleJustTouchCount / puttInMiddleCount) * 100)
            .toStringAsFixed(1);
    String puttInMiddleShortPercentage =
        ((puttInMiddleShortCount / puttInMiddleCount) * 100).toStringAsFixed(1);
    String puttInMiddleLongPercentage =
        ((puttInMiddleLongCount / puttInMiddleCount) * 100).toStringAsFixed(1);
    String puttInMiddleTwoPutPercentage =
        ((puttInMiddleTwoPuttCount / puttInMiddleCount) * 100)
            .toStringAsFixed(1);

    String puttInLongCupInPercentage =
        ((puttInLongCupInCount / puttInLongCount) * 100).toStringAsFixed(1);
    String puttInLongLeftMissPercentage =
        ((puttInLongLeftMissCount / puttInLongCount) * 100).toStringAsFixed(1);
    String puttInLongRightMissPercentage =
        ((puttInLongRightMissCount / puttInLongCount) * 100).toStringAsFixed(1);
    String puttInLongJustTouchPercentage =
        ((puttInLongJustTouchCount / puttInLongCount) * 100).toStringAsFixed(1);
    String puttInLongShortPercentage =
        ((puttInLongShortCount / puttInLongCount) * 100).toStringAsFixed(1);
    String puttInLongLongPercentage =
        ((puttInLongLongCount / puttInLongCount) * 100).toStringAsFixed(1);
    String puttInLongTwoPutPercentage =
        ((puttInLongTwoPuttCount / puttInLongCount) * 100).toStringAsFixed(1);

    totalScore = outTotalScroe + inTotalScroe;
    totalPutt = outTotalPutt + inTotalPutt;

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
                      ScoreCardDataTile(
                        title: "ダブルボギー以上の数",
                        data: overBogeyCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "ボギーの数",
                        data: bogeyCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "パーの数",
                        data: parCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "バーディの数",
                        data: birdieCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "イーグル以下の数",
                        data: underBirdieCount.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "Par3平均スコア",
                        data: par3AverageScore.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "Par4平均スコア",
                        data: par4AverageScore.toString(),
                      ),
                      ScoreCardDataTile(
                        title: "Par5平均スコア",
                        data: par5AverageScore.toString(),
                      ),
                      const Gap(20),
                      const Text(
                        "ティーショット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイキープ",
                        data: "$teeShotFairwayCount / $teeShotResultCount",
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイキープ率",
                        data: "$teeShotFairwayPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイより左に外れた数",
                        data: "$teeShotLeftCount / $teeShotResultCount",
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイより左に外れる確率",
                        data: "$teeShotLeftPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイより右に外れた数",
                        data: "$teeShotRightCount / $teeShotResultCount",
                      ),
                      ScoreCardDataTile(
                        title: "フェアウェイより右に外れる確率",
                        data: "$teeShotRightPercentage%",
                      ),
                      const Gap(20),
                      const Text(
                        "クラブ別FWキープ率",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                        title: "Driver のFwキープ数",
                        data: "$teeShotDriverFwCount / $teeShotDriverCount",
                      ),
                      ScoreCardDataTile(
                          title: "DriverのFwキープ率",
                          data: "$teeShotDriverFwPercentage%"),
                      ScoreCardDataTile(
                        title: "WoodのFwキープ数",
                        data: "$teeShotWoodFwCount / $teeShotWoodCount",
                      ),
                      ScoreCardDataTile(
                        title: "WoodのFwキープ率",
                        data: "$teeShotWoodFwPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "UTのFwキープ数",
                        data: "$teeShotUtFwCount / $teeShotUtCount",
                      ),
                      ScoreCardDataTile(
                        title: "UTのFwキープ率",
                        data: "$teeShotUtFwPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "IronのFwキープ数",
                        data: "$teeShotIronFwCount / $teeShotIronCount",
                      ),
                      ScoreCardDataTile(
                        title: "IronのFwキープ率",
                        data: "$teeShotIronFwPercentage%",
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
                            "$parThreeTeeShotGreenOnCount / $parThreeTeeShotCount",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン乗せ成功率",
                        data: "$parThreeTeeShotGreenOnPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン左外し",
                        data:
                            "$parThreeTeeShotGreenLeftCount / $parThreeTeeShotCount",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン左外し率",
                        data: "$parThreeTeeShotGreenLeftPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン右外し",
                        data:
                            "$parThreeTeeShotGreenRightCount / $parThreeTeeShotCount",
                      ),
                      ScoreCardDataTile(
                        title: "グリーン右外し率",
                        data: "$parThreeTeeShotGreenRightPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンショート",
                        data:
                            "$parThreeTeeShotGreenShortCount / $parThreeTeeShotCount",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンショート率",
                        data: "$parThreeTeeShotGreenShortPercentage%",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンオーバー",
                        data:
                            "$parThreeTeeShotGreenOverCount / $parThreeTeeShotCount",
                      ),
                      ScoreCardDataTile(
                        title: "グリーンオーバー率",
                        data: "$parThreeTeeShotGreenOverPercentage%",
                      ),
                      const Text(
                        "パーオン分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "パーオン", data: "$parOnCount / 18ホール"),
                      ScoreCardDataTile(
                          title: "パーオン率",
                          data:
                              "${(parOnCount / 18 * 100).toStringAsFixed(1)}%"),
                      const Gap(20),
                      const Text(
                        "パーオン距離別分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "50ヤード以内パーオン数",
                          data:
                              "$parOnUnder50OnGreenCount / $parOnUnder50Count"),
                      ScoreCardDataTile(
                          title: "50ヤード以内パーオン率",
                          data:
                              "${parOnUnder50OnGreenCount / parOnUnder50Count * 100}%"),
                      ScoreCardDataTile(
                          title: "100ヤード以内パーオン数",
                          data:
                              "$parOnUnder100OnGreenCount / $parOnUnder100Count"),
                      ScoreCardDataTile(
                          title: "100ヤード以内パーオン率",
                          data:
                              "${parOnUnder100OnGreenCount / parOnUnder100Count * 100}%"),
                      ScoreCardDataTile(
                          title: "150ヤード以内パーオン数",
                          data:
                              "$parOnUnder150OnGreenCount / $parOnUnder150Count"),
                      ScoreCardDataTile(
                          title: "150ヤード以内パーオン率",
                          data:
                              "${parOnUnder150OnGreenCount / parOnUnder150Count * 100}%"),
                      ScoreCardDataTile(
                        title: "200ヤード以内パーオン数",
                        data:
                            "$parOnUnder200OnGreenCount / $parOnUnder200Count",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以内パーオン率",
                        data:
                            "${parOnUnder200OnGreenCount / parOnUnder200Count * 100}%",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以上パーオン数",
                        data: "$parOnOver200OnGreenCount / $parOnOver200Count",
                      ),
                      ScoreCardDataTile(
                        title: "200ヤード以上パーオン率",
                        data:
                            "${parOnOver200OnGreenCount / parOnOver200Count * 100}%",
                      ),
                      const Gap(20),
                      const Text(
                        "パーオンクラブ別分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "woodパーオン数",
                          data: "$parOnWoodCount / $parOnWoodTryCount"),
                      ScoreCardDataTile(
                          title: "woodパーオン率", data: "$parOnWoodPercentage%"),
                      ScoreCardDataTile(
                          title: "UTパーオン数",
                          data: "$parOnUtCount / $parOnUtTryCount"),
                      ScoreCardDataTile(
                          title: "UTパーオン率", data: "$parOnUtPercentage%"),
                      ScoreCardDataTile(
                          title: "LongIronパーオン数",
                          data: "$parOnLongIronCount / $parOnLongIronTryCount"),
                      ScoreCardDataTile(
                          title: "LongIronパーオン率",
                          data: "$parOnLongIronPercentage%"),
                      ScoreCardDataTile(
                          title: "MiddleIronパーオン数",
                          data:
                              "$parOnMiddleIronCount / $parOnMiddleIronTryCount"),
                      ScoreCardDataTile(
                          title: "MiddleIronパーオン率",
                          data: "$parOnMiddleIronPercentage%"),
                      ScoreCardDataTile(
                          title: "ShortIronパーオン数",
                          data:
                              "$parOnShortIronCount / $parOnShortIronTryCount"),
                      ScoreCardDataTile(
                          title: "ShortIronパーオン率",
                          data: "$parOnShortIronPercentage%"),
                      ScoreCardDataTile(
                          title: "Wedgeパーオン数",
                          data: "$parOnWedgeCount / $parOnWedgeTryCount"),
                      ScoreCardDataTile(
                          title: "Wedgeパーオン率", data: "$parOnWedgePercentage%"),
                      const Gap(20),
                      const Text(
                        "パットミス傾向分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "カップイン数",
                          data: "$puttNoMissCount / $puttTryCount"),
                      ScoreCardDataTile(
                          title: "カップイン率", data: "$puttNoMissPercentage%"),
                      ScoreCardDataTile(
                          title: "左外し数",
                          data: "$puttLeftCount / $puttTryCount"),
                      ScoreCardDataTile(
                          title: "左外し率", data: "$puttLeftPercentage%"),
                      ScoreCardDataTile(
                          title: "右外し数",
                          data: "$puttRightCount / $puttTryCount"),
                      ScoreCardDataTile(
                          title: "右外し率", data: "$puttRightPercentage%"),
                      const Gap(20),
                      const Text(
                        "パット距離分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "1m以内寄せ数",
                          data:
                              "$puttDistanceNoMissCount / $puttDistanceCount"),
                      ScoreCardDataTile(
                          title: "1m以内寄せ率",
                          data: "$puttDistancePinPercentage%"),
                      ScoreCardDataTile(
                          title: "ショート数",
                          data: "$puttDistanceShortCount / $puttDistanceCount"),
                      ScoreCardDataTile(
                          title: "ショート率",
                          data: "$puttDistanceShortPercentage%"),
                      ScoreCardDataTile(
                          title: "ロング数",
                          data: "$puttDistanceLongCount / $puttDistanceCount"),
                      ScoreCardDataTile(
                          title: "ロング率", data: "$puttDistanceLongPercentage%"),
                      const Gap(20),
                      const Text(
                        "2.5m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "カップイン数",
                          data: "$puttInAPinCupInCount / $puttInAPinCount"),
                      ScoreCardDataTile(
                          title: "カップイン率", data: "$puttInAPinCupInPercentage%"),
                      ScoreCardDataTile(
                          title: "左外し数",
                          data: "$puttInAPinLeftMissCount / $puttInAPinCount"),
                      ScoreCardDataTile(
                          title: "左外し率",
                          data: "$puttInAPinLeftMissPercentage%"),
                      ScoreCardDataTile(
                          title: "右外し数",
                          data: "$puttInAPinRightMissCount / $puttInAPinCount"),
                      ScoreCardDataTile(
                          title: "右外し率",
                          data: "$puttInAPinRightMissPercentage%"),
                      const Gap(20),
                      const Text(
                        "5m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "カップイン数",
                          data: "$puttInShortCupInCount / $puttInShortCount"),
                      ScoreCardDataTile(
                          title: "カップイン率",
                          data: "$puttInShortCupInPercentage%"),
                      ScoreCardDataTile(
                          title: "左外し数",
                          data:
                              "$puttInShortLeftMissCount / $puttInShortCount"),
                      ScoreCardDataTile(
                          title: "左外し率",
                          data: "$puttInShortLeftMissPercentage%"),
                      ScoreCardDataTile(
                          title: "右外し数",
                          data:
                              "$puttInShortRightMissCount / $puttInShortCount"),
                      ScoreCardDataTile(
                          title: "右外し率",
                          data: "$puttInShortRightMissPercentage%"),
                      const Gap(20),
                      const Text(
                        "10m以内パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "カップイン数",
                          data: "$puttInMiddleCupInCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "カップイン率",
                          data: "$puttInMiddleCupInPercentage%"),
                      ScoreCardDataTile(
                          title: "左外し数",
                          data:
                              "$puttInMiddleLeftMissCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "左外し率",
                          data: "$puttInMiddleLeftMissPercentage%"),
                      ScoreCardDataTile(
                          title: "右外し数",
                          data:
                              "$puttInMiddleRightMissCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "右外し率",
                          data: "$puttInMiddleRightMissPercentage%"),
                      ScoreCardDataTile(
                          title: "1m以内寄せ数",
                          data:
                              "$puttInMiddleJustTouchCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "1m以内寄せ率",
                          data: "$puttInMiddleJustTouchPercentage%"),
                      ScoreCardDataTile(
                          title: "ショート数",
                          data: "$puttInMiddleShortCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "ショート率",
                          data: "$puttInMiddleShortPercentage%"),
                      ScoreCardDataTile(
                          title: "ロング数",
                          data: "$puttInMiddleLongCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "ロング率", data: "$puttInMiddleLongPercentage%"),
                      ScoreCardDataTile(
                          title: "2パット以下数",
                          data:
                              "$puttInMiddleTwoPuttCount / $puttInMiddleCount"),
                      ScoreCardDataTile(
                          title: "2パット以下率",
                          data: "$puttInMiddleTwoPutPercentage%"),
                      const Gap(20),
                      const Text(
                        "10m以上パット分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "カップイン数",
                          data: "$puttInLongCupInCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "カップイン率", data: "$puttInLongCupInPercentage%"),
                      ScoreCardDataTile(
                          title: "左外し数",
                          data: "$puttInLongLeftMissCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "左外し率",
                          data: "$puttInLongLeftMissPercentage%"),
                      ScoreCardDataTile(
                          title: "右外し数",
                          data: "$puttInLongRightMissCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "右外し率",
                          data: "$puttInLongRightMissPercentage%"),
                      ScoreCardDataTile(
                          title: "1m以内寄せ数",
                          data: "$puttInLongJustTouchCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "1m以内寄せ率",
                          data: "$puttInLongJustTouchPercentage%"),
                      ScoreCardDataTile(
                          title: "ショート数",
                          data: "$puttInLongShortCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "ショート率", data: "$puttInLongShortPercentage%"),
                      ScoreCardDataTile(
                          title: "ロング数",
                          data: "$puttInLongLongCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "ロング率", data: "$puttInLongLongPercentage%"),
                      ScoreCardDataTile(
                          title: "2パット以下",
                          data: "$puttInLongTwoPuttCount / $puttInLongCount"),
                      ScoreCardDataTile(
                          title: "2パット以下率",
                          data: "$puttInLongTwoPutPercentage%"),
                      const Gap(20),
                      const Text(
                        "アプローチ分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "パーセーブ数",
                          data: "$approachParSaveCount / $approachCount"),
                      ScoreCardDataTile(
                          title: "パーセーブ率",
                          data:
                              "${approachParSaveCount / approachCount * 100}%"),
                      ScoreCardDataTile(
                          title: "チップイン数", data: "$approachChipInCount"),
                      const Gap(20),
                      const Text(
                        "バンカー分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "バンカーセーブ数",
                          data: "$bunkerParSaveCount / $bunkerCount"),
                      ScoreCardDataTile(
                          title: "バンカーセーブ率",
                          data:
                              "${(bunkerParSaveCount / bunkerCount * 100).toStringAsFixed(1)}%"),
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
                          data: "$birdieChanceCount"),
                      ScoreCardDataTile(
                          title: "バーディチャンス時ホールイン数",
                          data:
                              "$birdieChanceHoleInCount / $birdieChanceCount"),
                      ScoreCardDataTile(
                          title: "バーディチャンス成功率",
                          data:
                              "${(birdieChanceHoleInCount / birdieChanceCount * 100).toStringAsFixed(1)}%"),
                      const Text(
                        "ミス分析",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      ScoreCardDataTile(
                          title: "100ヤード以内でグリーンを外した数",
                          data:
                              "${parOnUnder50Count + parOnUnder100Count - parOnUnder50OnGreenCount - parOnUnder100OnGreenCount}"),
                      ScoreCardDataTile(
                          title: "3パット以上した数", data: "$puttOverThreePutt"),
                      ScoreCardDataTile(
                          title: "グリーンサイドバンカーに入れた数", data: "$bunkerCount"),
                      ScoreCardDataTile(title: "OBした数", data: "$obCount"),
                      ScoreCardDataTile(title: "池に入れた数", data: "$hazardCount"),
                      ScoreCardDataTile(title: "ペナルティ数", data: "$penaltyCount"),
                      const Gap(40),
                      GestureDetector(
                        onTap: () async {
                          if (isTapped) return;
                          final scoreCardData = ScoreCardDataModel(
                            uploaderName: profile.name,
                            uploaderId: profile.uid,
                            uploadDate: widget.date,
                            courseName: course.courseName,
                            createAtUnix: DateTime.now().millisecondsSinceEpoch,
                            weather: widget.weather,
                            wind: widget.wind,
                            temperature: widget.temperature,
                            scoreList: scoreList,
                            puttsList: puttList,
                            parValueList: parValueList,
                            totalScore: totalScore,
                            totalPutts: totalPutt,
                            totalFairwayFind: teeShotFairwayCount,
                            totalFairwayTry: teeShotResultCount,
                            driverFairwayFind: teeShotDriverFwCount,
                            driverFairwayTry: teeShotDriverCount,
                            woodFairwayFind: teeShotWoodFwCount,
                            woodFairwayTry: teeShotWoodCount,
                            utilityFairwayFind: teeShotUtFwCount,
                            utilityFairwayTry: teeShotUtCount,
                            ironFairwayFind: teeShotIronFwCount,
                            ironFairwayTry: teeShotIronCount,
                            parThreeTeeshotTry: parThreeTeeShotCount,
                            parThreeGreenInRegulation:
                                parThreeTeeShotGreenOnCount,
                            parThreeGreenMissedLeft:
                                parThreeTeeShotGreenLeftCount,
                            parThreeGreenMissedRight:
                                parThreeTeeShotGreenRightCount,
                            parThreeGreenMissedShort:
                                parThreeTeeShotGreenShortCount,
                            parThreeGreenMissedOver:
                                parThreeTeeShotGreenOverCount,
                            totalGreenInRegulation: parOnCount,
                            greenInRegulationIn50: parOnUnder50OnGreenCount,
                            greenInRegulationIn50Try: parOnUnder50Count,
                            greenInRegulationIn100: parOnUnder100OnGreenCount,
                            greenInRegulationIn100Try: parOnUnder100Count,
                            greenInRegulationIn150: parOnUnder150OnGreenCount,
                            greenInRegulationIn150Try: parOnUnder150Count,
                            greenInRegulationIn200: parOnUnder200OnGreenCount,
                            greenInRegulationIn200Try: parOnUnder200Count,
                            greenInRegulationOver200: parOnOver200OnGreenCount,
                            greenInRegulationOver200Try: parOnOver200Count,
                            parOnByWood: parOnWoodCount,
                            parOnByWoodTry: parOnWoodTryCount,
                            parOnByUtility: parOnUtCount,
                            parOnByUtilityTry: parOnUtTryCount,
                            parOnByLongIron: parOnLongIronCount,
                            parOnByLongIronTry: parOnLongIronTryCount,
                            parOnByMiddleIron: parOnMiddleIronCount,
                            parOnByMiddleIronTry: parOnMiddleIronTryCount,
                            parOnByShortIron: parOnShortIronCount,
                            parOnByShortIronTry: parOnShortIronTryCount,
                            parOnByWedge: parOnWedgeCount,
                            parOnByWedgeTry: parOnWedgeTryCount,
                            puttTry: puttTryCount,
                            puttHoleIn: puttNoMissCount,
                            puttMissedLeft: puttLeftCount,
                            puttMissedRight: puttRightCount,
                            puttDistanceTry: puttDistanceCount,
                            puttDistanceIn1m: puttDistanceNoMissCount,
                            puttDistanceLong: puttDistanceLongCount,
                            puttDistanceShort: puttDistanceShortCount,
                            puttIn2and5mTry: puttInAPinCount,
                            puttIn2and5mHoleIn: puttInAPinCupInCount,
                            puttIn2and5mMissedLeft: puttInAPinLeftMissCount,
                            puttIn2and5mMissedRight: puttInAPinRightMissCount,
                            puttIn5mTry: puttInShortCount,
                            puttIn5mHoleIn: puttInShortCupInCount,
                            puttIn5mMissedLeft: puttInShortLeftMissCount,
                            puttIn5mMissedRight: puttInShortRightMissCount,
                            puttIn10mTry: puttInMiddleCount,
                            puttIn10mHoleIn: puttInMiddleCupInCount,
                            puttIn10mMissedLeft: puttInMiddleLeftMissCount,
                            puttIn10mMissedRight: puttInMiddleRightMissCount,
                            puttIn10mMissedShort: puttInMiddleShortCount,
                            puttIn10mMissedLong: puttInMiddleLongCount,
                            puttIn10mJustTouch: puttInMiddleJustTouchCount,
                            puttIn10mTwoPutt: puttInMiddleTwoPuttCount,
                            puttInOver10mTry: puttInLongCount,
                            puttInOver10mHoleIn: puttInLongCupInCount,
                            puttInOver10mMissedLeft: puttInLongLeftMissCount,
                            puttInOver10mMissedRight: puttInLongRightMissCount,
                            puttInOver10mMissedShort: puttInLongShortCount,
                            puttInOver10mMissedLong: puttInLongLongCount,
                            puttInOver10mJustTouch: puttInLongJustTouchCount,
                            puttInOver10mTwoPutt: puttInLongTwoPuttCount,
                            approachTry: approachCount,
                            approachParSave: approachParSaveCount,
                            approachChipIn: approachChipInCount,
                            bunkerTry: bunkerCount,
                            bunkerParSave: bunkerParSaveCount,
                            birdieChanceCount: birdieChanceCount,
                            birdieChanceSuccess: birdieChanceHoleInCount,
                            missedGreenInRegulationUnder100: parOnUnder50Count +
                                parOnUnder100Count -
                                parOnUnder50OnGreenCount -
                                parOnUnder100OnGreenCount,
                            missedOverThreePutts: puttOverThreePutt,
                            missedIntoBunker: bunkerCount,
                            missedIntoWater: hazardCount,
                            missedIntoOB: obCount,
                            missedGetPenalty: penaltyCount,
                            overBogeyCount: overBogeyCount,
                            bogeyCount: bogeyCount,
                            parCount: parCount,
                            birdieCount: birdieCount,
                            underBirdieCount: underBirdieCount,
                            averagePar3Score: par3AverageScore,
                            averagePar4Score: par4AverageScore,
                            averagePar5Score: par5AverageScore,
                            totalParOn: parOnCount,
                            teeShotMissedLeft: teeShotLeftCount,
                            teeShotMissedRight: teeShotRightCount,
                            teeShotCriticalMiss: teeShotCriticalMissCount,
                          );
                          isTapped = true;
                          await _onUploadScoreTap(scoreCardData, context);
                        },
                        child: Center(
                          child: AuthButton(
                              color: isTapped ? Colors.grey : Colors.green,
                              text: "スコアを登録する"),
                        ),
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
