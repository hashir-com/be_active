import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';
import 'package:thryv/services/data_service.dart';

class DietFormController extends ChangeNotifier {
  final TextEditingController dietNameController = TextEditingController();
  final TextEditingController mealTypeController = TextEditingController();
  final TextEditingController dietServingsController = TextEditingController();
  final TextEditingController dietCaloriesController = TextEditingController();

  Uint8List? _pickedImage;
  Uint8List? get pickedImage => _pickedImage;
  String? _imageName; // optionally store name for reference
  String? get imageName => _imageName;

  final DataService _dataService;

  DietFormController(this._dataService);

  /// ✅ Picks image for both web and mobile
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      _pickedImage = result.files.single.bytes;
      _imageName = result.files.single.name;
      notifyListeners();
    }
  }

  void deleteImage() {
    _pickedImage = null;
    _imageName = null;
    notifyListeners();
  }

  void addDiet() {
    if (dietNameController.text.isEmpty ||
        mealTypeController.text.isEmpty ||
        dietServingsController.text.isEmpty ||
        dietCaloriesController.text.isEmpty) {
      // You might want to show a SnackBar or error here
      return;
    }

    final diet = DietPlan(
      mealType: mealTypeController.text,
      dietName: dietNameController.text,
      servings: dietServingsController.text,
      calorie: int.tryParse(dietCaloriesController.text) ?? 0,
      dietImageBytes: _pickedImage, // store image bytes
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
