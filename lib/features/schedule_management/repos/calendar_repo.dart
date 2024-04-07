import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/schedule_management/models/calendar_event_model.dart';

class CalendarRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadSchedule(CalendarEventModel schedule) async {
    final universityId = _auth.currentUser!.displayName;
    await _db
        .collection('university')
        .doc(universityId)
        .collection('calendar')
        .add(schedule.toJson());
    await getAllSchedule();
  }

  Future<List<CalendarEventModel>> getScheduleListByDate(String date) async {
    final universityId = _auth.currentUser!.displayName;
    final snapshot = await _db
        .collection('university')
        .doc(universityId)
        .collection('calendar')
        .where('scheduleStartDate', isEqualTo: date)
        .get();
    return snapshot.docs
        .map((doc) => CalendarEventModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<CalendarEventModel>> getAllSchedule() async {
    final universityId = _auth.currentUser!.displayName;
    final snapshot = await _db
        .collection('university')
        .doc(universityId)
        .collection('calendar')
        .get();
    return snapshot.docs
        .map((doc) => CalendarEventModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> deleteSchedule(int createdAt) async {
    final universityId = _auth.currentUser!.displayName;
    final snapshot = await _db
        .collection('university')
        .doc(universityId)
        .collection('calendar')
        .where('createdAt', isEqualTo: createdAt)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      await doc.reference.delete();
    }
  }
}

final calendarRepo = Provider<CalendarRepository>((ref) {
  return CalendarRepository();
});
