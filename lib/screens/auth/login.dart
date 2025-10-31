import 'package:flutter/material.dart';
import 'package:mhealthapp/main.dart';
import 'package:mhealthapp/screens/auth/startup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:mhealthapp/health/health_package.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mhealthapp/services/health_data_sync_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

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
      await _requestPermissions();
      // Navigator.pushReplacementNamed(context, '/startup');
    } else {
      _showError("Invalid email or password");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool isInstalled = await HealthPermissions.isHealthConnectInstalled();
      if (!isInstalled) {
        setState(() {
          _errorMessage =
              'Health Connect is not installed. Please install "Health Connect by Android" from Google Play';
          _isLoading = false;
        });
        print("Health Connect not installed. Showing dialog.");
        _showHealthConnectDialog();
        return;
      }

      bool granted = await HealthPermissions.requestPermissions();
      print("Health Connect permissions granted: $granted");
      if (granted) {
        if (mounted) {
          await HealthDataSyncService.syncToSQLite();
          await Workmanager().registerPeriodicTask(
            "healthSyncTask",
            "syncHealthData",
            frequency: const Duration(minutes: 30),
          );
          print("Today's periodic task registered");
          await Workmanager().registerPeriodicTask(
            "yesterdayhealthSyncTask",
            "syncYesterdayHealthData",
            frequency: const Duration(hours: 24),
          );
          print("Yesterday's Periodic task registered");

          print("Permissions granted. Navigating to /home");
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        setState(() {
          _errorMessage =
              'Permission denied. Please grant permissions manually in Health Connect';
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/startup');
        print("Permissions denied in Health Connect");
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error requesting permissions: $e';
        _isLoading = false;
      });
    }
  }

  void _showHealthConnectDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Health Connect Required'),
            content: const Text(
              'Health Connect is Android\'s official health data platform. It needs to be installed to use health features.\n\n'
              'Please search and install "Health Connect by Android" from Google Play Store.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
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
                  // Spacer(),
                  // TextButton(
                  //   onPressed: () {
                  //     // Add your forgot login logic here
                  //   },
                  //   style: TextButton.styleFrom(
                  //     foregroundColor:
                  //         Colors.deepPurple, // splash + highlight color
                  //   ),
                  //   child: const Text(
                  //     "Forgot login?",
                  //     style: TextStyle(
                  //       color: Colors.deepPurple,
                  //       decoration:
                  //           TextDecoration.underline, // underline the text
                  //     ),
                  //   ),
                  // ),
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
