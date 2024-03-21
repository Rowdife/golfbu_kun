import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthenticationRepository _authRepo = AuthenticationRepository();
// video 関連
  UploadTask uploadVideo(
      {required File video, required String uid, required int createdAt}) {
    final fileRef =
        _storage.ref().child("/videos/$uid/${createdAt.toString()}");
    return fileRef.putFile(video);
  }

  Future<String> saveVideo(
      {required PostVideoModel video, required ProfileModel profile}) async {
    final docRef = await _db
        .collection("university")
        .doc(profile.universityId)
        .collection("videos")
        .add(video.toJson());

    final videoId = docRef.id;
    return videoId;
  }

  Future<void> deleteVideo({required int createdAt}) async {
    final universityId = _authRepo.user!.displayName;
    final userId = _authRepo.user!.uid;
    final snapshot = await _db
        .collection("university")
        .doc(universityId)
        .collection("videos")
        .where("createdAt", isEqualTo: createdAt)
        .get();
    await snapshot.docs.first.reference.delete();
    await _storage.ref().child("videos/$userId/$createdAt").delete();
  }

  Future<void> deleteAllVideos() async {
    final userId = _authRepo.user!.uid;
    final allVideosRef = _storage.ref().child("videos/$userId");
    try {
      final allVideos = await allVideosRef.listAll();
      if (allVideos.items.isNotEmpty) {
        print("You have some videos so I'll delete it.");
        for (final Reference ref in allVideos.items) {
          await ref.delete();
        }
      } else {
        print("You don't have any. I'll do nothing.");
      }
    } catch (e) {
      print("You don't have any. I'll do nothing.");
      return;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    final universityId = _authRepo.user!.displayName;

    final query = _db
        .collection("university")
        .doc(universityId)
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(5);

    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

// comment　関連
  Future<void> saveVideoComment({
    required PostCommentModel comment,
    required int createdAt,
  }) async {
    final universityId = _authRepo.user!.displayName;
    final querySnapshot = await _db
        .collection("university")
        .doc(universityId)
        .collection("videos")
        .where("createdAt", isEqualTo: createdAt)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final videoDoc = querySnapshot.docs.first;
      final videoId = videoDoc.id;

      await _db
          .collection("university")
          .doc(universityId)
          .collection("videos")
          .doc(videoId)
          .collection("comments")
          .add(comment.toJson());

      await videoDoc.reference.update({'comments': FieldValue.increment(1)});
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCommentIds({
    required String videoId,
    required String? universityId,
  }) async {
    return _db
        .collection("university")
        .doc(universityId)
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .get();
  }

  Future<List<PostCommentModel>> fetchCommentsByCreatedAt(
      {required int createdAt}) async {
    final universityId = _authRepo.user!.displayName;
    final query = await _db
        .collection("university")
        .doc(universityId)
        .collection("videos")
        .where("createdAt", isEqualTo: createdAt)
        .get();
    final commentsQuery =
        await query.docs.first.reference.collection("comments").get();
    final commets = commentsQuery.docs.map((doc) => doc.data());
    final postComments =
        commets.map((json) => PostCommentModel.fromJson(json: json));
    return postComments.toList();
  }

  Future<List<PostCommentModel>> fetchCommentsByVideoId({
    required String videoId,
  }) async {
    final universityId = _authRepo.user!.displayName;
    final snapshot = await _db
        .collection("university")
        .doc(universityId)
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .orderBy("createdAtUnix", descending: false)
        .get();

    List<PostCommentModel> comments = snapshot.docs
        .map((doc) => PostCommentModel.fromJson(json: doc.data()))
        .toList();

    return comments;
  }
}

final postRepo = Provider((ref) => PostRepository());
