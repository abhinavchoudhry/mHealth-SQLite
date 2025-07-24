import 'package:flutter/material.dart';
import 'package:mhealthapp/db_helper.dart';
import 'create_acc2.dart'; 


class CreateAccountStep1 extends StatefulWidget {
  const CreateAccountStep1({super.key});

  @override
  State<CreateAccountStep1> createState() => _CreateAccountStep1State();
}

class _CreateAccountStep1State extends State<CreateAccountStep1> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onNextPressed() async {
    final user = {
      'username':'test1',
      'pwd':'123456',
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'dob': _dobController.text,
      'phone_number': _phoneController.text,
      'sex': 'Female',
      'weight': 70, 
      'weight_unit':'kg' ,
      'height': 170   , 
      'height_unit': 'cm',
      'age': 35,
      'RHR': 60,
      'PHR': 'diabite'
      };

    final userId = await DBHelper().insertUser(user);
    

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountStep2(userId: userId),
      ),
    );

    fetchUsers();
  }


  void fetchUsers() async {
  final users = await DBHelper().getUsers();

  for (var user in users) {
    print('User: ${user['id']} - ${user['first_name']} - ${user['email']}');
  }
}


  @override
  Widget build(BuildContext context) {
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
                onPressed: _onNextPressed,
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
