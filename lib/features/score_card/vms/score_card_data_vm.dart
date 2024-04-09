import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/repos/score_card_repo.dart';

class ScoreCardDataViewModel extends AsyncNotifier<ScoreCardDataModel> {
  late final ScoreCardRepository _scoreCardRepo;

  @override
  Future<ScoreCardDataModel> build() async {
    _scoreCardRepo = ref.read(scoreCardRepo);
    state = const AsyncValue.loading();
    final userId = ref.read(authRepo).user!.uid;
    final scoreCardData = await _scoreCardRepo.fetchScoreDataByUserId(userId);
    state = AsyncValue.data(scoreCardData);
    return scoreCardData;
  }

  Future<ScoreCardDataModel> fetchScoreCardDataById({String? id}) async {
    final userId = ref.read(authRepo).user!.uid;
    if (id != null) {
      final scoreCardData = await _scoreCardRepo.fetchScoreDataByUserId(id);
      state = AsyncValue.data(scoreCardData);
      return scoreCardData;
    } else {
      final scoreCardData = await _scoreCardRepo.fetchScoreDataByUserId(userId);
      state = AsyncValue.data(scoreCardData);
      return scoreCardData;
    }
  }
}

final scoreDataProvider =
    AsyncNotifierProvider<ScoreCardDataViewModel, ScoreCardDataModel>(
  () => ScoreCardDataViewModel(),
);
