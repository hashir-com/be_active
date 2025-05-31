import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/services/data_service.dart';
import 'package:thryv/util/image_utility.dart';

class WorkoutFormController extends ChangeNotifier {
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController workoutInstructionController = TextEditingController();
  final TextEditingController workoutInfoController = TextEditingController();
  final TextEditingController workoutImageController = TextEditingController();

  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  final DataService _dataService;

  WorkoutFormController(this._dataService);

  Future<void> pickImage() async {
    final path = await ImageUtility.pickImage();
    if (path != null) {
      _pickedImage = File(path);
      workoutImageController.text = path;
      notifyListeners(); 
    }
  }

  void deleteImage() {
    ImageUtility.deleteImage(_pickedImage?.path);
    _pickedImage = null;
    workoutImageController.clear();
    notifyListeners();
  }

  void addWorkout(BuildContext context) {
    if (workoutNameController.text.isEmpty ||
        workoutInstructionController.text.isEmpty ||
        workoutInfoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all workout fields!')),
      );
      return;
    }

    final workout = WorkoutPlan(
      workoutName: workoutNameController.text,
      instruction: workoutInstructionController.text,
      information: workoutInfoController.text,
      imageUrl: _pickedImage?.path,
    );

    _dataService.currentUserGoal!.workoutPlans ??= [];
    _dataService.currentUserGoal!.workoutPlans!.add(workout);
    _dataService.saveUserGoal();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout added successfully!')),
    );

    // Clear form and image
    clearForm();
  }

  void clearForm() {
    workoutNameController.clear();
    workoutInstructionController.clear();
    workoutInfoController.clear();
    deleteImage(); 
  }

  @override
  void dispose() {
    workoutNameController.dispose();
    workoutInstructionController.dispose();
    workoutInfoController.dispose();
    workoutImageController.dispose();
    super.dispose();
  }
}