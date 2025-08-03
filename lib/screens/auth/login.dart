import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    String hashPassword(String password) {
      final bytes = utf8.encode(password);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final hashedPassword = hashPassword(password);

    if (email.isEmpty || hashedPassword.isEmpty) {
      _showError("Please enter both email and password");
      return;
    }

    final dbHelper = DBHelper();
    final user = await dbHelper.getUserByEmail(email);

    if (user != null && user['pwd'] == hashedPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user['user_dim_id']);

      Navigator.pushReplacementNamed(context, '/home'); // or your main page
    } else {
      _showError("Invalid email or password");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(height: 60),
              Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),

              // Email
              Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              SizedBox(height: 4),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              SizedBox(height: 4),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Row: Remember Me and Forgot
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val!;
                      });
                    },
                    activeColor: Colors.deepPurple,
                  ),
                  Text("Remember me"),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // Add your forgot login logic here
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Colors.deepPurple, // splash + highlight color
                    ),
                    child: const Text(
                      "Forgot login?",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        decoration:
                            TextDecoration.underline, // underline the text
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Bottom Text
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup1');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87, // Controls splash highlight
                ),
                child: const Text(
                  "Don’t have an account? Click here to create one.",
                  style: TextStyle(
                    color: Colors.black87,
                    decoration: TextDecoration.underline, // Makes it underlined
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
