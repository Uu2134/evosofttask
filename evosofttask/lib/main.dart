import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezitechtask/providers/attendanceprovider.dart';
import 'package:ezitechtask/providers/theme_provider.dart';
import 'package:ezitechtask/screens/adminpanel/adminhome_screen.dart';
import 'package:ezitechtask/screens/signin_screen.dart';
import 'package:ezitechtask/screens/userpanel/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        builder: (context) {
          final _themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Attendance Management System',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: _themeProvider.themeMode,
            home: AuthChecker(),
          );
        }
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return StreamBuilder<firebase_auth.User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: authProvider.getUserRole(snapshot.data!.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (roleSnapshot.hasData) {
                String? role = roleSnapshot.data;
                if (role == 'admin') {
                  return AdminHomePage();
                } else {
                  return UserHomePage();
                }
              }
              return SignInScreen();
            },
          );
        }
        return SignInScreen();
      },
    );
  }
}

