import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezitechtask/auth_provider.dart';
import 'package:ezitechtask/screens/userpanel/attendancescreen.dart';
import 'package:ezitechtask/screens/userpanel/leaverequest_screen.dart';
import 'package:ezitechtask/screens/userpanel/profileedit_screen.dart';
import 'package:ezitechtask/screens/userpanel/viewattendance_screen.dart';
import 'package:ezitechtask/screens/signin_screen.dart';

import '../../providers/theme_provider.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Panel'),
        actions: [
          IconButton(
            icon: Icon(_themeProvider.icon),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Choose Theme',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () {
                            _themeProvider.changeTheme(ThemeMode.light);
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.light_mode),
                          title: Text('Light Mode'),
                        ),
                        ListTile(
                          onTap: () {
                            _themeProvider.changeTheme(ThemeMode.dark);
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.dark_mode),
                          title: Text('Dark Mode'),
                        ),
                        ListTile(
                          onTap: () {
                            _themeProvider.changeTheme(ThemeMode.system);
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.smartphone),
                          title: Text('System Mode'),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
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
      body: ListView(
        children: [
          _buildClickableContainer(
            context,
            AssetImage('images/markAttendance2.jpg'),
            'Mark Attendance',
            'attendance',
            MarkAttendanceScreen(),
            Colors.blue,
          ),
          _buildClickableContainer(
            context,
            AssetImage('images/leaveRequest.jpg'),
            'Mark Leave',
            'leave',
            LeaveRequestScreen(),
            Colors.green
          ),
          _buildClickableContainer(
            context,
            AssetImage('images/viewAttendance.jpg'),
            'View Attendance',
            'viewAttendance',
            ViewAttendanceScreen(),
            Colors.orange
          ),
          _buildClickableContainer(
            context,
            AssetImage('images/editProfile.jpg'),
            'Edit Profile Picture',
            'editProfile',
            EditProfileScreen(),
            Colors.red
          ),
        ],
      ),
    );
  }

  Widget _buildClickableContainer(
      BuildContext context,
      AssetImage image,
      String label,
      String tag,
      Widget destination,
      Color color
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => destination,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
            elevation: 5,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: image,
                        fit: BoxFit.cover
                    )
                )
            ),
          ),
          Positioned(
            bottom: -25,
            child: _buildAnimatedButton(context, label, tag, destination, color),
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(
      BuildContext context,String label, String tag, Widget destination, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => destination,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: MediaQuery.of(context).size.width / 1.5,
            transform: Matrix4.translationValues(
              0,
              -5.0,
              0,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(label, style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
