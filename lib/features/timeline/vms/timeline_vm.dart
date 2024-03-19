import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<PostVideoModel>> {
  late final PostRepository _repository;
  List<PostVideoModel> _list = [];

  Future<List<PostVideoModel>> _fetchVideos() async {
    final user = ref.read(authRepo).user;
    final result = await _repository.fetchVideos(user!.displayName);
    final videos = result.docs.map(
      (doc) => PostVideoModel.fromJson(
        json: doc.data(),
      ),
    );
    videos.toList().forEach((video) {});
    return videos.toList();
  }

  @override
  FutureOr<List<PostVideoModel>> build() async {
    _repository = ref.read(postRepo);
    _list = await _fetchVideos();
    return _list;
  }

  Future<void> refresh() async {
    try {
      final videos = await _fetchVideos();
      _list = videos;
      state = AsyncValue.data(videos); // 상태 갱신
    } catch (e, s) {
      state = AsyncValue.error(e, s); // 에러 처리
    }
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<PostVideoModel>>(
  () => TimelineViewModel(),
);
