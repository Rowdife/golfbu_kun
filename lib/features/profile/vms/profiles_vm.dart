import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      final profile = await _profileRepo.findProfile(
          uid: _authRepo.user!.uid, universityId: _authRepo.user!.displayName);
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
    required String universityId,
    required String position,
    required String grade,
    required String sex,
    required String name,
  }) async {
    state = const AsyncValue.loading();

    final profile = ProfileModel(
      uid: credential.user!.uid,
      university: university,
      universityId: universityId,
      position: position,
      grade: grade,
      sex: sex,
      name: name,
      email: credential.user!.email ?? "",
    );

    await _profileRepo.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<ProfileModel> fetchProfile() async {
    final profile = await _profileRepo.findProfile(
        uid: _authRepo.user!.uid, universityId: _authRepo.user!.displayName);
    state = AsyncValue.data(ProfileModel.fromJson(profile!));
    return ProfileModel.fromJson(profile);
  }

  void resetProfile() async {
    state = const AsyncValue.loading();

    state = AsyncValue.data(ProfileModel.empty());
  }
}

final profileProvider = AsyncNotifierProvider<ProfilesViewModel, ProfileModel>(
    () => ProfilesViewModel());
