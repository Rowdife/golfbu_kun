import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/courses/repos/score_card_repo.dart';
import 'package:golfbu_kun/features/score_card/models/scroe_card_courses_model.dart';

class ScoreCardCourseViewModel
    extends AsyncNotifier<List<ScoreCardcourseModel>> {
  late ScoreCardRepository _repository;

  @override
  FutureOr<List<ScoreCardcourseModel>> build() async {
    _repository = ref.read(scoreCardProvider);
    state = const AsyncValue.loading();
    final courses = await _repository.fetchScoreCardCourses();
    state = AsyncValue.data(courses);
    return courses;
  }

  addNewCourse(ScoreCardcourseModel course) {
    // save course to repository
    _repository.addNewScoreCardCourse(course: course);
  }

  fetchCourses() async {
    final courses = await _repository.fetchScoreCardCourses();
    state = AsyncValue.data(courses);
  }
}

final scoreCardCourseProvider =
    AsyncNotifierProvider<ScoreCardCourseViewModel, List<ScoreCardcourseModel>>(
  () => ScoreCardCourseViewModel(),
);
