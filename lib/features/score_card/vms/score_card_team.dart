import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/new_scorecard_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';

class ScoreCardTeamViewModel
    extends AsyncNotifier<List<NewScoreCardDataModel>> {
  late ScoreCardRepository _repository;

  Future<List<NewScoreCardDataModel>> fetchTeamScoreCardsData() async {
    final teamScoreCardsData = await _repository.fetchTeamScoreCardsData();
    state = AsyncValue.data(teamScoreCardsData);
    return teamScoreCardsData;
  }

  @override
  FutureOr<List<NewScoreCardDataModel>> build() async {
    _repository = ref.read(scoreCardRepo);
    state = const AsyncValue.loading();
    final scoreCardsData = await fetchTeamScoreCardsData();
    state = AsyncValue.data(scoreCardsData);
    return scoreCardsData;
  }
}

final scoreCardTeamProvider =
    AsyncNotifierProvider<ScoreCardTeamViewModel, List<NewScoreCardDataModel>>(
  () => ScoreCardTeamViewModel(),
);
