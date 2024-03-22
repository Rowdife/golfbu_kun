import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/score_card/models/scroe_card_courses_model.dart';

class ScoreCardRepository {
  // Implement your repository methods and functionality here
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  Future<List<ScoreCardcourseModel>> fetchScoreCardCourses() async {
    final universityId = _authRepo.user!.displayName;
    final courses = await _db
        .collection("university")
        .doc(universityId)
        .collection("courses")
        .get();
    final courseList = courses.docs
        .map((e) => ScoreCardcourseModel.fromJson(e.data()))
        .toList();
    return courseList;
  }

  Future<void> addNewScoreCardCourse(
      {required ScoreCardcourseModel course}) async {
    final universityId = _authRepo.user!.displayName;
    final courseJson = course.toJson();
    print(courseJson);
    await _db
        .collection("university")
        .doc(universityId)
        .collection("courses")
        .add(courseJson);
  }
}

final scoreCardProvider = Provider((ref) => ScoreCardRepository());
