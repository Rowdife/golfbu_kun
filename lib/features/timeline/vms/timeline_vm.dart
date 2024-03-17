import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<PostVideoModel>> {
  late final PostRepository _repository;
  List<PostVideoModel> _list = [];

  @override
  FutureOr<List<PostVideoModel>> build() async {
    _repository = ref.read(postRepo);
    final result = await _repository.fetchVideos();
    final newList = result.docs.map(
      (doc) => PostVideoModel.fromJson(
        doc.data(),
      ),
    );
    _list = newList.toList();
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<PostVideoModel>>(
  () => TimelineViewModel(),
);
