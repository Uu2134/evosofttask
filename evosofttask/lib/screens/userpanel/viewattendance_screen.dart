import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewAttendanceScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchAttendanceRecords() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    QuerySnapshot querySnapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Attendance")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAttendanceRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No attendance records found.'));
          }

          List<Map<String, dynamic>> records = snapshot.data!;

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> record = records[index];
              return ListTile(
                title: Text('Date: ${record['date']}'),
                subtitle: Text('Status: ${record['isPresent'] ? "Present" : "Absent"}'),
              );
            },
          );
        },
      ),
    );
  }
}
