import 'package:ezitechtask/auth_provider.dart';
import 'package:ezitechtask/screens/userpanel/attendancescreen.dart';
import 'package:ezitechtask/screens/userpanel/leaverequest_screen.dart';
import 'package:ezitechtask/screens/userpanel/profileedit_screen.dart';
import 'package:ezitechtask/screens/userpanel/viewattendance_screen.dart';
import 'package:ezitechtask/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarkAttendanceScreen()),
              );
            },
            child: Text('Mark Attendance'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaveRequestScreen()),
              );
            },
            child: Text('Mark Leave'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAttendanceScreen()),
              );
            },
            child: Text('View Attendance'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            child: Text('Edit Profile Picture'),
          ),
        ],
      ),
    );
  }
}
