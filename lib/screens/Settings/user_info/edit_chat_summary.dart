
import 'package:flutter/material.dart';

class ConversationSummaryPage extends StatefulWidget {
  const ConversationSummaryPage({super.key});

  @override
  State<ConversationSummaryPage> createState() => _ConversationSummaryPageState();
}

class _ConversationSummaryPageState extends State<ConversationSummaryPage> {
  final TextEditingController nameController = TextEditingController(text: "John Doe");
  final TextEditingController ageController = TextEditingController(text: "30");
  final TextEditingController goalController = TextEditingController(text: "Weight Loss");
  final TextEditingController conditionsController = TextEditingController(text: "None");
  final TextEditingController exerciseController = TextEditingController(text: "Cardio");
  final TextEditingController notesController = TextEditingController();

  final TextEditingController chatbotSummaryController = TextEditingController(
    text: "Based on your conversations so far, you are focused on achieving weight loss through cardio exercises, with no known medical conditions. You prefer short, high-intensity workouts and have expressed interest in tracking your progress weekly.",
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08;
    final textScale = screenWidth / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.04),
          child: Icon(Icons.emoji_events, color: const Color(0xFF6B578C), size: screenWidth * 0.08),
        ),
        title: Text(
          'mHealth',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 24 * textScale,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: Icon(Icons.settings, color: const Color(0xFF6B578C), size: screenWidth * 0.08),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 0.04),
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black, size: screenWidth * 0.07),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: screenWidth * 0.02),

              Text(
                'Conversation Summary',
                style: TextStyle(fontSize: 20 * textScale, fontWeight: FontWeight.w600),
              ),
              const Divider(height: 32),

              _editableField("Name", nameController, textScale),
              _editableField("Age", ageController, textScale),
              _editableField("Health Goal", goalController, textScale),
              _editableField("Known Conditions", conditionsController, textScale),
              _editableField("Preferred Exercise", exerciseController, textScale),

              SizedBox(height: screenWidth * 0.04),
              Text(
                'Chatbot Summary:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16 * textScale),
              ),
              SizedBox(height: screenWidth * 0.01),
              TextField(
                controller: chatbotSummaryController,
                maxLines: 4,
                decoration: InputDecoration(
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

              SizedBox(height: screenWidth * 0.04),
              Text(
                'Additional Notes:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16 * textScale),
              ),
              SizedBox(height: screenWidth * 0.01),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Add any personal notes...",
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

              SizedBox(height: screenWidth * 0.06),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Changes saved!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B578C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller, double textScale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14 * textScale)),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6B578C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6B578C)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    goalController.dispose();
    conditionsController.dispose();
    exerciseController.dispose();
    notesController.dispose();
    chatbotSummaryController.dispose();
    super.dispose();
  }
}