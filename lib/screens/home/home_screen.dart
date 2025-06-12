// ignore_for_file: unused_element

import 'package:thryv/screens/home/widgets/tracker_card.dart';
import 'package:thryv/screens/tracking/meal_tracking/calorie_tracking_page.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep.dart';
import 'package:thryv/screens/tracking/steps.dart';
import 'package:thryv/screens/tracking/water.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/util/meal_tracking_util.dart';
import 'package:thryv/util/sleep_tracking_util.dart';
import 'package:thryv/util/steps_tracking.util.dart';
import 'package:thryv/util/water_tracking_util.dart';
import '../explore screen/explore_screen.dart';
import '../settings_screen.dart';
import '../progress_screen.dart';
import 'package:thryv/widgets/date_horizontal.dart';
import 'package:hive/hive.dart';
import 'package:thryv/screens/home/widgets/bmi_card.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.2.sh),
        child: Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(top: 0.07.sh, left: 0.05.sw),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $name",
                style: GoogleFonts.gochiHand(
                  fontSize: 40.sp,
                  color: theme.highlightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Let’s make habits together!",
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
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
            horizontal: 0.05.sw,
            vertical: 0.025.sh,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalDateList(),
              SizedBox(height: 18.h),

              // Section: Suggested Goal
              Text(
                "Your Goal",
                style: GoogleFonts.averiaLibre(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 5.w,
                runSpacing: 0.h,
                children:
                    UserGoal.values.map((goal) {
                      final isSelected = goal == selectedGoal;
                      return ChoiceChip(
                        labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        checkmarkColor: theme.highlightColor,
                        label: Text(userGoalToString(goal)),
                        selected: isSelected,
                        selectedColor: theme.primaryColor,
                        backgroundColor: theme.cardColor,
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          color:
                              isSelected
                                  ? theme.highlightColor
                                  : theme.textTheme.bodyMedium!.color,
                        ),
                        onSelected: (selected) {
                          // if (selected) _saveGoal(goal);
                        },
                      );
                    }).toList(),
              ),

              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExploreScreen()),
                  );
                },
                child: BmiCard(),
              ),

              SizedBox(height: 25.h),
              Text(
                "Today’s Trackers",
                style: GoogleFonts.averiaLibre(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
              SizedBox(height: 12.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Calories Tracker
                    FutureBuilder<Map<String, num>>(
                      future: getTodayCaloriesAndGoal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              theme.primaryColor,
                            ),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('Error loading data');
                        }

                        final data = snapshot.data!;
                        final cal = data['calories'] ?? 0;
                        final goal = data['goal'] ?? 1750;

                        return TrackerCard(
                          label: "Calories",
                          icon: Icons.local_dining,
                          value: cal.toInt(),
                          goal: goal.toInt(),
                          iconColor: Colors.orange,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MealTrackerPage(),
                              ),
                            );
                            setState(() {});
                          },
                        );
                      },
                    ),
                    SizedBox(height: 18.h),

                    // Water Tracker
                    FutureBuilder<Map<String, int>>(
                      future: getTodayWaterIntakeAndGoal(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                            color: theme.primaryColorLight,
                          );
                        }

                        final data = snapshot.data!;
                        final intake = data['intake'] ?? 0;
                        final goal = data['goal'] ?? 8; // fallback value

                        return TrackerCard(
                          label: "Water",
                          icon: Icons.water_drop_outlined,
                          value: intake,
                          goal: goal,
                          iconColor: Colors.blue,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WaterScreen(),
                              ),
                            );
                            setState(() {});
                          },
                        );
                      },
                    ),
                    SizedBox(height: 18.h),

                    // Steps Tracker
                    FutureBuilder<Map<String, int>>(
                      future: getTodayStepsAndGoal(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                            color: theme.primaryColorDark,
                          );
                        }

                        final data = snapshot.data!;
                        final steps = data['steps'] ?? 0;
                        final goal = data['goal'] ?? 10000;

                        return TrackerCard(
                          label: "Steps",
                          icon: Icons.directions_walk,
                          value: steps,
                          goal: goal,
                          iconColor: const Color.fromARGB(255, 0, 186, 6),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StepCounterScreen(),
                              ),
                            );
                            setState(() {});
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<Map<String, double>>(
                      future: getTodaySleepAndGoal(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                            color: Theme.of(context).primaryColorDark,
                          );
                        }

                        final data = snapshot.data!;
                        final sleep = data['sleep'] ?? 0.0;
                        final goal = data['goal'] ?? 8.0;

                        return TrackerCard(
                          label: "Sleep",
                          icon: Icons.nightlight_round,
                          value: sleep.toInt(),
                          goal: goal.toInt(),
                          iconColor: Colors.blueAccent,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        SleepScreen(), // replace with your screen class
                              ),
                            );
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
