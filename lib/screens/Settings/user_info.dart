
import 'package:flutter/material.dart';
import 'package:mhealthapp/screens/Settings/user_info/edit_chat_summary.dart';
import 'package:mhealthapp/screens/Settings/user_info/edit_goal_setting.dart';
import 'package:mhealthapp/screens/Settings/user_info/edit_health_info.dart';
import 'package:mhealthapp/screens/Settings/user_info/edit_psnl_info.dart';

import '../exercise.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 24),
            const Text('User Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(height: 32),
            ListTile(
              title: const Text('Personal Details'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const PsnlDetails(),
                ));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('User Chat Summary'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const ConversationSummaryPage(),
                ));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Health Information'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const HealthInfo(),
                ));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Goal Setting'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const GoalSetting(),
                ));
              },
            ),
          ],
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