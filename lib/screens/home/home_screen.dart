// ignore_for_file: unused_element

import 'package:thryv/screens/home/widgets/tracker_card.dart';
import 'package:thryv/screens/tracking/meal_tracking/calorie_tracking_page.dart';
import 'package:thryv/screens/tracking/steps.dart';
import 'package:thryv/screens/tracking/water.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/util/meal_tracking_util.dart';
import 'package:thryv/util/steps_tracking.util.dart';
import 'package:thryv/util/water_tracking_util.dart';
import '../explore screen/explore_screen.dart';
import '../settings_screen.dart';
import '../progress_screen.dart';
import 'package:thryv/widgets/date_horizontal.dart';
import 'package:hive/hive.dart';
import 'package:thryv/screens/home/widgets/bmi_card.dart';
import 'package:thryv/models/user_goal_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserGoal? selectedGoal;
  @override
  void initState() {
    super.initState();
    final user = HiveService().getUser();
    final usergoal = HiveService().getUserGoal();
    if (user != null) {
      name = user.name;
      sex = user.gender;
      height = user.height.toString();
      weight = user.weight.toString();

      double h = user.height;
      double w = user.weight;
      if (h > 0) {
        bmi = w / ((h / 100) * (h / 100));
        user.bmi = bmi;
        user.save();
      }

      selectedGoal = usergoal?.goal;
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.2),
        child: Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(top: height * 0.07, left: width * 0.05),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  "Hi, $name",
                  style: GoogleFonts.righteous(
                    fontSize: width * 0.09,
                    color: theme.highlightColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Let’s make habit together!",
                style: GoogleFonts.roboto(
                  fontSize: width * 0.035,
                  color: theme.highlightColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalDateList(),
              const SizedBox(height: 20),
              Text(
                "Suggested",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                children:
                    UserGoal.values.map((goal) {
                      final isSelected = goal == selectedGoal;
                      return SizedBox(
                        width: width * 0.29,
                        child: ChoiceChip(
                          checkmarkColor: theme.highlightColor,
                          label: Text(userGoalToString(goal)),
                          selected: isSelected,
                          selectedColor: theme.primaryColor,
                          labelStyle: TextStyle(
                            color:
                                isSelected
                                    ? theme.highlightColor
                                    : Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color,
                            fontSize: isSelected ? width * 0.028 : width * 0.03,
                          ),
                          onSelected: (selected) {
                            // if (selected) {
                            //   _saveGoal(goal);
                            // }
                          },
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              BmiCard(),
              const SizedBox(height: 10),
              // Text(
              //   "You have selected: ${selectedGoal != null ? userGoalToString(selectedGoal!) : 'N/A'}",
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: theme.textTheme.bodyMedium!.color,
              //   ),
              // ),
              const SizedBox(height: 10),

              FutureBuilder<Map<String, num>>(
                future: getTodayCaloriesAndGoal(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Error loading data');
                  }

                  final data = snapshot.data!;
                  final cal = data['calories'] ?? 0;
                  final goal = data['goal'] ?? 1750;

                  return TrackerCard(
                    label: "Cal",
                    icon: Icons.local_dining,
                    value: cal.toInt(),
                    goal: goal.toInt(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MealTrackerPage(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),

              FutureBuilder<Map<String, int>>(
                future: getTodayWaterIntakeAndGoal(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); // or a placeholder card
                  }

                  final data = snapshot.data!;
                  final waterIntake = data['intake']!;
                  final waterGoal = data['goal']!;

                  return TrackerCard(
                    label: "Water",
                    icon: Icons.water_drop_outlined,
                    value: waterIntake,
                    goal: waterGoal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WaterScreen()),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, int>>(
                future:
                    getTodayStepsAndGoal(), // call the steps utility function
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); // or a placeholder card
                  }

                  final data = snapshot.data!;
                  final stepsToday = data['steps']!;
                  final dailyGoal = data['goal']!;
                  return TrackerCard(
                    label: "steps",
                    icon: Icons.directions_walk,
                    value: stepsToday,
                    goal: dailyGoal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StepCounterScreen()),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
