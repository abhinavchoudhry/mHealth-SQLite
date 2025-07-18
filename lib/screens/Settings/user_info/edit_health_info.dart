// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import '../../exercise.dart';

class HealthInfo extends StatelessWidget {
  const HealthInfo({super.key});

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
                const Text('Health Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Divider(height: 32),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    EditableTextRow(label: 'Weight', initialValue: '75 kg'),
                    EditableTextRow(label: 'Height', initialValue: '174 cm'),
                    EditableTextRow(label: 'Age', initialValue: '35 years'),
                    EditableTextRow(
                      label: 'Preexisting Health Conditions',
                      initialValue: 'Diabetes, Asthma',
                    ),
                  ],
                ),
              ]
          ),
        )
    );
  }
}

class EditableTextRow extends StatefulWidget {
  final String label;
  final String initialValue;

  const EditableTextRow({
  required this.label,
  required this.initialValue,
  super.key,
});

@override
State<EditableTextRow> createState() => _EditableTextRowState();
}

class _EditableTextRowState extends State<EditableTextRow> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _isEditing
                ? TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: widget.label),
              onSubmitted: (_) {
                setState(() => _isEditing = false);
              },
            )
                : Text(
              '${widget.label}\n${_controller.text}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _isEditing = !_isEditing);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 4.0),
              child: Text('Edit', style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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