import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideo(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(PostVideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos() {
    return _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .get();
  }
}

final postRepo = Provider((ref) => PostRepository());
