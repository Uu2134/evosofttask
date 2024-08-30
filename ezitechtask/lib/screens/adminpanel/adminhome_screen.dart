import 'package:ezitechtask/auth_provider.dart';
import 'package:ezitechtask/screens/adminpanel/adminattendancemanagement.dart';
import 'package:ezitechtask/screens/adminpanel/approveleave_screen.dart';
import 'package:ezitechtask/screens/adminpanel/generatereport_screen.dart';
import 'package:ezitechtask/screens/adminpanel/viewallstudents_screen.dart';
import 'package:ezitechtask/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
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
                      style: TextStyle(fontSize: 20)
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
                      ]
                    )
                  );
                }
              );
            }
          ),
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
      body: ListView(
        children: [
          _buildClickableContainer(
            context,
            AssetImage('images/viewAll.jpg'),
            'View All Students',
            ViewAllStudentsScreen(),
            Colors.blue,
          ),
          _buildClickableContainer(
            context,
            AssetImage('images/Manage.jpg'),
            'Manage Attendance',
            ManageAttendanceScreen(),
            Colors.green,
          ),
          _buildClickableContainer(
            context,
            AssetImage('images/leaveApproved.jpg'),
            'Approve Leaves',
            ApproveLeavesScreen(),
            Colors.orange,
          ),
          _buildClickableContainer(
            context,
            AssetImage('images/report.jpg'),
            'Generate Reports',
            GenerateReportsScreen(),
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildClickableContainer(
      BuildContext context,
      AssetImage image,
      String label,
      Widget destination,
      Color color
  ) {
    return GestureDetector(
      onTap: () => _navigateToDestination(context, destination),
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
            bottom: -15,
            child: _buildAnimatedButton(context, label, destination, color),
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(
      BuildContext context, String label, Widget destination, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Hero(
        tag: label,
        child: GestureDetector(
          onTapUp: (_) => _onButtonReleased(context, label, destination),
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

  void _onButtonReleased(BuildContext context, String label, Widget destination) {
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
  }

  void _navigateToDestination(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
