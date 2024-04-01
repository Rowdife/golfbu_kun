import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';

class ScoreCardTeamViewModel extends AsyncNotifier<List<ScoreCardDataModel>> {
  late ScoreCardRepository _repository;

  Future<List<ScoreCardDataModel>> fetchTeamScoreCardsData() async {
    final teamScoreCardsData = await _repository.fetchTeamScoreCardsData();
    state = AsyncValue.data(teamScoreCardsData);
    return teamScoreCardsData;
  }

  @override
  FutureOr<List<ScoreCardDataModel>> build() async {
    _repository = ref.read(scoreCardRepo);
    state = const AsyncValue.loading();
    final scoreCardsData = await fetchTeamScoreCardsData();
    state = AsyncValue.data(scoreCardsData);
    return scoreCardsData;
  }
}

final scoreCardTeamProvider =
    AsyncNotifierProvider<ScoreCardTeamViewModel, List<ScoreCardDataModel>>(
  () => ScoreCardTeamViewModel(),
);
