import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String userId;
  final DateTime date;
  final bool present;

  Attendance({required this.userId, required this.date, required this.present});

  factory Attendance.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Attendance(
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      present: data['present'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'present': present,
    };
  }
}

class AttendanceProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(String userId) async {
    DateTime now = DateTime.now();
    String todayDateStr = "${now.year}-${now.month}-${now.day}";

    var todayAttendance = await _firestore.collection('attendance')
      .where('userId', isEqualTo: userId)
      .where('date', isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
      .where('date', isLessThan: DateTime(now.year, now.month, now.day + 1))
      .get();

    if (todayAttendance.docs.isEmpty) {
      await _firestore.collection('attendance').add({
        'userId': userId,
        'date': Timestamp.fromDate(now),
        'present': true,
      });
    } else {
      throw Exception('Attendance already marked for today');
    }
    notifyListeners();
  }

  Future<List<Attendance>> getAttendanceRecords(String userId) async {
    var attendanceSnapshot = await _firestore.collection('attendance')
      .where('userId', isEqualTo: userId)
      .get();

    List<Attendance> attendanceRecords = attendanceSnapshot.docs
      .map((doc) => Attendance.fromFirestore(doc))
      .toList();

    return attendanceRecords;
  }

  // Additional methods for handling attendance data
}
