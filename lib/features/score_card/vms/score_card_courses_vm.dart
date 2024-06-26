import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';

class ScoreCardCourseViewModel
    extends AsyncNotifier<List<ScoreCardCourseModel>> {
  late ScoreCardRepository _repository;

  @override
  FutureOr<List<ScoreCardCourseModel>> build() async {
    _repository = ref.read(scoreCardRepo);
    state = const AsyncValue.loading();
    final courses = await _repository.fetchScoreCardCourses();
    state = AsyncValue.data(courses);
    return courses;
  }

  // course関連
  Future<void> addNewCourse(ScoreCardCourseModel course) async {
    // save course to repository
    await _repository.addNewScoreCardCourse(course: course);
  }

  fetchCourses() async {
    final courses = await _repository.fetchScoreCardCourses();
    state = AsyncValue.data(courses);
  }

  // Scorecard関連
  ScoreCardModel previewScoreCard() {
    final scorecard = ref.read(scoreCardForm.notifier).state;
    return ScoreCardModel(scorecard: scorecard);
  }
}

final scoreCardForm =
    StateProvider<Map<String, Map<String, dynamic>>>((ref) => {});

final scoreCardCourseProvider =
    AsyncNotifierProvider<ScoreCardCourseViewModel, List<ScoreCardCourseModel>>(
  () => ScoreCardCourseViewModel(),
);
