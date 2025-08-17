import 'package:flutter/material.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:mhealthapp/models/exercise_models.dart';
import 'package:mhealthapp/models/routine_exercise.dart';

class AddExercisePopup extends StatefulWidget {
  final Function(RoutineExercise) onExerciseAdded;
  final int userId;

  const AddExercisePopup({
    super.key,
    required this.onExerciseAdded,
    required this.userId,
  });

  @override
  State<AddExercisePopup> createState() => _AddExercisePopupState();
}

class _AddExercisePopupState extends State<AddExercisePopup> {
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedUnit = 'lbs';
  final List<String> unitOptions = ['lbs', 'kg'];

  List<ExerciseLibrary> libraryExercises = [];
  List<CustomExercise> customExercises = [];
  List<dynamic> allExercises = [];
  dynamic selectedExercise;
  
  bool isLoadingExercises = true;
  String? loadingError;

  final DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() {
        isLoadingExercises = true;
        loadingError = null;
      });

      //print('Loading exercises for user: ${widget.userId}');
      
      // Load both library and custom exercises
      final futures = await Future.wait([
        dbHelper.getAllLibraryExercises(),
        dbHelper.getCustomExercisesByUser(widget.userId),
      ]);

      libraryExercises = futures[0] as List<ExerciseLibrary>;
      customExercises = futures[1] as List<CustomExercise>;
      
      print('Loaded ${libraryExercises.length} library exercises');
      print('Loaded ${customExercises.length} custom exercises');

      // Ensure we have valid exercises before setting state
      if (mounted) {
        setState(() {
          allExercises = [...libraryExercises, ...customExercises];
          if (allExercises.isNotEmpty) {
            selectedExercise = allExercises.first;
          }
          isLoadingExercises = false;
        });
      }

    } catch (e) {
      print('Error loading exercises: $e');
      if (mounted) {
        setState(() {
          isLoadingExercises = false;
          loadingError = 'Failed to load exercises: $e';
        });
      }
    }
  }

  String _getExerciseName(dynamic exercise) {
    if (exercise == null) return 'Unknown';
    try {
      if (exercise is ExerciseLibrary) {
        return exercise.exerciseName ?? 'Unnamed Exercise';
      } else if (exercise is CustomExercise) {
        return exercise.exerciseName ?? 'Unnamed Exercise';
      }
    } catch (e) {
      print('Error getting exercise name: $e');
    }
    return 'Unknown';
  }

  String _getExerciseTargetArea(dynamic exercise) {
    if (exercise == null) return '';
    try {
      if (exercise is ExerciseLibrary) {
        return exercise.targetArea ?? '';
      } else if (exercise is CustomExercise) {
        return exercise.targetArea ?? '';
      }
    } catch (e) {
      print('Error getting exercise target area: $e');
    }
    return '';
  }

  bool _isLibraryExercise(dynamic exercise) {
    return exercise is ExerciseLibrary;
  }

  int _getExerciseId(dynamic exercise) {
    if (exercise == null) return 0;
    try {
      if (exercise is ExerciseLibrary) {
        return exercise.id ?? 0;
      } else if (exercise is CustomExercise) {
        return exercise.id ?? 0;
      }
    } catch (e) {
      print('Error getting exercise ID: $e');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Exercise',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () {
                      print('🔧 Close button pressed');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Exercise Name Section
              const Text(
                'Exercise Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              // Loading state, error state, or dropdown
              if (isLoadingExercises)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF6B578C)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading exercises...'),
                    ],
                  ),
                )
              else if (loadingError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Error loading exercises',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      Text(loadingError!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          print('🔧 Retry button pressed');
                          _loadExercises();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (allExercises.isNotEmpty)
                _buildExerciseDropdown()
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No exercises available',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Please create some exercises first in your Exercise Library.'),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Repetitions Section
              _buildTextField(
                'Number of Repetitions',
                repsController,
                'Enter repetitions (e.g., 10)',
              ),

              const SizedBox(height: 16),

              // Sets Section
              _buildTextField(
                'Number of Sets',
                setsController,
                'Enter sets (e.g., 3)',
              ),

              const SizedBox(height: 16),

              // Weight Section
              _buildWeightSection(),

              const SizedBox(height: 24),

              // Add Exercise Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isLoadingExercises || allExercises.isEmpty) 
                      ? null 
                      : () {
                          _saveExercise();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B578C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text(
                    'Add Exercise',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseDropdown() {
    if (allExercises.isEmpty) {
      print('⚠️ No exercises to display in dropdown');
      return const Text('No exercises available');
    }

    try {
      // Create dropdown items with better error handling
      final dropdownItems = <DropdownMenuItem<dynamic>>[];
      
      for (int i = 0; i < allExercises.length; i++) {
        final exercise = allExercises[i];
        try {
          final name = _getExerciseName(exercise);
          final targetArea = _getExerciseTargetArea(exercise);
          final isCustom = !_isLibraryExercise(exercise);
          
          dropdownItems.add(
            DropdownMenuItem(
              value: exercise,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '($targetArea${isCustom ? ' - Custom' : ''})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        } catch (e) {
          print('⚠️ Error creating dropdown item $i: $e');
          continue;
        }
      }

      if (dropdownItems.isEmpty) {
        return const Text('Error: No valid exercises found');
      }

      // Ensure selectedExercise is valid
      if (selectedExercise == null || !allExercises.contains(selectedExercise)) {
        selectedExercise = allExercises.first;
      }

      return DropdownButtonFormField<dynamic>(
        value: selectedExercise,
        items: dropdownItems,
        onChanged: (value) {
          if (mounted) {
            setState(() {
              selectedExercise = value;
            });
          }
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF6B578C)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF6B578C), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
        isExpanded: true,
        isDense: true,
      );
      
    } catch (e, stackTrace) {
      print('⚠️ Error building dropdown: $e');
      print('📍 Stack trace: $stackTrace');
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Error building dropdown:', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text('$e', style: const TextStyle(color: Colors.red, fontSize: 12)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadExercises,
              child: const Text('Reload'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF6B578C)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF6B578C)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF6B578C), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weight (optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter weight (e.g., 50)',
                  hintStyle: const TextStyle(color: Color(0xFF6B578C)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF6B578C)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF6B578C), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6B578C)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedUnit,
                underline: const SizedBox(),
                items: unitOptions.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  if (mounted && value != null) {
                    setState(() {
                      selectedUnit = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _saveExercise() {
    // Validation
    if (selectedExercise == null) {
      _showError('Please select an exercise');
      return;
    }
    
    final repsText = repsController.text.trim();
    final setsText = setsController.text.trim();
    final weightText = weightController.text.trim();
    
    final reps = int.tryParse(repsText) ?? 0;
    final sets = int.tryParse(setsText) ?? 0;
    final weight = weightText.isEmpty ? 0 : (int.tryParse(weightText) ?? 0);

    if (reps <= 0) {
      _showError('Please enter a valid number of repetitions (greater than 0)');
      return;
    }

    if (sets <= 0) {
      _showError('Please enter a valid number of sets (greater than 0)');
      return;
    }

    try {
      final routineExercise = RoutineExercise(
        workoutRoutineFactId: 0,
        exerciseLibraryDimId: _isLibraryExercise(selectedExercise) 
            ? _getExerciseId(selectedExercise)
            : null,
        userExerciseDimId: !_isLibraryExercise(selectedExercise) 
            ? _getExerciseId(selectedExercise)
            : null,
        repetitions: reps,
        sets: sets,
        weight: weight,
        weightUnit: selectedUnit,
        exerciseName: _getExerciseName(selectedExercise),
        targetArea: _getExerciseTargetArea(selectedExercise),
      );

      print('✅ Created routine exercise: ${routineExercise.exerciseName}');
      
      widget.onExerciseAdded(routineExercise);

    } catch (e) {
      _showError('Error adding exercise: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    repsController.dispose();
    setsController.dispose();
    weightController.dispose();
    super.dispose();
  }
}