import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> calculateGrade(String userId) async {
    QuerySnapshot attendanceSnapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: userId)
        .get();

    int attendanceCount = attendanceSnapshot.docs.length;

    if (attendanceCount >= 26) {
      return 'A';
    } else if (attendanceCount >= 20) {
      return 'B';
    } else if (attendanceCount >= 15) {
      return 'C';
    } else if (attendanceCount >= 10) {
      return 'D';
    } else {
      return 'F';
    }
  }
}
