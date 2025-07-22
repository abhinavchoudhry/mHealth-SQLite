import '../../Settings/settings_1.dart';
import '../../challenges.dart';
import '../../home_page.dart';
import 'create_workout_own_popup.dart';
import 'package:flutter/material.dart';

class BuildRoutinePage extends StatelessWidget {
  const BuildRoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.emoji_events_outlined, color: Colors.black),
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengesPage()),);},
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(Icons.emoji_events, color: Colors.deepPurple),
                  SizedBox(width: 6),
                  Text("mHealth", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()),);},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 2, // Current index is 'Exercise'
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
          // You can add logic for index == 1 (Chat) and index == 3 (Activity) later if needed
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),

            const Text(
              'Build Your Own Workout Routine',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose exercises from your Exercise Library to build your personalized workout routine!',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'Name your routine',
                hintStyle: const TextStyle(
                    color: Color(0xFF6B578C), fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF6B578C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF6B578C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {
                showDialog(
                context: context,
                builder: (context) => const AddExercisePopup(),);
              },
              child: const Text(
                '+ Add Exercise',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B578C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
        

