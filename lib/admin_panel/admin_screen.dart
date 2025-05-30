import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thryv/admin_panel/edit_diet_screen.dart';
import 'package:thryv/admin_panel/widgets/image_pick_widget.dart';
import 'package:thryv/admin_panel/widgets/meal_type_dropdown.dart';
import 'package:thryv/admin_panel/widgets/workout_edit_page.dart';
import 'package:thryv/models/diet_model.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/screens/explore screen/diet_detail_screen.dart';
import 'package:thryv/screens/explore screen/workout_detail_screen.dart';
import '../models/user_goal_model.dart';
import 'package:thryv/admin_panel/widgets/inforow_widget.dart';
import 'package:thryv/admin_panel/widgets/inputfield_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory(); // app directory
      final fileName = basename(picked.path); // file name only
      final savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName');

      setState(() {
        _pickedImage = savedImage;
        _workoutImageController.text = savedImage.path; // save local path
      });
    }
  }

  void _deleteImage() {
    if (_pickedImage != null && _pickedImage!.existsSync()) {
      _pickedImage!.deleteSync(); // optional: remove from storage
    }
    setState(() {
      _pickedImage = null;
      _workoutImageController.clear();
    });
  }

  final _workoutNameController = TextEditingController();
  final _workoutInstructionController = TextEditingController();
  final _workoutInfoController = TextEditingController();
  final _workoutImageController = TextEditingController();
  final _dietNameController = TextEditingController();
  final _mealTypeController = TextEditingController();
  final _dietServingsController = TextEditingController();
  final _dietCaloriesController = TextEditingController();

  late Box<UserGoalModel> userGoalBox;
  UserGoalModel? userGoal;
  DietPlan? diet;

  UserModel? user;

  @override
  void initState() {
    super.initState();
    final dietbox = Hive.box<DietPlan>('dietPlans');
    final box = Hive.box<UserModel>('userBox');
    final goalbox = Hive.box<UserGoalModel>('userGoalBox');
    userGoalBox = goalbox;
    userGoal = goalbox.get('goal') ?? UserGoalModel();
    user = box.get('user');
    diet = dietbox.get('diet');
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    _workoutInstructionController.dispose();
    _workoutInfoController.dispose();
    _workoutImageController.dispose();
    _dietNameController.dispose();
    _dietServingsController.dispose();
    _dietCaloriesController.dispose();
    super.dispose();
  }

  Future<void> saveUserGoal() async {
    await userGoalBox.put('goal', userGoal!);
  }

  void addWorkout(BuildContext context) {
    if (_workoutNameController.text.isEmpty ||
        _workoutInstructionController.text.isEmpty ||
        _workoutInfoController.text.isEmpty) {
      return;
    }
    final workout = WorkoutPlan(
      workoutName: _workoutNameController.text,
      instruction: _workoutInstructionController.text,
      information: _workoutInfoController.text,
      imageUrl: _pickedImage?.path,
    );
    userGoal!.workoutPlans ??= [];
    userGoal!.workoutPlans!.add(workout);
    saveUserGoal();
    setState(() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Workout added successfully!')));
      _workoutNameController.clear();
      _workoutInstructionController.clear();
      _workoutInfoController.clear();
      _workoutImageController.clear();
      _deleteImage();
    });
  }

  void addDiet() {
    if (_dietNameController.text.isEmpty) return;
    final diet = DietPlan(
      mealType: _mealTypeController.text,
      dietName: _dietNameController.text,
      servings: _dietServingsController.text,
      calorie: int.tryParse(_dietCaloriesController.text) ?? 0,
      dietimage: _pickedImage?.path,
    );
    userGoal!.dietPlans ??= [];
    userGoal!.dietPlans!.add(diet);
    saveUserGoal();
    setState(() {
      _dietNameController.clear();
      _dietServingsController.clear();
      _dietCaloriesController.clear();
      _deleteImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.10),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.only(top: height * 0.02, left: width * 0.07),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  "Admin Panel",
                  style: GoogleFonts.roboto(
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Details",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: const Color.fromARGB(0, 255, 193, 7),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            infoRow(Icons.person, "Name", user!.name, theme),
                            infoRow(Icons.cake, "Age", "${user!.age}", theme),
                            infoRow(Icons.male, "Gender", user!.gender, theme),
                            infoRow(
                              Icons.height,
                              "Height",
                              "${user!.height} cm",
                              theme,
                            ),
                            infoRow(
                              Icons.monitor_weight,
                              "Weight",
                              "${user!.weight} kg",
                              theme,
                            ),
                            infoRow(
                              Icons.fitness_center,
                              "BMI",
                              user!.bmi?.toStringAsFixed(1) ?? 'N/A',
                              theme,
                            ),
                            infoRow(
                              Icons.flag,
                              "Goal",
                              userGoal?.goal != null
                                  ? userGoalToString(userGoal!.goal!)
                                  : 'Not selected',
                              theme,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Add Workout',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildInputField('Workout Name', _workoutNameController),
                    const SizedBox(height: 10),
                    buildInputField(
                      'Instruction',
                      _workoutInstructionController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    buildInputField(
                      'Information',
                      _workoutInfoController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    buildImagePickerField(
                      'Workout Image',
                      _pickedImage,
                      _pickImage,
                      _deleteImage,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          addWorkout(context);
                        },
                        icon: const Icon(
                          Icons.fitness_center,
                          color: Color.fromARGB(255, 20, 0, 149),
                        ),
                        label: const Text(
                          'Add Workout',
                          style: TextStyle(
                            color: Color.fromARGB(255, 9, 1, 114),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            253,
                            253,
                            253,
                          ),
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      'Add Diet Item',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GradientDropdown(
                      label: 'Meal Type',
                      options: [
                        'Breakfast',
                        'Morning Snack',
                        'Lunch',
                        'Evening Tea',
                        'Dinner',
                      ],
                      controller: _mealTypeController,
                    ),

                    const SizedBox(height: 10),
                    buildInputField('Diet Name', _dietNameController),
                    const SizedBox(height: 10),
                    buildInputField(
                      'Servings',
                      _dietServingsController,
                      // keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    buildInputField(
                      'Calories',
                      _dietCaloriesController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    buildImagePickerField(
                      'Workout Image',
                      _pickedImage,
                      _pickImage,
                      _deleteImage,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton.icon(
                        onPressed: addDiet,
                        icon: const Icon(Icons.restaurant, color: Colors.white),
                        label: const Text(
                          'Add Diet Item',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    if (userGoal?.workoutPlans?.isNotEmpty ?? false) ...[
                      const Text(
                        'Saved Workouts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userGoal!.workoutPlans!.length,
                        itemBuilder: (context, index) {
                          final workout = userGoal!.workoutPlans![index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(42),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading:
                                  workout.imageUrl != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(workout.imageUrl!),
                                          width: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.fitness_center,
                                        color: Colors.indigo,
                                      ),
                              title: Text(workout.workoutName ?? ''),
                              subtitle: Text(workout.instruction ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Confirm Deletion",
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this workout?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          ctx,
                                                        ).pop(), // Cancel
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    userGoal!.workoutPlans!
                                                        .removeAt(index);
                                                    saveUserGoal();
                                                  });
                                                  Navigator.of(
                                                    ctx,
                                                  ).pop(); // Close the dialog
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditWorkoutScreen(
                                                workout: workout,
                                                index: index,
                                                userGoal: userGoal!,
                                              ),
                                        ),
                                      );
                                    },
                                    tooltip: 'Edit',
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => WorkoutDetailScreen(
                                          workout: workout,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),

                    if (userGoal?.dietPlans?.isNotEmpty ?? false) ...[
                      const Text(
                        'Saved Diet Items',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userGoal!.dietPlans!.length,
                        itemBuilder: (context, index) {
                          final diet = userGoal!.dietPlans![index];
                          // ✅ Not diet.keyAt!

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(42),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading:
                                  diet.dietimage != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(diet.dietimage!),
                                          width: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => const Icon(
                                                Icons.restaurant_menu_rounded,
                                                color: Colors.grey,
                                              ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.fitness_center,
                                        color: Colors.indigo,
                                      ),
                              title: Text(diet.mealType ?? ''),
                              subtitle: Text(
                                '${diet.dietName}\n Servings: ${diet.servings}\n Calories: ${diet.calorie}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Confirm Deletion",
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this workout?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          ctx,
                                                        ).pop(), // Cancel
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    userGoal!.dietPlans!
                                                        .removeAt(index);
                                                    saveUserGoal();
                                                  });
                                                  Navigator.of(
                                                    ctx,
                                                  ).pop(); // Close the dialog
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      // Validate index before pushing
                                      if (index < 0 ||
                                          index >=
                                              (userGoal?.dietPlans?.length ??
                                                  0)) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Invalid diet item index.',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final edited = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditDietScreen(
                                                diet: diet,
                                                index: index,
                                                userGoal: userGoal!,
                                              ),
                                        ),
                                      );

                                      if (edited == true) {
                                        setState(() {
                                          // Refresh UI after editing
                                        });
                                      }
                                    },
                                    tooltip: 'Edit',
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DietDetailScreen(
                                          diet: diet,
                                          index: index,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
