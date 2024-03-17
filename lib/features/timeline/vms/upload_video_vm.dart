import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final PostRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(postRepo);
  }

  Future<void> uploadVideo(
    File video,
    String description,
    BuildContext context,
  ) async {
    final user = ref.read(authRepo).user;
    final profile = await ref.read(profileRepo).findProfile(user!.uid);

    if (profile != null) {
      final profileData = ProfileModel.fromJson(profile);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          final task = await _repository.uploadVideo(video, user.uid);

          if (task.metadata != null) {
            await _repository.saveVideo(
              PostVideoModel(
                description: description,
                fileUrl: await task.ref.getDownloadURL(),
                uploaderUid: user.uid,
                comments: 0,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                uploaderName: profileData.name,
              ),
            );
          }
          context.pop();
          context.pop();
        },
      );
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
