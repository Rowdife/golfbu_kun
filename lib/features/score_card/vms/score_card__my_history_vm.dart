import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';

class ScoreCardMyHistoryViewModel
    extends AsyncNotifier<List<ScoreCardDataModel>> {
  late ScoreCardRepository _repository;

  Future<List<ScoreCardDataModel>> fetchMyScoreCardsData() async {
    state = const AsyncValue.loading();
    final myScoreCardsData = await _repository.fetchMyScoreCardsData();
    state = AsyncValue.data(myScoreCardsData);
    return myScoreCardsData;
  }

  @override
  FutureOr<List<ScoreCardDataModel>> build() async {
    _repository = ref.read(scoreCardRepo);
    state = const AsyncValue.loading();
    final scoreCardsData = await fetchMyScoreCardsData();
    state = AsyncValue.data(scoreCardsData);
    return scoreCardsData;
  }

  Future<List<ScoreCardDataModel>> fetchScoreCardsDataByUserId(
      String id) async {
    state = const AsyncValue.loading();
    final myScoreCardsData = await _repository.fetchScoreCardsDataByUserId(id);
    state = AsyncValue.data(myScoreCardsData);
    return myScoreCardsData;
  }
}

final scoreCardMyHisotryProvider = AsyncNotifierProvider<
    ScoreCardMyHistoryViewModel, List<ScoreCardDataModel>>(
  () => ScoreCardMyHistoryViewModel(),
);
