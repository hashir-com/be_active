import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thryv/screens/explore%20screen/diet_detail_screen.dart';
import 'package:thryv/screens/explore%20screen/workout_detail_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/user_model.dart'; // Update path as needed
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/screens/explore screen/widgets/youtube_player_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  UserModel? user;
  UserGoalModel? usergoal;
  UserGoalModel? userGoal;
  bool _isFullScreen = false;
  late Box<UserGoalModel> userGoalBox;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserModel>('userBox');
    final goalbox = Hive.box<UserGoalModel>('userGoalBox');
    userGoal = goalbox.get('goal') ?? UserGoalModel();
    user = box.get('user');
    usergoal = goalbox.get('usergoal');
  }

  Future<void> saveUserGoal() async {
    await userGoalBox.put('goal', userGoal!);
  }

  void _onFullScreenChanged(bool isFullScreen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isFullScreen = isFullScreen;
        });
      }
    });
  }

  List<String> getVideosForGoal(UserGoal? goal) {
    switch (goal) {
      case UserGoal.weightLoss:
        return ["ahnl7GaV_rU", "YJcecddIdWo"];
      case UserGoal.weightGain:
        return ["S21o1IdwWf8", "KM3ko1Z4amA"];
      case UserGoal.muscleGain:
        return ["2tM1LFFxeKg", "M4K0s792wAU"];
      default:
        return [];
    }
  }

  Widget infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text("$label:", style: theme.textTheme.titleMedium),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoIds = getVideosForGoal(usergoal?.goal);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
          _isFullScreen
              ? null
              : PreferredSize(
                preferredSize: Size.fromHeight(height * 0.15),
                child: Container(
                  color: theme.primaryColor,
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.07,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Text(
                          "Explore",
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
      body:
          user == null
              ? Center(
                child: Text(
                  "No user data found.",
                  style: theme.textTheme.headlineMedium,
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Details", style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Card(
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
                    // if added
                    const SizedBox(height: 24),
                    Text(
                      "Recommended Videos",
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ...videoIds.map(
                      (id) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: YoutubePlayerWidget(
                          videoId: id,
                          onFullScreenChanged: _onFullScreenChanged,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Display Workouts List
                    if (userGoal?.workoutPlans != null &&
                        userGoal!.workoutPlans!.isNotEmpty) ...[
                      const Text(
                        'Saved Workouts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userGoal!.workoutPlans!.length,
                        itemBuilder: (context, index) {
                          final workout = userGoal!.workoutPlans![index];
                          return Card(
                            elevation: 10,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
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

                              leading:
                                  workout.imageUrl != null
                                      ? Image.file(
                                        File(workout.imageUrl!),
                                        width: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.image_not_supported,
                                            ),
                                      )
                                      : const Icon(Icons.fitness_center),

                              title: Text(workout.workoutName ?? 'No name'),
                              subtitle: Text(workout.instruction ?? ''),
                            ),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Display Diet List
                    if (userGoal?.dietPlans != null &&
                        userGoal!.dietPlans!.isNotEmpty) ...[
                      const Text(
                        'Saved Diet Items',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userGoal!.dietPlans!.length,
                        itemBuilder: (context, index) {
                          final diet = userGoal!.dietPlans![index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading:
                                  diet.dietimage != null
                                      ? Image.file(
                                        File(diet.dietimage!),
                                        width: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.image_not_supported,
                                            ),
                                      )
                                      : const Icon(
                                        Icons.restaurant_menu_rounded,
                                        color: Colors.green,
                                      ),
                              title: Text(diet.dietName ?? 'No name'),
                              subtitle: Text(
                                'Servings: ${diet.servings ?? 0}, Calories: ${diet.calorie ?? 0}',
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
    );
  }
}
