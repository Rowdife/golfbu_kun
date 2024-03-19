import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';

class DeleteAccountViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  late final ProfileRepository _profileRepository;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
    _profileRepository = ref.read(profileRepo);
  }

  Future<void> deleteAccount() async {
    final user = _authRepo.user;
    await _authRepo.deleteAccount();
    await _profileRepository.deleteProfile(
        uid: user!.uid, universityId: user.displayName);
  }
}

final deleteAccountProvider =
    AsyncNotifierProvider<DeleteAccountViewModel, void>(
  () => DeleteAccountViewModel(),
);
