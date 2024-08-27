import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarkAttendanceScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _markAttendance(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    DateTime today = DateTime.now();
    String formattedDate = "${today.year}-${today.month}-${today.day}";

    DocumentReference attendanceDoc = _firestore
        .collection('attendance')
        .doc('${user.uid}-$formattedDate');

    DocumentSnapshot attendanceSnapshot = await attendanceDoc.get();

    if (!attendanceSnapshot.exists) {
      await attendanceDoc.set({
        'userId': user.uid,
        'date': formattedDate,
        'isPresent': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance already marked for today')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mark Attendance")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _markAttendance(context),
          child: Text("Mark as Present"),
        ),
      ),
    );
  }
}
