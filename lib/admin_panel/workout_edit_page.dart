import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thryv/admin_panel/widgets/SetTimeRepSelector.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:hive/hive.dart';
import 'package:thryv/models/user_goal_model.dart';

class EditWorkoutScreen extends StatefulWidget {
  final WorkoutPlan workout;
  final int index;
  final UserGoalModel userGoal;

  const EditWorkoutScreen({
    super.key,
    required this.workout,
    required this.index,
    required this.userGoal,
  });

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late TextEditingController _nameController;
  late TextEditingController _instructionController;
  late TextEditingController _infoController;
  late TextEditingController _setController;
  late TextEditingController _typeController;
  late TextEditingController _valueController;

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout.workoutName);
    _setController = TextEditingController(
      text: widget.workout.sets?.toString(),
    );
    _typeController = TextEditingController(text: widget.workout.unitType);
    _valueController = TextEditingController(text: widget.workout.unitValue);
    _instructionController = TextEditingController(
      text: widget.workout.instruction,
    );
    _infoController = TextEditingController(text: widget.workout.information);
    _pickedImage =
        widget.workout.imageUrl != null ? File(widget.workout.imageUrl!) : null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() async {
    final updatedWorkout = WorkoutPlan(
      workoutName: _nameController.text.trim(),
      instruction: _instructionController.text.trim(),
      information: _infoController.text.trim(),
      imageUrl: _pickedImage?.path,
    );

    widget.userGoal.workoutPlans![widget.index] = updatedWorkout;

    final box = await Hive.openBox<UserGoalModel>('userGoalBox');
    await box.put('usergoal', widget.userGoal);

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workout'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(height: 5),
            _buildTextField(
              _nameController,
              'Workout Name',
              Icons.fitness_center,
            ),
            const SizedBox(height: 12),
            _buildTextField(_instructionController, 'Instructions', Icons.list),
            const SizedBox(height: 12),
            _buildTextField(_infoController, 'Information', Icons.info),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(46),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.timer,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Set / Time / Reps',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SetTimeRepSelector(
                    setsController: _setController,
                    modeController: _typeController,
                    valueController: _valueController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Workout Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child:
                    _pickedImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        : const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColorLight),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
