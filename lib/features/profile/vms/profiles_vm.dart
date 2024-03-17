import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';

class ProfilesViewModel extends AsyncNotifier<ProfileModel> {
  late final AuthenticationRepository _authRepo;
  late final ProfileRepository _profileRepo;

  @override
  FutureOr<ProfileModel> build() async {
    _authRepo = ref.read(authRepo);
    _profileRepo = ref.read(profileRepo);

    state = const AsyncValue.loading();

    if (_authRepo.isLoggedIn) {
      final profile = await _profileRepo.findProfile(_authRepo.user!.uid);
      if (profile != null) {
        state = AsyncValue.data(ProfileModel.fromJson(profile));
        return ProfileModel.fromJson(profile);
      }
    }

    return ProfileModel.empty();
  }

  Future<void> createProfile({
    required UserCredential credential,
    required String university,
    required String position,
    required String sex,
    required String name,
  }) async {
    state = const AsyncValue.loading();

    final profile = ProfileModel(
      uid: credential.user!.uid,
      university: university,
      position: position,
      sex: sex,
      name: name,
      email: credential.user!.email ?? "",
    );

    await _profileRepo.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final profileProvider = AsyncNotifierProvider<ProfilesViewModel, ProfileModel>(
    () => ProfilesViewModel());
