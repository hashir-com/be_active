// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';
import 'package:thryv/models/user_goal_model.dart';

class EditDietScreen extends StatefulWidget {
  final DietPlan diet;
  final int index; // Hive index for updating
  final UserGoalModel userGoal;

  const EditDietScreen({
    super.key,
    required this.diet,
    required this.index,
    required this.userGoal,
  });

  @override
  State<EditDietScreen> createState() => _EditDietScreenState();
}

class _EditDietScreenState extends State<EditDietScreen> {
  UserGoalModel? userGoal;

  late TextEditingController _typeController;
  late TextEditingController _nameController;
  late TextEditingController _servingsController;
  late TextEditingController _caloriesController;

  Uint8List? _pickedImage;

  @override
  void initState() {
    super.initState();
    loadUserGoal();
    _typeController = TextEditingController(text: widget.diet.mealType);
    _nameController = TextEditingController(text: widget.diet.dietName);
    _servingsController = TextEditingController(
      text: widget.diet.servings?.toString() ?? '',
    );
    _caloriesController = TextEditingController(
      text: widget.diet.calorie?.toString() ?? '',
    );
    _pickedImage = widget.diet.dietImageBytes;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pickedImage = bytes;
      });
    }
  }

  void loadUserGoal() async {
    final box = await Hive.openBox<UserGoalModel>('userGoalBox');
    userGoal = box.get('userGoalKey');
    setState(() {}); // refresh UI
  }

  void _saveChanges() async {
    final updatedDiet = DietPlan(
      dietName: _nameController.text.trim(),
      mealType: _typeController.text.trim(),
      servings: _servingsController.text.trim(),
      calorie: int.tryParse(_caloriesController.text.trim()) ?? 0,
      dietImageBytes: _pickedImage,
    );

    widget.userGoal.dietPlans![widget.index] = updatedDiet;

    final box = await Hive.openBox<UserGoalModel>('userGoalBox');
    await box.put('usergoal', widget.userGoal); // ensure the correct key

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Diet'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_typeController, 'Meal Type', Icons.fastfood),
            const SizedBox(height: 12),
            _buildTextField(_nameController, 'Diet Name', Icons.fastfood),
            const SizedBox(height: 12),
            _buildTextField(
              _servingsController,
              'Servings',
              Icons.restaurant_menu,
              isNumber: true,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _caloriesController,
              'Calories',
              Icons.local_fire_department,
              isNumber: true,
            ),
            const SizedBox(height: 12),
            const Text(
              'Diet Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child:
                    _pickedImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
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
                backgroundColor: Colors.green.shade700,
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
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
