import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class DeleteAccountViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  late final ProfileRepository _profileRepository;
  late final PostRepository _postRepository;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
    _profileRepository = ref.read(profileRepo);
    _postRepository = ref.read(postRepo);
  }

  Future<void> deleteAccount(BuildContext context) async {
    final user = _authRepo.user;

    await _postRepository.deleteAllVideosInStorage();
    await _postRepository.deleteAllVideosInDB();
    await _profileRepository.deleteProfile(
        uid: user!.uid, universityId: user.displayName);
    await _authRepo.deleteAccount();
    context.go("/");
  }
}

final deleteAccountProvider =
    AsyncNotifierProvider<DeleteAccountViewModel, void>(
  () => DeleteAccountViewModel(),
);
