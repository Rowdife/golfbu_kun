import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> deleteAccount() async {
    final user = _authRepo.user;
    await _profileRepository.deleteProfile(
        uid: user!.uid, universityId: user.displayName);
    await _postRepository.deleteAllVideos();
    await _authRepo.deleteAccount();
    await _authRepo.signOut();
  }
}

final deleteAccountProvider =
    AsyncNotifierProvider<DeleteAccountViewModel, void>(
  () => DeleteAccountViewModel(),
);
