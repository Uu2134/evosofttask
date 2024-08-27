import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to view all students screen
              },
              child: Text("View All Students"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to attendance management screen
              },
              child: Text("Manage Attendance"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to leave approval screen
              },
              child: Text("Approve Leaves"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to report generation screen
              },
              child: Text("Generate Reports"),
            ),
          ],
        ),
      ),
    );
  }
}
