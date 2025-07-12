import 'package:flutter/material.dart';
import 'challenges.dart';
import 'exercise.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.emoji_events_outlined, color: Colors.black),
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengesPage()),);},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Welcome to mHealth!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'Images/home_page1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildActionButton(context, Icons.chat_bubble_outline, "Chat with mHealth AI"),
            _buildActionButton(context, Icons.list, "View your Exercises"),
            _buildActionButton(context, Icons.bar_chart, "View your Activity"),
            _buildActionButtonWithProgress(context, Icons.settings, "Personalize your profile", 0.7),


          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
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
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildActionButtonWithProgress(BuildContext context, IconData icon,
      String title, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                color: Colors.deepPurple,
                backgroundColor: Colors.deepPurple.shade50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
