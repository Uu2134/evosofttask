import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ezitechtask/auth_provider.dart';
import 'package:ezitechtask/screens/adminpanel/adminhome_screen.dart';
import 'package:ezitechtask/screens/userpanel/home_screen.dart';
import 'package:ezitechtask/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      String? message = await authProvider.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (message != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                      } else {
                        firebase_auth.User? user = authProvider.currentUser();
                        if (user != null) {
                          String? role = await authProvider.getUserRole(user.uid);
                          if (role == 'admin') {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminHomePage()));
                          } else {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserHomePage()));
                          }
                        }
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Text('Sign In'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
