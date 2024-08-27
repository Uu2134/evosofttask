import 'package:ezitechtask/auth_provider.dart';
import 'package:ezitechtask/screens/adminpanel/adminattendancemanagement.dart';
import 'package:ezitechtask/screens/adminpanel/approveleave_screen.dart';
import 'package:ezitechtask/screens/adminpanel/generatereport_screen.dart';
import 'package:ezitechtask/screens/adminpanel/viewallstudents_screen.dart';
import 'package:ezitechtask/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAllStudentsScreen()),
              );
            },
            child: Text('View All Students'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageAttendanceScreen()),
              );
            },
            child: Text('Manage Attendance'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApproveLeavesScreen()),
              );
            },
            child: Text('Approve Leaves'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerateReportsScreen()),
              );
            },
            child: Text('Generate Reports'),
          ),
        ],
      ),
    );
  }
}
