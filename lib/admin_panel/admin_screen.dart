import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Keep hive_flutter for ValueListenableBuilder
import 'package:thryv/admin_panel/widgets/image_pick_widget.dart';
import 'package:thryv/admin_panel/widgets/meal_type_dropdown.dart';
import 'package:thryv/admin_panel/widgets/inforow_widget.dart';
import 'package:thryv/admin_panel/widgets/inputfield_widget.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/screens/home/widgets/bmi_card.dart';
import 'package:thryv/services/data_service.dart'; // Import the new DataService
import 'package:thryv/admin_panel/controllers/workout_form_controller.dart'; // Import controllers
import 'package:thryv/admin_panel/controllers/diet_form_controller.dart';
import 'package:thryv/admin_panel/widgets/workout_list_item.dart'; // Import new list item widgets
import 'package:thryv/admin_panel/widgets/diet_list_item.dart';
import 'package:thryv/services/hive_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  // Use a single instance of DataService for data access
  final DataService _dataService = DataService();

  // Use ChangeNotifiers for form state management
  late WorkoutFormController _workoutFormController;
  late DietFormController _dietFormController;

  @override
  void initState() {
    super.initState();
    // Initialize DataService and load data
    _dataService.init().then((_) {
      setState(() {
        // Force a rebuild after data is loaded
      });
    });

    _workoutFormController = WorkoutFormController(_dataService);
    _dietFormController = DietFormController(_dataService);

    // Add listeners to controllers to rebuild the UI when their state changes
    _workoutFormController.addListener(_onFormControllerChanged);
    _dietFormController.addListener(_onFormControllerChanged);
  }

  void _onFormControllerChanged() {
    setState(() {
      // Rebuild the UI when any form controller notifies changes
    });
  }

  @override
  void dispose() {
    _workoutFormController.removeListener(_onFormControllerChanged);
    _dietFormController.removeListener(_onFormControllerChanged);
    _workoutFormController.dispose();
    _dietFormController.dispose();
    super.dispose();
  }

  // Helper method to convert UserGoalEnum to String for UI display
  String userGoalToString(UserGoal goal) {
    switch (goal) {
      case UserGoal.weightLoss:
        return 'Lose Weight';
      case UserGoal.weightGain:
        return 'Gain Weight';
      case UserGoal.muscleGain:
        return 'Muscle Gain';
    }
  }

  void _saveGoal(UserGoal goal) {
    HiveService().saveUserGoal(goal);
    setState(() {
      selectedGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // It's safer to check if user and userGoal are loaded before accessing their properties
    if (_dataService.currentUser == null ||
        _dataService.currentUserGoal == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      _buildUserDetailsSection(theme),
                      SizedBox(height: 10),
                      Text(
                        "Suggest User Goal",
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontSize: 16,
                        ),
                      ),
                      Wrap(
                        spacing: 4,
                        children:
                            UserGoal.values.map((goal) {
                              final isSelected = goal == selectedGoal;
                              return SizedBox(
                                width: width * 0.29,
                                child: ChoiceChip(
                                  checkmarkColor: theme.highlightColor,
                                  label: Text(userGoalToString(goal)),
                                  selected: isSelected,
                                  selectedColor: theme.primaryColorLight,
                                  labelStyle: TextStyle(
                                    color:
                                        isSelected
                                            ? theme.highlightColor
                                            : Theme.of(
                                              context,
                                            ).textTheme.bodyMedium!.color,
                                    fontSize:
                                        isSelected
                                            ? width * 0.028
                                            : width * 0.03,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      _saveGoal(goal);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 10),
                      _buildAddWorkoutSection(context),
                      _buildAddDietSection(context),
                      _buildSavedWorkoutsList(),
                      const SizedBox(height: 24),
                      _buildSavedDietItemsList(),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
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
                infoRow(
                  Icons.person,
                  "Name",
                  _dataService.currentUser!.name,
                  theme,
                ),
                infoRow(
                  Icons.cake,
                  "Age",
                  "${_dataService.currentUser!.age}",
                  theme,
                ),
                infoRow(
                  Icons.male,
                  "Gender",
                  _dataService.currentUser!.gender,
                  theme,
                ),
                infoRow(
                  Icons.height,
                  "Height",
                  "${_dataService.currentUser!.height} cm",
                  theme,
                ),
                infoRow(
                  Icons.monitor_weight,
                  "Weight",
                  "${_dataService.currentUser!.weight} kg",
                  theme,
                ),
                infoRow(
                  Icons.fitness_center,
                  "BMI",
                  _dataService.currentUser!.bmi?.toStringAsFixed(1) ?? 'N/A',
                  theme,
                ),
                infoRow(
                  Icons.flag,
                  "Goal",
                  _dataService.currentUserGoal?.goal != null
                      ? userGoalToString(_dataService.currentUserGoal!.goal!)
                      : 'Not selected',
                  theme,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddWorkoutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Workout',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        buildInputField(
          'Workout Name',
          _workoutFormController.workoutNameController,
        ),
        const SizedBox(height: 10),
        buildInputField(
          'Instruction',
          _workoutFormController.workoutInstructionController,
          maxLines: 2,
        ),
        const SizedBox(height: 10),
        buildInputField(
          'Information',
          _workoutFormController.workoutInfoController,
          maxLines: 2,
        ),
        const SizedBox(height: 10),
        buildImagePickerField(
          'Workout Image',
          _workoutFormController
              .pickedImage, // Use the controller's picked image
          _workoutFormController.pickImage,
          _workoutFormController.deleteImage,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ElevatedButton.icon(
            onPressed: () => _workoutFormController.addWorkout(context),
            icon: const Icon(
              Icons.fitness_center,
              color: Color.fromARGB(255, 20, 0, 149),
            ),
            label: const Text(
              'Add Workout',
              style: TextStyle(color: Color.fromARGB(255, 9, 1, 114)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 253, 253, 253),
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildAddDietSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          options: const [
            'Breakfast',
            'Morning Snack',
            'Lunch',
            'Evening Tea',
            'Dinner',
          ],
          controller: _dietFormController.mealTypeController,
        ),
        const SizedBox(height: 10),
        buildInputField('Diet Name', _dietFormController.dietNameController),
        const SizedBox(height: 10),
        buildInputField('Servings', _dietFormController.dietServingsController),
        const SizedBox(height: 10),
        buildInputField(
          'Calories',
          _dietFormController.dietCaloriesController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        buildImagePickerField(
          'Diet Image',
          _dietFormController.pickedImage, // Use the controller's picked image
          _dietFormController.pickImage,
          _dietFormController.deleteImage,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ElevatedButton.icon(
            onPressed: _dietFormController.addDiet,
            icon: const Icon(
              Icons.restaurant_menu_rounded,
              color: Colors.white,
            ),
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
      ],
    );
  }

  Widget _buildSavedWorkoutsList() {
    return ValueListenableBuilder<Box<UserGoalModel>>(
      valueListenable: Hive.box<UserGoalModel>('userGoalBox').listenable(),
      builder: (context, box, _) {
        final userGoal = box.get('usergoal') ?? UserGoalModel();
        if (userGoal.workoutPlans?.isEmpty ?? true) {
          return const SizedBox.shrink(); // Hide if no workouts
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              itemCount: userGoal.workoutPlans!.length,
              itemBuilder: (context, index) {
                final workout = userGoal.workoutPlans![index];
                return WorkoutListItem(
                  workout: workout,
                  index: index,
                  userGoal: userGoal,
                  onWorkoutDeleted: () {
                    _dataService.saveUserGoal(); // Save after deletion
                    setState(() {}); // Rebuild to update the list
                  },
                  onWorkoutEdited: () {
                    _dataService.saveUserGoal(); // Save after edit
                    setState(() {}); // Rebuild to update the list
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSavedDietItemsList() {
    return ValueListenableBuilder<Box<UserGoalModel>>(
      valueListenable: Hive.box<UserGoalModel>('userGoalBox').listenable(),
      builder: (context, box, _) {
        final userGoal = box.get('usergoal') ?? UserGoalModel();
        if (userGoal.dietPlans?.isEmpty ?? true) {
          return const SizedBox.shrink(); // Hide if no diets
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              itemCount: userGoal.dietPlans!.length,
              itemBuilder: (context, index) {
                final diet = userGoal.dietPlans![index];
                return DietListItem(
                  diet: diet,
                  index: index,
                  userGoal: userGoal,
                  onDietDeleted: () {
                    _dataService.saveUserGoal(); // Save after deletion
                    setState(() {}); // Rebuild to update the list
                  },
                  onDietEdited: () {
                    _dataService.saveUserGoal(); // Save after edit
                    setState(() {}); // Rebuild to update the list
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
