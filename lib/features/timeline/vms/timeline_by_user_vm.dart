import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class TimelineByUserViewModel extends AsyncNotifier<List<PostVideoModel>> {
  late final PostRepository _repository;
  List<PostVideoModel> _list = [];

  Future<List<PostVideoModel>> _fetchVideos() async {
    final result =
        await _repository.fetchVideosByUserId(ref.read(authRepo).user!.uid);
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
    _list = await _fetchVideos();
    state = AsyncValue.data(_list);
    return _list;
  }

  Future<List<PostCommentModel>> fetchComments({required int createdAt}) async {
    final comments =
        await _repository.fetchCommentsByCreatedAt(createdAt: createdAt);
    return comments;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final videos = await _fetchVideos();
    _list = videos;
    state = AsyncValue.data(videos);
  }

  Future<List<PostVideoModel>> fetchVideosById(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchVideosByUserId(id);
    final videos = result.docs.map(
      (doc) => PostVideoModel.fromJson(
        json: doc.data(),
      ),
    );
    state = AsyncValue.data(videos.toList());
    return videos.toList();
  }
}

final timelineByUserProvider =
    AsyncNotifierProvider<TimelineByUserViewModel, List<PostVideoModel>>(
  () => TimelineByUserViewModel(),
);
