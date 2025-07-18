import 'package:flutter/material.dart';

import '../exercise.dart';

class AIAgentPage extends StatefulWidget {
  const AIAgentPage({super.key});

  @override
  State<AIAgentPage> createState() => _AIAgentPageState();
}

class _AIAgentPageState extends State<AIAgentPage> {
  bool alwaysListening = false;
  int selectedAvatar = 0;
  String selectedPersonality = 'Empathetic';
  String selectedVoice = 'Voice 1';

  final List<String> personalities = [
    'Empathetic', 'Direct', 'Balanced', 'Mentally Focused'
  ];

  final List<String> voices = ['Voice 1', 'Voice 2','Voice 3','Voice 4'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        //showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 0, // or 0 for HomePage, or correct index for this page
        onTap: (index) {
          if (index == 0) {
            // Navigate to HomePage
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          } else if (index == 2) {
            // Navigate to ChallengesPage
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExercisePage()),);
          }
          // Optional: handle Chat (index == 1), Exercise (index == 2)
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow and Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              const SizedBox(height: 16),
              const Text('AI Agent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Always Listening'),
                  Switch(
                    value: alwaysListening,
                    onChanged: (value) {
                      setState(() => alwaysListening = value);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text('Appearance',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => setState(() => selectedAvatar = index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedAvatar == index ? Color(0xFF6B578C) : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Transform.scale(
                        scale: _getScaleForIndex(index), // custom zoom level
                        child: Image.asset(
                          'images/avatar${index + 1}.png',
                          fit: BoxFit.cover,
                          alignment: _getAlignmentForIndex(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text('Personality',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("*Select each for more information",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: personalities.map((type) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: type,
                        groupValue: selectedPersonality,
                        onChanged: (value) => setState(() => selectedPersonality = value!),
                        activeColor: Color(0xFF6B578C),
                      ),
                      Text(type),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              const Text('Voice', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                children: voices.map((voice) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: voice,
                        groupValue: selectedVoice,
                        onChanged: (value) => setState(() => selectedVoice = value!),
                        activeColor: Color(0xFF6B578C),
                      ),
                      Text(voice),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    title: const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'mHealth',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
    ),
  );
}

Alignment _getAlignmentForIndex(int index) {
  switch (index) {
    case 3:
    case 4:
      return const Alignment(0, -0.9);
    case 5:
      return const Alignment(0, -0.2); // shift face slightly up
    case 6:
    case 7:
    case 8:
      return const Alignment(0, -0.7); // shift face more up
    default:
      return Alignment.center;
  }
}

double _getScaleForIndex(int index) {
  switch (index) {
    case 4:
      return 1.0;
    case 5:
      return 1.2;
    case 6:
      return 1.2;
    case 8:
      return 1.7;
    default:
      return 1.0;
  }
}
