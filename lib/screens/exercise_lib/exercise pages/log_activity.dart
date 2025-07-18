
import 'package:flutter/material.dart';
import '../../Settings/settings_1.dart';
import '../../challenges.dart';
import 'log_workout_popup.dart';


import '/screens/home_page.dart';

class LogActivityPage extends StatelessWidget {
  const LogActivityPage({super.key});

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
                Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengesPage()));
              },
            ),
            Expanded(
              child: Center(child: Text("mHealth", style: TextStyle(color: Colors.black))),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
              },
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
              Text("Log Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(
                "Log any workouts you complete here. Recent workouts can be found below. "
                    "A full exercise history can be found in the Activity Stats page.",
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (_) => LogWorkoutPopup());
                },
                child: Text(
                  "+ Log a Workout",
                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24),
              Text("Recent Exercise History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildHistoryTable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
        onTap: (index) {
          // if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
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

  Widget _buildHistoryTable() {
    final rows = [
      ["Pilates", "10/7/24", "26:39", "238"],
      ["Workout Routine 1", "10/7/24", "26:39", "238"],
      ["Monday Pilates", "10/7/24", "26:39", "238"],
      ["Full Body", "10/7/24", "26:39", "238"],
      ["Example", "10/7/24", "12:30", "XXX"],
    ];

    final Color lightPurple = Colors.deepPurple.shade50;
    final Color mediumPurple = Colors.deepPurple.shade100;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        border: TableBorder.all(color: Colors.transparent, width: 0),
        children: [
          TableRow(
            decoration: BoxDecoration(color: mediumPurple),
            children: ["Workout", "Date", "Time", "Calories Burned"]
                .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e, style: TextStyle(fontWeight: FontWeight.bold)),
            ))
                .toList(),
          ),
          ...List.generate(rows.length, (index) {
            final row = rows[index];
            final rowColor = index.isEven ? lightPurple : mediumPurple;
            return TableRow(
              decoration: BoxDecoration(color: rowColor),
              children: row
                  .map((cell) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cell),
              ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}