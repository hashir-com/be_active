import 'package:flutter/material.dart';
import 'package:thryv/screens/home/widgets/tracker_card.dart';
import 'package:thryv/screens/tracking/meal_tracking/calorie_tracking_page.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep.dart';
import 'package:thryv/screens/tracking/steps.dart';
import 'package:thryv/screens/tracking/water.dart';
import 'package:thryv/util/meal_tracking_util.dart';
import 'package:thryv/util/sleep_tracking_util.dart';
import 'package:thryv/util/steps_tracking.util.dart';
import 'package:thryv/util/water_tracking_util.dart';

class SetGoals extends StatefulWidget {
  const SetGoals({super.key});

  @override
  State<SetGoals> createState() => _SetGoalsState();
}

class _SetGoalsState extends State<SetGoals> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(title: Text("Set Each User Goals")),
      body: Center(
        child: Container(
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
              setState(() {});
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
