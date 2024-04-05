import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    required String? universityId,
  }) async {
    final doc = await _db
        .collection("university")
        .doc(universityId)
        .collection("users")
        .doc(uid)
        .get();
    return doc.data();
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
}

final profileRepo = Provider((ref) => ProfileRepository());
