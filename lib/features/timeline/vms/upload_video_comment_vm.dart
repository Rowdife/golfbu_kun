import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';

class UploadVideoCommentViewModel extends AsyncNotifier<List<String>> {
  late final PostRepository _repository;
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<List<String>> build() async {
    _repository = ref.read(postRepo);
    _authRepo = ref.read(authRepo);

    final result = await _repository.fetchVideos();
    final videoIds = result.docs.map((doc) => doc.id).toList();

    return videoIds;
  }

  Future<List<String>> fetchVideoIdForComment() async {
    final result = await ref.read(postRepo).fetchVideos();

    final videoIds = result.docs.map((doc) => doc.id).toList();

    return videoIds;
  }

  Future<void> uploadVideoComment({
    required PostCommentModel comment,
    required int createdAt,
  }) async {
    _repository.saveVideoComment(
      comment: comment,
      createdAt: createdAt,
    );
  }

  Future<List<String>> fetchVideoCommentsIdsByVideoId(String videoId) async {
    final commentIdList = await _repository.fetchCommentIds(
        videoId: videoId, universityId: _authRepo.user!.displayName);
    final commentIds = commentIdList.docs.map((doc) => doc.id);
    return commentIds.toList();
  }

  Future<List<PostCommentModel>> fetchCommentsByVideoId(String videoId) async {
    return _repository.fetchCommentsByVideoId(videoId: videoId);
  }

  void deleteVideoComment({
    required int createdAt,
    required int commentCreatedAtUnix,
  }) {
    _repository.deleteCommentByCreatedAt(
        createdAt: createdAt, commentCreatedAtUnix: commentCreatedAtUnix);
  }
}

final uploadVideoCommentProvider =
    AsyncNotifierProvider<UploadVideoCommentViewModel, List<String>>(
  () => UploadVideoCommentViewModel(),
);
