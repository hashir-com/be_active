import 'dart:typed_data'; // ⬅️ Instead of dart:io
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // ⬅️ Cross-platform file picker
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/services/data_service.dart';

class WorkoutFormController extends ChangeNotifier {
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController workoutInstructionController = TextEditingController();
  final TextEditingController workoutInfoController = TextEditingController();
  final TextEditingController workoutImageController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController unitTypeController = TextEditingController();
  final TextEditingController unitValueController = TextEditingController();

  Uint8List? _pickedImage; // ⬅️ Use Uint8List instead of File
  Uint8List? get pickedImage => _pickedImage;

  String? _imageName; // Optional for future use
  String? get imageName => _imageName;

  final DataService _dataService;

  WorkoutFormController(this._dataService);

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      _pickedImage = result.files.single.bytes!;
      _imageName = result.files.single.name;
      workoutImageController.text = _imageName ?? 'Picked Image';
      notifyListeners();
    }
  }

  void deleteImage() {
    _pickedImage = null;
    _imageName = null;
    workoutImageController.clear();
    notifyListeners();
  }

  void addWorkout(BuildContext context) {
    if (workoutNameController.text.isEmpty ||
        workoutInstructionController.text.isEmpty ||
        workoutInfoController.text.isEmpty ||
        setsController.text.isEmpty ||
        unitTypeController.text.isEmpty ||
        unitValueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all workout fields!')),
      );
      return;
    }

    final workout = WorkoutPlan(
      workoutName: workoutNameController.text,
      instruction: workoutInstructionController.text,
      information: workoutInfoController.text,
      dietImageBytes: _pickedImage, // Optional: store file name or base64 string
      sets: int.tryParse(setsController.text) ?? 0,
      unitType: unitTypeController.text,
      unitValue: unitValueController.text,
    );

    _dataService.currentUserGoal!.workoutPlans ??= [];
    _dataService.currentUserGoal!.workoutPlans!.add(workout);
    _dataService.saveUserGoal();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout added successfully!')),
    );

    clearForm();
  }

  void clearForm() {
    workoutNameController.clear();
    workoutInstructionController.clear();
    workoutInfoController.clear();
    setsController.clear();
    unitTypeController.clear();
    unitValueController.clear();
    deleteImage();
  }

  @override
  void dispose() {
    workoutNameController.dispose();
    workoutInstructionController.dispose();
    workoutInfoController.dispose();
    workoutImageController.dispose();
    setsController.dispose();
    unitTypeController.dispose();
    unitValueController.dispose();
    super.dispose();
  }
}
