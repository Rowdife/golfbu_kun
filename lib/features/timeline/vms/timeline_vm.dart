import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<PostVideoModel>> {
  late final PostRepository _repository;
  List<PostVideoModel> _list = [];

  Future<List<PostVideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result = await _repository.fetchVideos(
      lastItemCreatedAt: lastItemCreatedAt,
    );
    final videos = result.docs.map(
      (doc) => PostVideoModel.fromJson(
        json: doc.data(),
      ),
    );
    state = AsyncValue.data(videos.toList());
    return videos.toList();
  }

  @override
  FutureOr<List<PostVideoModel>> build() async {
    _repository = ref.read(postRepo);
    state = const AsyncValue.loading();
    _list = await _fetchVideos(lastItemCreatedAt: null);
    state = AsyncValue.data(_list);
    return _list;
  }

  fetchNextVideos() async {
    final nextVideosData =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    _list = [..._list, ...nextVideosData];
    state = AsyncValue.data(_list);
  }

  Future<List<PostCommentModel>> fetchComments({required int createdAt}) async {
    final comments =
        await _repository.fetchCommentsByCreatedAt(createdAt: createdAt);
    return comments;
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos();
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<PostVideoModel>>(
  () => TimelineViewModel(),
);
