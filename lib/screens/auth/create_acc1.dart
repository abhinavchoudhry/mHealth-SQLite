import 'package:flutter/material.dart';


class CreateAccountStep1 extends StatelessWidget {
  const CreateAccountStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _dobController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();

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
              "First, enter your personal information in the fields below.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),

            // First Name
            Text("First Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: "First Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),

            // Last Name
            Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: "Last Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),

            // DOB
            Text("Date of Birth", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                hintText: "mm/dd/yyyy",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16),

            // Phone
            Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: "(xxx)-xxx-xxxx",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Email
            Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 4),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "email@example.com",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 32),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup2');
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
