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

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: Duration(seconds: 3),
            onEnd: () {
              // Loop animation
              _animationController.reset();
              _animationController.forward();
            },
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Title
                    Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildAnimatedTextField(
                      context,
                      _emailController,
                      'Email',
                      Icons.email,
                    ),
                    SizedBox(height: 20),
                    _buildAnimatedTextField(
                      context,
                      _passwordController,
                      'Password',
                      Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 40),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _buildAnimatedButton(context, authProvider),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField(BuildContext context,
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, AuthProvider authProvider) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _isLoading = true;
      }),
      onTapUp: (_) => _signIn(context, authProvider),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context, AuthProvider authProvider) async {
    String? message = await authProvider.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      firebase_auth.User? user = authProvider.currentUser();
      if (user != null) {
        String? role = await authProvider.getUserRole(user.uid);
        if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminHomePage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserHomePage()),
          );
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
