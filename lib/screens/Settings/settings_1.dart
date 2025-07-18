import 'package:flutter/material.dart';

import 'package:mhealthapp/screens/Settings/user_info.dart';

import '../exercise.dart';
import 'ai_agent.dart';
import 'contacts.dart';
import 'faq.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        currentIndex: 0, // or 0 for SettingsPage, or correct index for this page
        onTap: (index) {
          if (index == 0) {
            // Navigate to SettingsPage
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow
            Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Container(
                width: screenWidth * 0.09,
                height: screenWidth * 0.09,
                decoration: const BoxDecoration(color: Colors.white),
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),


            // "Settings" title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Divider(),

            // Profile section
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6B578C),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'images/user.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'email@example.com',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // List items
            ...[
              'AI Agent',
              'Privacy & Security',
              'User Information',
              'Connected Apps & Services',
              'Contacts & Additional Information',
              'Frequently Asked Questions',
              'About',
            ].map(
                  (title) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Widget page;
                        switch (title) {
                          case 'AI Agent':
                            page = const AIAgentPage();
                            break;
                          case 'User Information':
                            page = const UserInfo();
                            break;
                          case 'Contacts & Additional Information':
                            page = const ContactsPage();
                            break;
                          case 'Frequently Asked Questions':
                            page = const FAQPage();
                            break;
                          default:
                            page = const Scaffold(body: Center(child: Text('Page not found')));
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => page),
                        );},
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Master Reset
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GestureDetector(
                onTap: () => _showMasterResetDialog(context),
                child: const Text(
                  'Master Reset',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


  void _showMasterResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Master Reset',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B578C),
          ),
        ),
        content: const Text(
          'Requesting a Master Reset will clear your progress, preferences, and chatbot interactions. '
              'This action is not automatic. Once submitted, your request will be reviewed by our team for confirmation. '
              'You’ll be notified once it’s approved and processed.\n\nAre you sure you want to request a reset?',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B578C),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 12),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFF6B578C), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              // add master reset logic here
            },
            child: const Text('Yes'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B578C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }


  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
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
}