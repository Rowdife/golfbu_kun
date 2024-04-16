import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';

class TimelineTeamListViewModel extends AsyncNotifier<List<ProfileModel>> {
  late final ProfileRepository _profileRepo;

  @override
  FutureOr<List<ProfileModel>> build() async {
    _profileRepo = ref.read(profileRepo);
    state = const AsyncValue.loading();
    final teamMemberProfileList = await _profileRepo.fetchAllProfileInMyTeam();
    state = AsyncValue.data(teamMemberProfileList);
    return teamMemberProfileList;
  }
}

final timelineTeamListProvider =
    AsyncNotifierProvider<TimelineTeamListViewModel, List<ProfileModel>>(
  () => TimelineTeamListViewModel(),
);
