import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhealthapp/db_helper.dart';
import 'dart:convert';

// class ConversationSummaryPage extends StatefulWidget {
//   const ConversationSummaryPage({super.key});

//   @override
//   State<ConversationSummaryPage> createState() =>
//       _ConversationSummaryPageState();
// }

// class _ConversationSummaryPageState extends State<ConversationSummaryPage> {
//   int? userId;
//   Map<String, dynamic>? userData;

//   @override
//   void initState() {
//     super.initState();
//     loadUserIdAndData();
//   }

//   Future<void> loadUserIdAndData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final int? id = prefs.getInt('userId');
//     final dbHelper = DBHelper();

//     if (id == null) {
//       print('No userId found in SharedPreferences');
//       return;
//     }

//     final Map<String, dynamic>? data = await dbHelper.getUserById(id);
//     if (data != null) {
//       setState(() {
//         userId = data['user_dim_id']; // make sure this matches your PK name
//         userData = data;
//       });
//     } else {
//       print('User not found');
//     }
//   }

//   String parseGoals(String? jsonString) {
//     if (jsonString == null || jsonString.isEmpty) return '';

//     try {
//       final Map<String, dynamic> decoded = json.decode(jsonString);
//       final trueKeys =
//           decoded.entries
//               .where((entry) => entry.value == true)
//               .map((entry) => entry.key)
//               .toList();

//       return trueKeys.join(", "); // e.g. "Weight Loss, Cardio Fitness"
//     } catch (e) {
//       print("Error parsing goals JSON: $e");
//       return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (userData == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final screenWidth = MediaQuery.of(context).size.width;
//     final horizontalPadding = screenWidth * 0.08;
//     final textScale = screenWidth / 375;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: EdgeInsets.only(left: screenWidth * 0.04),
//           child: Icon(
//             Icons.emoji_events,
//             color: const Color(0xFF6B578C),
//             size: screenWidth * 0.08,
//           ),
//         ),
//         title: Text(
//           'mHealth',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//             fontSize: 24 * textScale,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: screenWidth * 0.04),
//             child: Icon(
//               Icons.settings,
//               color: const Color(0xFF6B578C),
//               size: screenWidth * 0.08,
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: screenWidth * 0.04),
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                   size: screenWidth * 0.07,
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               SizedBox(height: screenWidth * 0.02),

//               Text(
//                 'Conversation Summary',
//                 style: TextStyle(
//                   fontSize: 20 * textScale,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const Divider(height: 32),

//               EditableTextRow(
//                 label: "Name",
//                 fieldName: "first_name", // or combine with last_name if needed
//                 initialValue:
//                     "${userData?['first_name'] ?? ''} ${userData?['last_name'] ?? ''}",
//               ),
//               EditableTextRow(
//                 label: "Age",
//                 fieldName: "age",
//                 initialValue: (userData?['age'] ?? '').toString(),
//               ),
//               EditableTextRow(
//                 label: "Health Goal",
//                 fieldName: "custom_goals",
//                 initialValue: parseGoals(userData?['custom_goals']) ?? '',
//               ),
//               EditableTextRow(
//                 label: "Known Conditions",
//                 fieldName: "health_conditions",
//                 initialValue: userData?['health_conditions'] ?? '',
//               ),
//               EditableTextRow(
//                 label: "Preferred Exercise",
//                 fieldName: "preferred_exercise", // add this column if missing
//                 initialValue: userData?['preferred_exercise'] ?? '',
//               ),

//               const SizedBox(height: 20),
//               Text(
//                 'Chatbot Summary:',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16 * textScale,
//                 ),
//               ),
//               EditableTextRow(
//                 label: "Chatbot Summary",
//                 fieldName: "chatbot_summary",
//                 initialValue: userData?['chatbot_summary'] ?? '',
//                 maxLines: 4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Reusable editable row widget
// class EditableTextRow extends StatefulWidget {
//   final String label;
//   final String fieldName; // database column
//   final String initialValue;
//   final int maxLines;

//   const EditableTextRow({
//     super.key,
//     required this.label,
//     required this.fieldName,
//     required this.initialValue,
//     this.maxLines = 1,
//   });

//   @override
//   State<EditableTextRow> createState() => _EditableTextRowState();
// }

// class _EditableTextRowState extends State<EditableTextRow> {
//   late TextEditingController _controller;
//   bool _isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.initialValue);
//   }

//   String mergeGoals(String oldJson, String newInput) {
//     final oldGoals = json.decode(oldJson);

//     // User typed comma-separated goals
//     final newGoals = newInput
//         .split(",")
//         .map((s) => s.trim())
//         .where((s) => s.isNotEmpty);

//     for (final goal in newGoals) {
//       oldGoals[goal] = true; // override / add as true
//     }

//     return json.encode(oldGoals);
//   }

//   Future<void> _saveToDatabase() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId == null) return;

//     final dbHelper = DBHelper();
//     dynamic valueToSave = _controller.text;

//     // Cast numbers correctly
//     if (widget.fieldName == "age") {
//       valueToSave = int.tryParse(_controller.text) ?? 0;
//     }

//     if (widget.fieldName == "custom_goals") {
//       // merge new input with old JSON
//       final oldJson =
//           (await dbHelper.getUserById(userId))?['custom_goals'] ?? "{}";
//       valueToSave = mergeGoals(oldJson, _controller.text);
//     }

//     await dbHelper.updateUser(userId, {widget.fieldName: valueToSave});
//     print("Updated ${widget.fieldName} to $valueToSave");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.label.isNotEmpty)
//             Text(
//               widget.label,
//               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//             ),
//           _isEditing
//               ? TextField(
//                 controller: _controller,
//                 maxLines: widget.maxLines,
//                 decoration: InputDecoration(
//                   labelText: widget.label,
//                   border: const OutlineInputBorder(),
//                 ),
//                 onSubmitted: (_) async {
//                   setState(() => _isEditing = false);
//                   await _saveToDatabase();
//                 },
//               )
//               : GestureDetector(
//                 onTap: () => setState(() => _isEditing = true),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFF6B578C)),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     _controller.text.isEmpty
//                         ? "Tap to add ${widget.label}"
//                         : _controller.text,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhealthapp/db_helper.dart';
import 'dart:convert';

class ConversationSummaryPage extends StatefulWidget {
  const ConversationSummaryPage({super.key});

  @override
  State<ConversationSummaryPage> createState() =>
      _ConversationSummaryPageState();
}

class _ConversationSummaryPageState extends State<ConversationSummaryPage> {
  int? userId;
  Map<String, dynamic>? userData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController conditionsController = TextEditingController();
  final TextEditingController exerciseController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController chatbotSummaryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserIdAndData();
  }

  Future<void> loadUserIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('userId');
    final dbHelper = DBHelper();

    if (id == null) {
      print('No userId found in SharedPreferences');
      return;
    }

    final Map<String, dynamic>? data = await dbHelper.getUserById(id);
    if (data != null) {
      setState(() {
        userId = data['user_dim_id'];
        userData = data;

        // fill controllers with DB values
        nameController.text =
            "${data['first_name'] ?? ''} ${data['last_name'] ?? ''}".trim();
        ageController.text = (data['age'] ?? '').toString();
        goalController.text = parseGoals(data['custom_goals']);
        conditionsController.text = data['health_conditions'] ?? '';
        exerciseController.text = data['preferred_exercise'] ?? '';
        notesController.text = data['notes'] ?? '';
        chatbotSummaryController.text = data['chatbot_summary'] ?? '';
      });
    }
  }

  String parseGoals(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return '';
    try {
      final Map<String, dynamic> decoded = json.decode(jsonString);
      final trueKeys =
          decoded.entries
              .where((entry) => entry.value == true)
              .map((entry) => entry.key)
              .toList();
      return trueKeys.join(", ");
    } catch (_) {
      return '';
    }
  }

  Future<void> saveChanges() async {
    if (userId == null) return;
    final dbHelper = DBHelper();

    final values = {
      "first_name": nameController.text.split(" ").first,
      "last_name":
          nameController.text.split(" ").length > 1
              ? nameController.text.split(" ").sublist(1).join(" ")
              : "",
      "age": int.tryParse(ageController.text) ?? 0,
      "custom_goals": json.encode({
        for (var g in goalController.text.split(",").map((s) => s.trim()))
          if (g.isNotEmpty) g: true,
      }),
      "health_conditions": conditionsController.text,
      "chatbot_summary": chatbotSummaryController.text,
    };

    await dbHelper.updateUser(userId!, values);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Changes saved!")));
  }

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
          child: Icon(
            Icons.emoji_events,
            color: const Color(0xFF6B578C),
            size: screenWidth * 0.08,
          ),
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
            child: Icon(
              Icons.settings,
              color: const Color(0xFF6B578C),
              size: screenWidth * 0.08,
            ),
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
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: screenWidth * 0.07,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: screenWidth * 0.02),

              Text(
                'Conversation Summary',
                style: TextStyle(
                  fontSize: 20 * textScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(height: 32),

              _editableField("Name", nameController, textScale),
              _editableField("Age", ageController, textScale),
              _editableField("Health Goal", goalController, textScale),
              _editableField(
                "Known Conditions",
                conditionsController,
                textScale,
              ),
              _editableField(
                "Preferred Exercise",
                exerciseController,
                textScale,
              ),

              SizedBox(height: screenWidth * 0.04),
              Text(
                'Chatbot Summary:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16 * textScale,
                ),
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16 * textScale,
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Add any personal notes...",
                  hintStyle: const TextStyle(
                    color: Color(0xFF6B578C),
                    fontWeight: FontWeight.w500,
                  ),
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
                  onPressed: saveChanges,
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

  Widget _editableField(
    String label,
    TextEditingController controller,
    double textScale,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14 * textScale,
            ),
          ),
          const SizedBox(height: 4),
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
