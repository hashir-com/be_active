import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/services/data_service.dart';
import 'package:thryv/util/image_utility.dart';

class DietFormController extends ChangeNotifier {
  final TextEditingController dietNameController = TextEditingController();
  final TextEditingController mealTypeController = TextEditingController();
  final TextEditingController dietServingsController = TextEditingController();
  final TextEditingController dietCaloriesController = TextEditingController();

  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  final DataService _dataService;

  DietFormController(this._dataService);

  Future<void> pickImage() async {
    final path = await ImageUtility.pickImage();
    if (path != null) {
      _pickedImage = File(path);
      
      notifyListeners(); 
    }
  }

  void deleteImage() {
    ImageUtility.deleteImage(_pickedImage?.path);
    _pickedImage = null;
    notifyListeners(); 
  }

  void addDiet() {
    if (dietNameController.text.isEmpty ||
        mealTypeController.text.isEmpty ||
        dietServingsController.text.isEmpty ||
        dietCaloriesController.text.isEmpty) {
      // You might want to show a SnackBar here too
      return;
    }
    final diet = DietPlan(
      mealType: mealTypeController.text,
      dietName: dietNameController.text,
      servings: dietServingsController.text,
      calorie: int.tryParse(dietCaloriesController.text) ?? 0,
      dietimage: _pickedImage?.path,
    );
    _dataService.currentUserGoal!.dietPlans ??= [];
    _dataService.currentUserGoal!.dietPlans!.add(diet);
    _dataService.saveUserGoal();

    clearForm();
  }

  void clearForm() {
    dietNameController.clear();
    mealTypeController.clear(); 
    dietServingsController.clear();
    dietCaloriesController.clear();
    deleteImage(); 
  }

  @override
  void dispose() {
    dietNameController.dispose();
    mealTypeController.dispose();
    dietServingsController.dispose();
    dietCaloriesController.dispose();
    super.dispose();
  }
}