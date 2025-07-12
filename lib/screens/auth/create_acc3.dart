import 'package:flutter/material.dart';

class CreateAccountStep3 extends StatefulWidget {
  const CreateAccountStep3({super.key});

  @override
  State<CreateAccountStep3> createState() => _CreateAccountStep3State();
}

class _CreateAccountStep3State extends State<CreateAccountStep3> {
  String? selectedGender = 'Male';
  String? weightUnit = 'lbs';
  String? heightUnit = 'in';

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _rhrController = TextEditingController();

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
              "Next, enter your health information. This will be crucial in helping you meet your fitness goals. This can be changed later in your profile.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),

            // Gender
            Text("Sex*", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: selectedGender,
                  onChanged: (val) => setState(() => selectedGender = val),
                ),
                Text("Male"),
                Radio<String>(
                  value: 'Female',
                  groupValue: selectedGender,
                  onChanged: (val) => setState(() => selectedGender = val),
                ),
                Text("Female"),
                Radio<String>(
                  value: 'Other',
                  groupValue: selectedGender,
                  onChanged: (val) => setState(() => selectedGender = val),
                ),
                Text("Other"),
              ],
            ),
            SizedBox(height: 16),

            // Weight
            Text("Weight*", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      hintText: "Weight",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'lbs',
                          groupValue: weightUnit,
                          onChanged: (val) => setState(() => weightUnit = val),
                        ),
                        Text("Imperial (lbs)"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'kg',
                          groupValue: weightUnit,
                          onChanged: (val) => setState(() => weightUnit = val),
                        ),
                        Text("Metric (kg)"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Height
            Text("Height*", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      hintText: "Height",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'in',
                          groupValue: heightUnit,
                          onChanged: (val) => setState(() => heightUnit = val),
                        ),
                        Text("Imperial (in)"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'cm',
                          groupValue: heightUnit,
                          onChanged: (val) => setState(() => heightUnit = val),
                        ),
                        Text("Metric (cm)"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Age
            Text("Age*", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: "Age",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // RHR
            Text("Resting Heart Rate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            TextField(
              controller: _rhrController,
              decoration: InputDecoration(
                hintText: "RHR",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),

            // Custom field
            Text("* Indicates required field",
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700])),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final _conditionController = TextEditingController();
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text("New Preexisting Health Condition", style: TextStyle(color: Colors.deepPurple)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _conditionController,
                            decoration: InputDecoration(
                              hintText: "Ex: Diabetes, Chronic Pain, Anemia, Asthma, etc.",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // close without saving
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.deepPurple),
                            foregroundColor: Colors.black87,
                          ),
                          child: Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final entered = _conditionController.text.trim();
                            if (entered.isNotEmpty) {
                              // Add your logic here (e.g. save to a list)
                              Navigator.of(context).pop(); // close modal
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
              },

              child: Text(
                "+ Add Preexisting Health Conditions",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 24),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup4');
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
