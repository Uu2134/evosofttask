import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApproveLeavesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _approveLeave(String docId) async {
    await _firestore.collection('leaveRequests').doc(docId).update({'status': 'Approved'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Approve Leaves')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('leaveRequests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No leave requests found'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return ListTile(
                  title: Text('Invalid data'),
                );
              }
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('User: ${data['userId']} - Reason: ${data['reason']}'),
                  subtitle: Text('Status: ${data['status']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _approveLeave(doc.id),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
