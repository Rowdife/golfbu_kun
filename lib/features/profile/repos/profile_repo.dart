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
        .collection(profile.universityId)
        .doc(profile.uid)
        .set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile({
    required String uid,
  }) async {
    final doc = await _db.collection("university").doc(uid).get();
    return doc.data();
  }
}

final profileRepo = Provider((ref) => ProfileRepository());
