import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thryv/models/diet_model.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/screens/explore screen/diet_detail_screen.dart';
import 'package:thryv/screens/explore screen/workout_detail_screen.dart';
import '../models/user_goal_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final _workoutNameController = TextEditingController();
  final _workoutInstructionController = TextEditingController();
  final _workoutInfoController = TextEditingController();
  final _workoutImageController = TextEditingController();

  final _dietNameController = TextEditingController();
  final _dietServingsController = TextEditingController();
  final _dietCaloriesController = TextEditingController();

  late Box<UserGoalModel> userGoalBox;
  UserGoalModel? userGoal;

  UserModel? user;
  UserGoalModel? usergoal;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserModel>('userBox');
    final goalbox = Hive.box<UserGoalModel>('userGoalBox');
    userGoalBox = Hive.box<UserGoalModel>('userGoalBox');
    userGoal = goalbox.get('goal') ?? UserGoalModel();
    user = box.get('user');
    usergoal = goalbox.get('usergoal');
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

  void addWorkout() {
    if (_workoutNameController.text.isEmpty) return;
    final workout = WorkoutPlan(
      workoutName: _workoutNameController.text,
      instruction: _workoutInstructionController.text,
      information: _workoutInfoController.text,
      imageUrl: _workoutImageController.text,
    );
    userGoal!.workoutPlans ??= [];
    userGoal!.workoutPlans!.add(workout);
    saveUserGoal();
    setState(() {
      _workoutNameController.clear();
      _workoutInstructionController.clear();
      _workoutInfoController.clear();
      _workoutImageController.clear();
    });
  }

  void addDiet() {
    if (_dietNameController.text.isEmpty) return;
    final diet = DietPlan(
      dietName: _dietNameController.text,
      servings: int.tryParse(_dietServingsController.text) ?? 0,
      calorie: int.tryParse(_dietCaloriesController.text) ?? 0,
    );
    userGoal!.dietPlans ??= [];
    userGoal!.dietPlans!.add(diet);
    saveUserGoal();
    setState(() {
      _dietNameController.clear();
      _dietServingsController.clear();
      _dietCaloriesController.clear();
    });
  }

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color.fromARGB(0, 245, 245, 245),

        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.grey,
          ), // Default border color
        ),

        // When TextField is not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
          ), // Change this
        ),

        // When TextField is focused (clicked)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 119, 40, 255),
            width: 2,
          ), // Change this
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text("$label:", style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color.fromARGB(255, 196, 209, 255),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
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
                              usergoal?.goal != null
                                  ? userGoalToString(usergoal!.goal!)
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
                    buildInputField(
                      'Image URL or Path',
                      _workoutImageController,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton.icon(
                        onPressed: addWorkout,
                        icon: const Icon(
                          Icons.fitness_center,
                          color: Color.fromARGB(255, 20, 0, 149),
                        ),
                        label: const Text('Add Workout'),
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
                    buildInputField('Diet Name', _dietNameController),
                    const SizedBox(height: 10),
                    buildInputField(
                      'Servings',
                      _dietServingsController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    buildInputField(
                      'Calories',
                      _dietCaloriesController,
                      keyboardType: TextInputType.number,
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading:
                                  workout.imageUrl != null &&
                                          workout.imageUrl!.isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          workout.imageUrl!,
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
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    userGoal!.workoutPlans!.removeAt(index);
                                    saveUserGoal();
                                  });
                                },
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
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(
                                Icons.restaurant_menu,
                                color: Colors.green,
                              ),
                              title: Text(diet.dietName ?? ''),
                              subtitle: Text(
                                'Servings: ${diet.servings}, Calories: ${diet.calorie}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    userGoal!.dietPlans!.removeAt(index);
                                    saveUserGoal();
                                  });
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DietDetailScreen(diet: diet),
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
