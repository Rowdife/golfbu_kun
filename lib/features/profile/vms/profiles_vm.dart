import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';

class ProfilesViewModel extends AsyncNotifier<ProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<ProfileModel> build() {
    _repository = ref.read(userRepo);
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

    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}

final profileProvider = AsyncNotifierProvider<ProfilesViewModel, ProfileModel>(
    () => ProfilesViewModel());
