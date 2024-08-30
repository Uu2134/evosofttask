import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile Picture')),
      body: Center(
        child: Hero(
          tag: 'editProfile',
          child: ElevatedButton(
            onPressed: () {
              // Implement profile picture editing functionality
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurpleAccent,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor: Colors.deepPurple,
              elevation: 8,
            ),
            child: Text('Edit Profile Picture'),
          ),
        ),
      ),
    );
  }
}
