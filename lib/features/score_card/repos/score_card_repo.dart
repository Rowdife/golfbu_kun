import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';

class ScoreCardRepository {
  // Implement your repository methods and functionality here
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  Future<List<ScoreCardCourseModel>> fetchScoreCardCourses() async {
    final universityId = _authRepo.user!.displayName;
    final courses = await _db
        .collection("university")
        .doc(universityId)
        .collection("courses")
        .get();
    final courseList = courses.docs
        .map((e) => ScoreCardCourseModel.fromJson(e.data()))
        .toList();
    return courseList;
  }

  Future<void> addNewScoreCardCourse(
      {required ScoreCardCourseModel course}) async {
    final universityId = _authRepo.user!.displayName;
    final courseJson = course.toJson();
    await _db
        .collection("university")
        .doc(universityId)
        .collection("courses")
        .add(courseJson);
  }

  Future<void> uploadScoreCard(
      {required ScoreCardDataModel scoreCardData}) async {
    final universityId = _authRepo.user!.displayName;
    final scoreCardJson = scoreCardData.toJson();
    await _db
        .collection("university")
        .doc(universityId)
        .collection("scorecards")
        .add(scoreCardJson);
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
