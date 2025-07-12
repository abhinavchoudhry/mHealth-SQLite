import 'package:flutter/material.dart';
import '../challenges.dart';
import '/screens/home_page.dart';
import '/screens/exercise_lib/pre_defined_ex/arms_exercises.dart';

class ExerciseLibraryPage extends StatelessWidget {
  const ExerciseLibraryPage({super.key});

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
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              sectionTitle("Workout Routines"),
              SizedBox(height: 8),
              /*_buildRoutineTile("Custom Workout Routine 1"),
              _buildRoutineTile("Monday Pilates"),
              _buildRoutineTile("Quick Full Body"),*/
              _buildRoutineGroup(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("View all >", style: TextStyle(color: Colors.deepPurple)),
                ),
              ),
              SizedBox(height: 20),
              sectionTitle("Your Exercises"),
              SizedBox(height: 8),
              _buildExerciseTile("Calf Raises", "Legs"),
              _buildExerciseTile("Chin-ups", "Back"),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("View all >", style: TextStyle(color: Colors.deepPurple)),
                ),
              ),
              SizedBox(height: 20),
              sectionTitle("Pre-Defined Exercises"),
              SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
                children: [
                  _buildExerciseButton("Arms", () {
                    Navigator.pushNamed(context, '/arms');
                  }),
                  _buildExerciseButton("Legs", () {
                    Navigator.pushNamed(context, '/legs');
                  }),
                  _buildExerciseButton("Shoulders", () {
                    Navigator.pushNamed(context, '/shoulders');
                  }),
                  _buildExerciseButton("Back", () {
                    Navigator.pushNamed(context, '/back');
                  }),
                  _buildExerciseButton("Abdomen", () {
                    Navigator.pushNamed(context, '/abdomen');
                  }),
                  _buildExerciseButton("Chest", () {
                    Navigator.pushNamed(context, '/chest');
                  }),
                  _buildExerciseButton("Stretches", () {
                    Navigator.pushNamed(context, '/stretches');
                  }),
                  _buildExerciseButton("Yoga", () {
                    Navigator.pushNamed(context, '/yoga');
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 2, // or 0 for HomePage, or correct index for this page
        onTap: (index) {
          if (index == 2) {
            // Navigate to HomePage
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          } else if (index == 0) {
            // Navigate to ChallengesPage
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
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

  Widget sectionTitle(String title) => Text(
    title,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget _buildRoutineGroup() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInnerRoutineTile("Custom Workout Routine 1"),
          Divider(height: 1, color: Colors.white),
          _buildInnerRoutineTile("Monday Pilates"),
          Divider(height: 1, color: Colors.white),
          _buildInnerRoutineTile("Quick Full Body"),
        ],
      ),
    );
  }

  Widget _buildInnerRoutineTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /*Widget _buildRoutineTile(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }*/

  Widget _buildExerciseTile(String name, String category) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(color: Colors.black, fontSize: 16)),
          Text(category, style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildExerciseButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}
