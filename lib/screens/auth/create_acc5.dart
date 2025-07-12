import 'package:flutter/material.dart';

class CreateAccountStep5 extends StatefulWidget {
  const CreateAccountStep5({super.key});

  @override
  State<CreateAccountStep5> createState() => _CreateAccountStep5State();
}

class _CreateAccountStep5State extends State<CreateAccountStep5> {
  String? selectedPersonality;
  String? selectedVoice;

  void _showPersonalityInfo(String title, List<String> points) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: TextStyle(color: Colors.deepPurple)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: points.map((p) => Text("• $p", style: TextStyle(color: Colors.deepPurple))).toList(),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => selectedPersonality = title);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text("Select",style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityOption(String label, List<String> traits) {
    return GestureDetector(
      onTap: () => _showPersonalityInfo(label, traits),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPersonality == label ? Colors.deepPurple : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(label)),
      ),
    );
  }

  Widget _buildVoiceOption(String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: label,
      groupValue: selectedVoice,
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() => selectedVoice = value),
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
            Text("Create an Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Finally, customize the settings of your AI agent! Select an avatar below, and customize its voice and interactions."),
            SizedBox(height: 24),

            Text("Personality", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildPersonalityOption("Empathetic", [
                  "Empathetic and nice if things are getting hard",
                  "Could come across soft and not motivating",
                  "Sympathetic to injuries and soreness"
                ]),
                _buildPersonalityOption("Direct", [
                  "Stern and right to the point",
                  "Very analytical and more about the numbers",
                  "Will tell you if you are not doing well",
                  "Could come across as mean"
                ]),
                _buildPersonalityOption("Balanced", [
                  "Very friendly",
                  "Well balanced and not overly crazy on any attributes",
                  "Supportive and not overly pushy",
                  "Acknowledges mental and physical side of training"
                ]),
                _buildPersonalityOption("Mentally Focused", [
                  "All about mental aspect",
                  "Not as stern as coach Helen",
                  "Ties back stuff to mental state",
                  "Pushes you mentally more than physically"
                ]),
              ],
            ),

            SizedBox(height: 24),
            Text("Voice", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildVoiceOption("Male"),
            _buildVoiceOption("Female"),

            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup6');
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
