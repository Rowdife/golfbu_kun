import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/score_card/models/new_scorecard_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';
import 'package:golfbu_kun/features/score_card/widgets/new_scorecard.dart';

class ScoreCardRepository {
  // Implement your repository methods and functionality here
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  Future<List<ScoreCardCourseModel>> fetchScoreCardCourses() async {
    final courses = await _db.collection("courses").get();
    final courseList = courses.docs
        .map((e) => ScoreCardCourseModel.fromJson(e.data()))
        .toList();
    return courseList;
  }

  Future<void> addNewScoreCardCourse(
      {required ScoreCardCourseModel course}) async {
    final courseJson = course.toJson();
    await _db.collection("courses").add(courseJson);
  }

  Future<void> uploadScoreCard(
      {required NewScoreCardDataModel scoreCardData}) async {
    final universityId = _authRepo.user!.displayName;
    final scoreCardJson = scoreCardData.toJson();
    await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .add(scoreCardJson);

    // users에 coursePlayedCount 추가하기
    await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(_authRepo.user!.uid)
        .update({"coursePlayedCount": FieldValue.increment(1)});

    //users collection에 scoreData를 추가하기
    final scoreDataCollection = _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(_authRepo.user!.uid)
        .collection("scoreData");

    final scoreDataDoc =
        scoreDataCollection.doc(DateTime.now().toString().substring(0, 4));
    final scoreDataDocSnapshot = await scoreDataDoc.get();

    if (scoreDataDocSnapshot.exists) {
      await scoreDataDoc.update({
        //평균스코어 계산용
        'totalScore': FieldValue.increment(scoreCardData.totalScore),
        'totalPutts': FieldValue.increment(scoreCardData.totalPutts),
        'totalFairwayFind':
            FieldValue.increment(scoreCardData.totalFairwayFind),
        'totalFairwayTry': FieldValue.increment(scoreCardData.totalFairwayTry),
        'driverFairwayFind':
            FieldValue.increment(scoreCardData.driverFairwayFind),
        'driverFairwayTry':
            FieldValue.increment(scoreCardData.driverFairwayTry),
        'woodFairwayFind': FieldValue.increment(scoreCardData.woodFairwayFind),
        'woodFairwayTry': FieldValue.increment(scoreCardData.woodFairwayTry),
        'utilityFairwayFind':
            FieldValue.increment(scoreCardData.utilityFairwayFind),
        'utilityFairwayTry':
            FieldValue.increment(scoreCardData.utilityFairwayTry),
        'ironFairwayFind': FieldValue.increment(scoreCardData.ironFairwayFind),
        'ironFairwayTry': FieldValue.increment(scoreCardData.ironFairwayTry),
        'parThreeTeeshotTry':
            FieldValue.increment(scoreCardData.parThreeTeeshotTry),
        'parThreeGreenInRegulation':
            FieldValue.increment(scoreCardData.parThreeGreenInRegulation),
        'parThreeGreenMissedLeft':
            FieldValue.increment(scoreCardData.parThreeGreenMissedLeft),
        'parThreeGreenMissedRight':
            FieldValue.increment(scoreCardData.parThreeGreenMissedRight),
        'parThreeGreenMissedShort':
            FieldValue.increment(scoreCardData.parThreeGreenMissedShort),
        'parThreeGreenMissedOver':
            FieldValue.increment(scoreCardData.parThreeGreenMissedOver),
        'totalGreenInRegulation':
            FieldValue.increment(scoreCardData.totalGreenInRegulation),
        'greenInRegulationIn50':
            FieldValue.increment(scoreCardData.greenInRegulationIn50),
        'greenInRegulationIn50Try':
            FieldValue.increment(scoreCardData.greenInRegulationIn50Try),
        'greenInRegulationIn100':
            FieldValue.increment(scoreCardData.greenInRegulationIn100),
        'greenInRegulationIn100Try':
            FieldValue.increment(scoreCardData.greenInRegulationIn100Try),
        'greenInRegulationIn150':
            FieldValue.increment(scoreCardData.greenInRegulationIn150),
        'greenInRegulationIn150Try':
            FieldValue.increment(scoreCardData.greenInRegulationIn150Try),
        'greenInRegulationIn200':
            FieldValue.increment(scoreCardData.greenInRegulationIn200),
        'greenInRegulationIn200Try':
            FieldValue.increment(scoreCardData.greenInRegulationIn200Try),
        'greenInRegulationOver200':
            FieldValue.increment(scoreCardData.greenInRegulationOver200),
        'greenInRegulationOver200Try':
            FieldValue.increment(scoreCardData.greenInRegulationOver200Try),
        'parOnByWood': FieldValue.increment(scoreCardData.parOnByWood),
        'parOnByWoodTry': FieldValue.increment(scoreCardData.parOnByWoodTry),
        'parOnByUtility': FieldValue.increment(scoreCardData.parOnByUtility),
        'parOnByUtilityTry':
            FieldValue.increment(scoreCardData.parOnByUtilityTry),
        'parOnByLongIron': FieldValue.increment(scoreCardData.parOnByLongIron),
        'parOnByLongIronTry':
            FieldValue.increment(scoreCardData.parOnByLongIronTry),
        'parOnByMiddleIron':
            FieldValue.increment(scoreCardData.parOnByMiddleIron),
        'parOnByMiddleIronTry':
            FieldValue.increment(scoreCardData.parOnByMiddleIronTry),
        'parOnByShortIron':
            FieldValue.increment(scoreCardData.parOnByShortIron),
        'parOnByShortIronTry':
            FieldValue.increment(scoreCardData.parOnByShortIronTry),
        'parOnByWedge': FieldValue.increment(scoreCardData.parOnByWedge),
        'parOnByWedgeTry': FieldValue.increment(scoreCardData.parOnByWedgeTry),
        'puttTry': FieldValue.increment(scoreCardData.puttTry),
        'puttHoleIn': FieldValue.increment(scoreCardData.puttHoleIn),
        'puttMissedLeft': FieldValue.increment(scoreCardData.puttMissedLeft),
        'puttMissedRight': FieldValue.increment(scoreCardData.puttMissedRight),
        'puttDistanceTry': FieldValue.increment(scoreCardData.puttDistanceTry),
        'puttDistanceIn1m':
            FieldValue.increment(scoreCardData.puttDistanceIn1m),
        'puttDistanceLong':
            FieldValue.increment(scoreCardData.puttDistanceLong),
        'puttDistanceShort':
            FieldValue.increment(scoreCardData.puttDistanceShort),
        'puttIn2and5mTry': FieldValue.increment(scoreCardData.puttIn2and5mTry),
        'puttIn2and5mHoleIn':
            FieldValue.increment(scoreCardData.puttIn2and5mHoleIn),
        'puttIn2and5mMissedLeft':
            FieldValue.increment(scoreCardData.puttIn2and5mMissedLeft),
        'puttIn2and5mMissedRight':
            FieldValue.increment(scoreCardData.puttIn2and5mMissedRight),
        'puttIn5mTry': FieldValue.increment(scoreCardData.puttIn5mTry),
        'puttIn5mHoleIn': FieldValue.increment(scoreCardData.puttIn5mHoleIn),
        'puttIn5mMissedLeft':
            FieldValue.increment(scoreCardData.puttIn5mMissedLeft),
        'puttIn5mMissedRight':
            FieldValue.increment(scoreCardData.puttIn5mMissedRight),
        'puttIn10mTry': FieldValue.increment(scoreCardData.puttIn10mTry),
        'puttIn10mHoleIn': FieldValue.increment(scoreCardData.puttIn10mHoleIn),
        'puttIn10mMissedLeft':
            FieldValue.increment(scoreCardData.puttIn10mMissedLeft),
        'puttIn10mMissedRight':
            FieldValue.increment(scoreCardData.puttIn10mMissedRight),
        'puttIn10mMissedShort':
            FieldValue.increment(scoreCardData.puttIn10mMissedShort),
        'puttIn10mMissedLong':
            FieldValue.increment(scoreCardData.puttIn10mMissedLong),
        'puttIn10mJustTouch':
            FieldValue.increment(scoreCardData.puttIn10mJustTouch),
        'puttIn10mTwoPutt':
            FieldValue.increment(scoreCardData.puttIn10mTwoPutt),
        'puttInOver10mTry':
            FieldValue.increment(scoreCardData.puttInOver10mTry),
        'puttInOver10mHoleIn':
            FieldValue.increment(scoreCardData.puttInOver10mHoleIn),
        'puttInOver10mMissedLeft':
            FieldValue.increment(scoreCardData.puttInOver10mMissedLeft),
        'puttInOver10mMissedRight':
            FieldValue.increment(scoreCardData.puttInOver10mMissedRight),
        'puttInOver10mMissedShort':
            FieldValue.increment(scoreCardData.puttInOver10mMissedShort),
        'puttInOver10mMissedLong':
            FieldValue.increment(scoreCardData.puttInOver10mMissedLong),
        'puttInOver10mJustTouch':
            FieldValue.increment(scoreCardData.puttInOver10mJustTouch),
        'puttInOver10mTwoPutt':
            FieldValue.increment(scoreCardData.puttInOver10mTwoPutt),
        'approachTry': FieldValue.increment(scoreCardData.approachTry),
        'approachParSave': FieldValue.increment(scoreCardData.approachParSave),
        'approachChipIn': FieldValue.increment(scoreCardData.approachChipIn),
        'bunkerTry': FieldValue.increment(scoreCardData.bunkerTry),
        'bunkerParSave': FieldValue.increment(scoreCardData.bunkerParSave),
        'birdieChanceCount':
            FieldValue.increment(scoreCardData.birdieChanceCount),
        'birdieChanceSuccess':
            FieldValue.increment(scoreCardData.birdieChanceSuccess),
        'missedGreenInRegulationUnder100':
            FieldValue.increment(scoreCardData.missedGreenInRegulationUnder100),
        'missedOverThreePutts':
            FieldValue.increment(scoreCardData.missedOverThreePutts),
        'missedIntoBunker':
            FieldValue.increment(scoreCardData.missedIntoBunker),
        'missedIntoWater': FieldValue.increment(scoreCardData.missedIntoWater),
        'missedIntoOB': FieldValue.increment(scoreCardData.missedIntoOB),
        'missedGetPenalty':
            FieldValue.increment(scoreCardData.missedGetPenalty),
        'overBogeyCount': FieldValue.increment(scoreCardData.overBogeyCount),
        'bogeyCount': FieldValue.increment(scoreCardData.bogeyCount),
        'parCount': FieldValue.increment(scoreCardData.parCount),
        'birdieCount': FieldValue.increment(scoreCardData.birdieCount),
        'underBirdieCount':
            FieldValue.increment(scoreCardData.underBirdieCount),
        'averagePar3Score':
            FieldValue.increment(scoreCardData.averagePar3Score),
        'averagePar4Score':
            FieldValue.increment(scoreCardData.averagePar4Score),
        'averagePar5Score':
            FieldValue.increment(scoreCardData.averagePar5Score),
        'teeShotMissedLeft':
            FieldValue.increment(scoreCardData.teeShotMissedLeft),
        'teeShotMissedRight':
            FieldValue.increment(scoreCardData.teeShotMissedRight),
        'teeShotCriticalMiss':
            FieldValue.increment(scoreCardData.teeShotCriticalMiss),
        'totalParOn': FieldValue.increment(scoreCardData.totalParOn),
      });
    } else {
      await scoreDataDoc.set({"coursePlayedCount": 1});
      await scoreDataDoc.set(scoreCardData.toJson());
    }
  }

  Future<void> deleteScoreCardByCreatedAt(int createdAt) async {
    final universityId = _authRepo.user!.displayName;
    final scoreCard = await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .where("createAtUnix", isEqualTo: createdAt)
        .get();
    final ScoreCardDataModel scoreCardData =
        ScoreCardDataModel.fromJson(scoreCard.docs.first.data());
    final scoreCardId = scoreCard.docs.first.id;
    await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .doc(scoreCardId)
        .delete();
    await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(_authRepo.user!.uid)
        .update({"coursePlayedCount": FieldValue.increment(-1)});
    final scoreDataCollection = _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(_authRepo.user!.uid)
        .collection("scoreData");

    final scoreDataDoc =
        scoreDataCollection.doc(DateTime.now().toString().substring(0, 4));

    await scoreDataDoc.update({
      //평균스코어 계산용
      'totalScore': FieldValue.increment(-scoreCardData.totalScore),
      'totalPutts': FieldValue.increment(-scoreCardData.totalPutts),
      'totalFairwayFind': FieldValue.increment(-scoreCardData.totalFairwayFind),
      'totalFairwayTry': FieldValue.increment(-scoreCardData.totalFairwayTry),
      'driverFairwayFind':
          FieldValue.increment(-scoreCardData.driverFairwayFind),
      'driverFairwayTry': FieldValue.increment(-scoreCardData.driverFairwayTry),
      'woodFairwayFind': FieldValue.increment(-scoreCardData.woodFairwayFind),
      'woodFairwayTry': FieldValue.increment(-scoreCardData.woodFairwayTry),
      'utilityFairwayFind':
          FieldValue.increment(-scoreCardData.utilityFairwayFind),
      'utilityFairwayTry':
          FieldValue.increment(-scoreCardData.utilityFairwayTry),
      'ironFairwayFind': FieldValue.increment(-scoreCardData.ironFairwayFind),
      'ironFairwayTry': FieldValue.increment(-scoreCardData.ironFairwayTry),
      'parThreeTeeshotTry':
          FieldValue.increment(-scoreCardData.parThreeTeeshotTry),
      'parThreeGreenInRegulation':
          FieldValue.increment(-scoreCardData.parThreeGreenInRegulation),
      'parThreeGreenMissedLeft':
          FieldValue.increment(-scoreCardData.parThreeGreenMissedLeft),
      'parThreeGreenMissedRight':
          FieldValue.increment(-scoreCardData.parThreeGreenMissedRight),
      'parThreeGreenMissedShort':
          FieldValue.increment(-scoreCardData.parThreeGreenMissedShort),
      'parThreeGreenMissedOver':
          FieldValue.increment(-scoreCardData.parThreeGreenMissedOver),
      'totalGreenInRegulation':
          FieldValue.increment(-scoreCardData.totalGreenInRegulation),
      'greenInRegulationIn50':
          FieldValue.increment(-scoreCardData.greenInRegulationIn50),
      'greenInRegulationIn50Try':
          FieldValue.increment(-scoreCardData.greenInRegulationIn50Try),
      'greenInRegulationIn100':
          FieldValue.increment(-scoreCardData.greenInRegulationIn100),
      'greenInRegulationIn100Try':
          FieldValue.increment(-scoreCardData.greenInRegulationIn100Try),
      'greenInRegulationIn150':
          FieldValue.increment(-scoreCardData.greenInRegulationIn150),
      'greenInRegulationIn150Try':
          FieldValue.increment(-scoreCardData.greenInRegulationIn150Try),
      'greenInRegulationIn200':
          FieldValue.increment(-scoreCardData.greenInRegulationIn200),
      'greenInRegulationIn200Try':
          FieldValue.increment(-scoreCardData.greenInRegulationIn200Try),
      'greenInRegulationOver200':
          FieldValue.increment(-scoreCardData.greenInRegulationOver200),
      'greenInRegulationOver200Try':
          FieldValue.increment(-scoreCardData.greenInRegulationOver200Try),
      'parOnByWood': FieldValue.increment(-scoreCardData.parOnByWood),
      'parOnByWoodTry': FieldValue.increment(-scoreCardData.parOnByWoodTry),
      'parOnByUtility': FieldValue.increment(-scoreCardData.parOnByUtility),
      'parOnByUtilityTry':
          FieldValue.increment(-scoreCardData.parOnByUtilityTry),
      'parOnByLongIron': FieldValue.increment(-scoreCardData.parOnByLongIron),
      'parOnByLongIronTry':
          FieldValue.increment(-scoreCardData.parOnByLongIronTry),
      'parOnByMiddleIron':
          FieldValue.increment(-scoreCardData.parOnByMiddleIron),
      'parOnByMiddleIronTry':
          FieldValue.increment(-scoreCardData.parOnByMiddleIronTry),
      'parOnByShortIron': FieldValue.increment(-scoreCardData.parOnByShortIron),
      'parOnByShortIronTry':
          FieldValue.increment(-scoreCardData.parOnByShortIronTry),
      'parOnByWedge': FieldValue.increment(-scoreCardData.parOnByWedge),
      'parOnByWedgeTry': FieldValue.increment(-scoreCardData.parOnByWedgeTry),
      'puttTry': FieldValue.increment(-scoreCardData.puttTry),
      'puttHoleIn': FieldValue.increment(-scoreCardData.puttHoleIn),
      'puttMissedLeft': FieldValue.increment(-scoreCardData.puttMissedLeft),
      'puttMissedRight': FieldValue.increment(-scoreCardData.puttMissedRight),
      'puttDistanceTry': FieldValue.increment(-scoreCardData.puttDistanceTry),
      'puttDistanceIn1m': FieldValue.increment(-scoreCardData.puttDistanceIn1m),
      'puttDistanceLong': FieldValue.increment(-scoreCardData.puttDistanceLong),
      'puttDistanceShort':
          FieldValue.increment(-scoreCardData.puttDistanceShort),
      'puttIn2and5mTry': FieldValue.increment(-scoreCardData.puttIn2and5mTry),
      'puttIn2and5mHoleIn':
          FieldValue.increment(-scoreCardData.puttIn2and5mHoleIn),
      'puttIn2and5mMissedLeft':
          FieldValue.increment(-scoreCardData.puttIn2and5mMissedLeft),
      'puttIn2and5mMissedRight':
          FieldValue.increment(-scoreCardData.puttIn2and5mMissedRight),
      'puttIn5mTry': FieldValue.increment(-scoreCardData.puttIn5mTry),
      'puttIn5mHoleIn': FieldValue.increment(-scoreCardData.puttIn5mHoleIn),
      'puttIn5mMissedLeft':
          FieldValue.increment(-scoreCardData.puttIn5mMissedLeft),
      'puttIn5mMissedRight':
          FieldValue.increment(-scoreCardData.puttIn5mMissedRight),
      'puttIn10mTry': FieldValue.increment(-scoreCardData.puttIn10mTry),
      'puttIn10mHoleIn': FieldValue.increment(-scoreCardData.puttIn10mHoleIn),
      'puttIn10mMissedLeft':
          FieldValue.increment(-scoreCardData.puttIn10mMissedLeft),
      'puttIn10mMissedRight':
          FieldValue.increment(-scoreCardData.puttIn10mMissedRight),
      'puttIn10mMissedShort':
          FieldValue.increment(-scoreCardData.puttIn10mMissedShort),
      'puttIn10mMissedLong':
          FieldValue.increment(-scoreCardData.puttIn10mMissedLong),
      'puttIn10mJustTouch':
          FieldValue.increment(-scoreCardData.puttIn10mJustTouch),
      'puttIn10mTwoPutt': FieldValue.increment(-scoreCardData.puttIn10mTwoPutt),
      'puttInOver10mTry': FieldValue.increment(-scoreCardData.puttInOver10mTry),
      'puttInOver10mHoleIn':
          FieldValue.increment(-scoreCardData.puttInOver10mHoleIn),
      'puttInOver10mMissedLeft':
          FieldValue.increment(-scoreCardData.puttInOver10mMissedLeft),
      'puttInOver10mMissedRight':
          FieldValue.increment(-scoreCardData.puttInOver10mMissedRight),
      'puttInOver10mMissedShort':
          FieldValue.increment(-scoreCardData.puttInOver10mMissedShort),
      'puttInOver10mMissedLong':
          FieldValue.increment(-scoreCardData.puttInOver10mMissedLong),
      'puttInOver10mJustTouch':
          FieldValue.increment(-scoreCardData.puttInOver10mJustTouch),
      'puttInOver10mTwoPutt':
          FieldValue.increment(-scoreCardData.puttInOver10mTwoPutt),
      'approachTry': FieldValue.increment(-scoreCardData.approachTry),
      'approachParSave': FieldValue.increment(-scoreCardData.approachParSave),
      'approachChipIn': FieldValue.increment(-scoreCardData.approachChipIn),
      'bunkerTry': FieldValue.increment(-scoreCardData.bunkerTry),
      'bunkerParSave': FieldValue.increment(-scoreCardData.bunkerParSave),
      'birdieChanceCount':
          FieldValue.increment(-scoreCardData.birdieChanceCount),
      'birdieChanceSuccess':
          FieldValue.increment(-scoreCardData.birdieChanceSuccess),
      'missedGreenInRegulationUnder100':
          FieldValue.increment(-scoreCardData.missedGreenInRegulationUnder100),
      'missedOverThreePutts':
          FieldValue.increment(-scoreCardData.missedOverThreePutts),
      'missedIntoBunker': FieldValue.increment(-scoreCardData.missedIntoBunker),
      'missedIntoWater': FieldValue.increment(-scoreCardData.missedIntoWater),
      'missedIntoOB': FieldValue.increment(-scoreCardData.missedIntoOB),
      'missedGetPenalty': FieldValue.increment(-scoreCardData.missedGetPenalty),
      'overBogeyCount': FieldValue.increment(-scoreCardData.overBogeyCount),
      'bogeyCount': FieldValue.increment(-scoreCardData.bogeyCount),
      'parCount': FieldValue.increment(-scoreCardData.parCount),
      'birdieCount': FieldValue.increment(-scoreCardData.birdieCount),
      'underBirdieCount': FieldValue.increment(-scoreCardData.underBirdieCount),
      'averagePar3Score': FieldValue.increment(-scoreCardData.averagePar3Score),
      'averagePar4Score': FieldValue.increment(-scoreCardData.averagePar4Score),
      'averagePar5Score': FieldValue.increment(-scoreCardData.averagePar5Score),
      'teeShotMissedLeft':
          FieldValue.increment(-scoreCardData.teeShotMissedLeft),
      'teeShotMissedRight':
          FieldValue.increment(-scoreCardData.teeShotMissedRight),
      'teeShotCriticalMiss':
          FieldValue.increment(-scoreCardData.teeShotCriticalMiss),
      'totalParOn': FieldValue.increment(-scoreCardData.totalParOn),
    });
  }

  Future<ScoreCardDataModel> fetchScoreDataByUserId(String? userId) async {
    final universityId = _authRepo.user!.displayName;
    final scoreData = await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(userId)
        .collection("scoreData")
        .doc("${DateTime.now().year}")
        .get();
    if (scoreData.exists) {
      return ScoreCardDataModel.fromJson(scoreData.data()!);
    }
    return ScoreCardDataModel.empty();
  }

  Future<List<ScoreCardDataModel>> fetchMyScoreCardsData() async {
    final universityId = _authRepo.user!.displayName;
    final userId = _authRepo.user!.uid;
    final scoreCards = await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .where("uploaderId", isEqualTo: userId)
        .orderBy("uploadDate", descending: true)
        .get();
    final scoreCardList = scoreCards.docs
        .map((e) => ScoreCardDataModel.fromJson(e.data()))
        .toList();
    return scoreCardList;
  }

  Future<List<ScoreCardDataModel>> fetchScoreCardsDataByUserId(
      String id) async {
    final universityId = _authRepo.user!.displayName;
    final scoreCards = await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .where("uploaderId", isEqualTo: id)
        .orderBy("uploadDate", descending: true)
        .get();
    final scoreCardList = scoreCards.docs
        .map((e) => ScoreCardDataModel.fromJson(e.data()))
        .toList();
    return scoreCardList;
  }

  Future<List<ScoreCardDataModel>> fetchTeamScoreCardsData() async {
    final universityId = _authRepo.user!.displayName;
    final scoreCards = await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .orderBy("uploadDate", descending: true)
        .get();
    final scoreCardList = scoreCards.docs
        .map((e) => ScoreCardDataModel.fromJson(e.data()))
        .toList();
    return scoreCardList;
  }
}

final scoreCardRepo = Provider((ref) => ScoreCardRepository());
