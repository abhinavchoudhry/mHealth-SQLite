import 'package:flutter/material.dart';
import '/screens/challenges.dart';
import '/screens/home_page.dart';
import '/screens/exercise_lib/pre_defined_ex/bicep_curl/bicep_curl.dart';
import '/screens/exercise_lib/pre_defined_ex/bicep_curl/hammer_curl.dart';
import 'bicep_curl/front_raise.dart';
import 'bicep_curl/lateral_raise.dart';
import 'bicep_curl/overhead_press.dart';
import 'bicep_curl/push_ups.dart';
import 'bicep_curl/shoulder_roll.dart';
import 'bicep_curl/tricep_dip.dart';


class ArmsExercisesPage extends StatelessWidget {
  const ArmsExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengesPage()));
              },
            ),
            Expanded(
              child: Center(
                child: Text("mHealth", style: TextStyle(color: Colors.black)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Color(0xFF3C314F)),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Text("Arms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildExerciseButton(context, "Bicep Curl", Icons.fitness_center, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BicepCurlPage(title: "Bicep Curl")));
                  }),
                  _buildExerciseButton(context, "Hammer Curl", Icons.sports_martial_arts, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HammerCurlPage(title: "Hammer Curl")));
                  }),
                  _buildExerciseButton(context, "Push-Up", Icons.accessibility_new, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PushUpPage(title: "Push Up")));
                  }),
                  _buildExerciseButton(context, "Lateral Raise", Icons.airline_seat_legroom_normal, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LateralRaisePage(title: "Lateral Raise")));
                  }),
                  _buildExerciseButton(context, "Overhead Press", Icons.upload, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OverheadPressPage(title: "Overhead Press")));
                  }),
                  _buildExerciseButton(context, "Shoulder Roll", Icons.sync, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShoulderRollPage(title: "Shoulder Roll")));
                  }),
                  _buildExerciseButton(context, "Tricep Dip", Icons.pan_tool, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TricepDipPage(title: "Tricep Dip")));
                  }),
                  _buildExerciseButton(context, "Front Raise", Icons.fitness_center, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FontRaisePage(title: "Front Raise")));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 2) {
            // Navigate to ChallengesPage
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: 'Exercise'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Activity'),
        ],
      ),
    );
  }

  Widget _buildExerciseButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B578C),
        padding: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
