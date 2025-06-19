import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/screens/tracking/meal_tracking/calorie_tracking_page.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep.dart';
import 'package:thryv/screens/tracking/steps.dart';
import 'package:thryv/screens/tracking/water.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:thryv/util/meal_tracking_util.dart';
import 'package:thryv/util/sleep_tracking_util.dart';
import 'package:thryv/util/steps_tracking.util.dart';
import 'package:thryv/util/water_tracking_util.dart';
import 'package:thryv/widgets/date_horizontal.dart';
import 'package:thryv/screens/home/widgets/tracker_card.dart';
import 'package:thryv/screens/home/widgets/bmi_card.dart';
import 'package:thryv/screens/explore screen/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserGoal? selectedGoal;
  String name = '', sex = '', height = '', weight = '';
  double bmi = 0.0;

  @override
  void initState() {
    super.initState();
    final user = HiveService().getUser();
    final userGoal = HiveService().getUserGoal();
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

      selectedGoal = userGoal?.goal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(top: isWide ? 40 : 60, left: 20),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $name",
                style: GoogleFonts.gochiHand(
                  fontSize: isWide ? 40 : 26,
                  color: theme.highlightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Let’s make habits together!",
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  color: theme.highlightColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 22 : 20,
              vertical: isWide ? 12 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HorizontalDateList(),
                const SizedBox(height: 20),

                Text(
                  "Your Goal",
                  style: GoogleFonts.averiaLibre(
                    fontSize: isWide ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: Wrap(
                    spacing: 8,
                    children:
                        UserGoal.values.map((goal) {
                          final isSelected = goal == selectedGoal;
                          return ChoiceChip(
                            label: Text(userGoalToString(goal)),
                            selected: isSelected,
                            onSelected: (selected) {
                              // if (selected) {
                              //   HiveService().saveUserGoal(goal);
                              //   setState(() {
                              //     selectedGoal = goal;
                              //   });
                              // }
                            },
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected
                                      ? theme.highlightColor
                                      : theme.textTheme.bodyMedium!.color,
                            ),
                            selectedColor: theme.primaryColor,
                            backgroundColor: theme.cardColor,
                            checkmarkColor: theme.highlightColor,
                          );
                        }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ExploreScreen()),
                      ),
                  child: BmiCard(bmi: bmi),
                ),

                const SizedBox(height: 25),
                Text(
                  "Today’s Trackers",
                  style: GoogleFonts.averiaLibre(
                    fontSize: isWide ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child:
                      isWide
                          ? Wrap(
                            spacing: 24,
                            runSpacing: 24,
                            alignment: WrapAlignment.spaceBetween,
                            children: _buildTrackersGrid(isWide),
                          )
                          : Column(children: _buildTrackersGrid(isWide)),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTrackersGrid(bool isWide) {
    return [
      FutureBuilder<Map<String, num>>(
        future: getTodayCaloriesAndGoal(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {'calories': 0, 'goal': 1750};
          return TrackerCard(
            label: "Calories",
            icon: Icons.local_dining,
            value: data['calories']!.toInt(),
            goal: data['goal']!.toInt(),
            iconColor: Colors.orange,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MealTrackerPage()),
              );
              setState(() {}); // Make sure this is inside a StatefulWidget
            },
          );
        },
      ),

      SizedBox(height: isWide ? 0 : 10),
      FutureBuilder<Map<String, int>>(
        future: getTodayWaterIntakeAndGoal(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {'intake': 0, 'goal': 8};
          return TrackerCard(
            label: "Water",
            icon: Icons.water_drop_outlined,
            value: data['intake']!,
            goal: data['goal']!,
            iconColor: Colors.blue,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WaterScreen()),
              );
              setState(() {});
            },
          );
        },
      ),
      SizedBox(height: isWide ? 0 : 10),
      FutureBuilder<Map<String, int>>(
        future: getTodayStepsAndGoal(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {'steps': 0, 'goal': 10000};
          return TrackerCard(
            label: "Steps",
            icon: Icons.directions_walk,
            value: data['steps']!,
            goal: data['goal']!,
            iconColor: const Color.fromARGB(255, 0, 186, 6),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StepCounterScreen()),
              );
              setState(() {});
            },
          );
        },
      ),
      SizedBox(height: isWide ? 0 : 10),
      FutureBuilder<Map<String, double>>(
        future: getTodaySleepAndGoal(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {'sleep': 0.0, 'goal': 8.0};
          return TrackerCard(
            label: "Sleep",
            icon: Icons.nightlight_round,
            value: data['sleep']!.toInt(),
            goal: data['goal']!.toInt(),
            iconColor: Colors.blueAccent,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SleepScreen()),
              );
              setState(() {});
            },
          );
        },
      ),
      SizedBox(height: isWide ? 0 : 10),
    ];
  }
}
