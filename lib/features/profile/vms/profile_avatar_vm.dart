import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';

class ProfileAvatarViewModel extends AsyncNotifier<void> {
  late final ProfileRepository _profileRepo;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  FutureOr<void> build() {
    _profileRepo = ref.read(profileRepo);
  }

  Future<void> updateAvatar(File file) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async => await _profileRepo.updateAvatar(file),
    );
  }
}

final profileAvatarProvider =
    AsyncNotifierProvider<ProfileAvatarViewModel, void>(
  () => ProfileAvatarViewModel(),
);
