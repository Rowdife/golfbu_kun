import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<PostVideoModel>> {
  late final PostRepository _repository;
  List<PostVideoModel> _list = [];

  Future<List<PostVideoModel>> _fetchVideos() async {
    final result = await _repository.fetchVideos();
    final videos = result.docs.map(
      (doc) => PostVideoModel.fromJson(
        json: doc.data(),
      ),
    );
    return videos.toList();
  }

  @override
  FutureOr<List<PostVideoModel>> build() async {
    _repository = ref.read(postRepo);
    _list = await _fetchVideos();
    return _list;
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
