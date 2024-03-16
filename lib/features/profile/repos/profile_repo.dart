import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile(ProfileModel profile) async {
    _db.collection("users").doc(profile.uid).set(profile.toJson());
  }
}

final userRepo = Provider((ref) => UserRepository());
