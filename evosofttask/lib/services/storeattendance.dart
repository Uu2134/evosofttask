import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezitechtask/screens/user.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(String userId) async {
    DateTime today = DateTime.now();
    String formattedDate = "${today.year}-${today.month}-${today.day}";

    CollectionReference attendanceCollection = _firestore.collection('attendance');

    // Check if attendance for today is already marked
    QuerySnapshot existingAttendance = await attendanceCollection
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: formattedDate)
        .get();

    if (existingAttendance.docs.isEmpty) {
      // Mark attendance for today
      await attendanceCollection.add({
        'userId': userId,
        'date': formattedDate,
        'isPresent': true,
      });
    } else {
      throw Exception('Attendance already marked for today');
    }
  }

  Future<List<Attendance>> getAttendanceRecords(String userId) async {
    CollectionReference attendanceCollection = _firestore.collection('attendance');

    QuerySnapshot querySnapshot = await attendanceCollection
        .where('userId', isEqualTo: userId)
        .get();

    List<Attendance> attendanceList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Attendance(
        userId: data['userId'],
        date: DateTime.parse(data['date']),
        isPresent: data['isPresent'],
      );
    }).toList();

    return attendanceList;
  }
}
