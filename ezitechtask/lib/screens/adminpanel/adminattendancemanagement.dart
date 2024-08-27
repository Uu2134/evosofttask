import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAttendanceScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteAttendance(String docId) async {
    await _firestore.collection('attendance').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Attendance')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('attendance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No attendance records found'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return ListTile(
                  title: Text('Invalid data'),
                );
              }
              return ListTile(
                title: Text('User: ${data['userId']} - Date: ${data['date']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteAttendance(doc.id),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
