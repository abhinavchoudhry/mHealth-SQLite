import 'package:flutter/material.dart';

class CreateAccountStep4 extends StatefulWidget {
  const CreateAccountStep4({super.key});

  @override
  State<CreateAccountStep4> createState() => _CreateAccountStep4State();
}

class _CreateAccountStep4State extends State<CreateAccountStep4> {
  Map<String, bool> goals = {
    'Weight Loss': false,
    'Muscle Gain': false,
    'Cardiovascular Fitness': false,
    'Functional Fitness': false,
  };
  final TextEditingController _customGoalController = TextEditingController();
  List<String> customGoals = [];

  void _addCustomGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("New Custom Goal", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _customGoalController,
            decoration: InputDecoration(
              hintText: "Ex: Mobility, Learning Skills etc.",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.deepPurple)),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.deepPurple),
                foregroundColor: Colors.black,
              ),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final goal = _customGoalController.text.trim();
                if (goal.isNotEmpty) {
                  setState(() {
                    customGoals.add(goal);
                    goals[goal] = true;
                  });
                  _customGoalController.clear();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
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
              "Next, set your goals. Select from the goals below and/or add custom goals. They can be changed later in your profile.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),

            ...goals.keys.map((goal) => CheckboxListTile(
              title: Text(goal),
              value: goals[goal],
              activeColor: Colors.deepPurple,
              onChanged: (val) => setState(() => goals[goal] = val ?? false),
            )),

            TextButton(
              onPressed: _addCustomGoalDialog,
              child: Text(
                "+ Add Custom Goal",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup5');
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
