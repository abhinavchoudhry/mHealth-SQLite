import 'package:flutter/material.dart';

class CreateAccountStep2 extends StatelessWidget {
  const CreateAccountStep2({super.key});

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text("Create an Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text(
              "Next, create a username and password.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),

            // Username
            Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),

            // Password
            Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),

            Text(
              "Your password must:\n"
                  "- Be at least 10 characters long\n"
                  "- Contain both uppercase and lowercase letters\n"
                  "- Contain at least 1 number\n"
                  "- Contain at least 1 special character\n"
                  "- Not contain your email or username",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),

            SizedBox(height: 32),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup3');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Next", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
