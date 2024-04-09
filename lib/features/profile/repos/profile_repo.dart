import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> createProfile(ProfileModel profile) async {
    _db
        .collection("university")
        .doc(profile.universityId)
        .collection("users")
        .doc(profile.uid)
        .set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile({
    required String uid,
  }) async {
    final universityId = FirebaseAuth.instance.currentUser!.displayName;
    final doc = await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(uid)
        .get();
    return doc.data();
  }

  Future<List<ProfileModel>> fetchAllProfileInMyTeam() async {
    final universityId = FirebaseAuth.instance.currentUser!.displayName;

    final doc = await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .get();
    return doc.docs.map((e) => ProfileModel.fromJson(e.data())).toList();
  }

  Future<void> deleteProfile({
    required String uid,
    required String? universityId,
  }) async {
    await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(uid)
        .delete();
  }

  Future<void> updateProfile({
    required String userName,
    required String userGrade,
  }) async {
    final universityId = FirebaseAuth.instance.currentUser!.displayName;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(uid)
        .update({
      "name": userName,
      "grade": userGrade,
    });
  }

  Future<void> updateAvatar(File file) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final fileRef = _storage.ref('avatars/$uid');
    await fileRef.putFile(file);
  }

  Future<void> updateAvatarById(
      {required File file, required String id}) async {
    final fileRef = _storage.ref('avatars/$id');
    await fileRef.putFile(file);
  }
}

final profileRepo = Provider((ref) => ProfileRepository());
