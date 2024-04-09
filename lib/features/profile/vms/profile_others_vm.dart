import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';

class ProfilesOthersViewModel extends AsyncNotifier<ProfileModel> {
  late final AuthenticationRepository _authRepo;
  late final ProfileRepository _profileRepo;

  @override
  FutureOr<ProfileModel> build() async {
    _authRepo = ref.read(authRepo);
    _profileRepo = ref.read(profileRepo);

    state = const AsyncValue.loading();

    if (_authRepo.isLoggedIn) {
      final profile = await _profileRepo.findProfile(uid: _authRepo.user!.uid);
      if (profile != null) {
        state = AsyncValue.data(ProfileModel.fromJson(profile));
        return ProfileModel.fromJson(profile);
      }
    }

    return ProfileModel.empty();
  }

  Future<ProfileModel> fetchProfileByUserId(String id) async {
    final profile = await _profileRepo.findProfile(uid: id);
    state = AsyncValue.data(ProfileModel.fromJson(profile!));
    return ProfileModel.fromJson(profile);
  }

  void resetProfile() async {
    state = const AsyncValue.loading();

    state = AsyncValue.data(ProfileModel.empty());
  }
}

final profileOthersProvider =
    AsyncNotifierProvider<ProfilesOthersViewModel, ProfileModel>(
        () => ProfilesOthersViewModel());
