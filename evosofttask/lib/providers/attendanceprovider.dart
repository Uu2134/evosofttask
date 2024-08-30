import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(String userId) async {
    DateTime today = DateTime.now();
    String formattedDate = "${today.year}-${today.month}-${today.day}";

    DocumentReference attendanceDoc = _firestore
        .collection('attendance')
        .doc('${userId}-$formattedDate');

    DocumentSnapshot attendanceSnapshot = await attendanceDoc.get();

    if (!attendanceSnapshot.exists) {
      await attendanceDoc.set({
        'userId': userId,
        'date': formattedDate,
        'isPresent': true,
      });
      notifyListeners();
    } else {
      throw Exception('Attendance already marked for today');
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceRecords(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
