import 'package:be_active/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:be_active/models/user_model.dart';
import 'explore_screen.dart';
import 'settings_screen.dart';
import 'progress_screen.dart';
import 'package:be_active/widgets/date_horizontal.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  String sex = '';
  String height = '';
  String weight = '';
  double bmi = 0;

  UserGoal? selectedGoal;

  @override
  void initState() {
    super.initState();
    final user = HiveService().getUser();
    if (user != null) {
      name = user.name;
      sex = user.gender;
      height = user.height.toString();
      weight = user.weight.toString();

      double h = user.height;
      double w = user.weight;
      if (h > 0) {
        bmi = w / ((h / 100) * (h / 100));
        user.bmi = bmi; // ✅ Update value
        user.save();
      }

      selectedGoal = user.goal;
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.2),
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: height * 0.07, left: width * 0.05),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $name",
                style: GoogleFonts.righteous(
                  fontSize: width * 0.07,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Let’s make habit together!",
                style: GoogleFonts.roboto(
                  fontSize: width * 0.035,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
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
              "Select Your Goal",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              children:
                  UserGoal.values.map((goal) {
                    final isSelected = goal == selectedGoal;
                    return ChoiceChip(
                      label: Text(userGoalToString(goal)),
                      selected: isSelected,
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? Theme.of(context).textTheme.bodyMedium!.color
                                : Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          _saveGoal(goal);
                        }
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            _buildBmiCard(width),
            const SizedBox(height: 10),
            Text(
              "You have selected: ${userGoalToString(selectedGoal ?? UserGoal.weightLoss)}",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCard(double width) {
    String bmiCategory = _getBmiCategory(bmi);
    String bmiCategoryinfo = _getBmiCategoryinfo(bmi);
    Color bmiColor = _getBmiColor(bmi);

    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(44),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              bmiCategoryinfo,
              style: GoogleFonts.roboto(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bmiColor,
              ),
              child: Center(
                child: Text(
                  bmi.toStringAsFixed(1),
                  style: GoogleFonts.roboto(
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.bold,
                    color:
                        bmi < 18.5
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: Text(
              bmiCategory,
              style: GoogleFonts.roboto(
                fontSize: width * 0.05,
                color: bmiColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  String _getBmiCategoryinfo(double bmi) {
    if (bmi < 18.5) return "Build Strength";
    if (bmi < 25) return "Stay Consistent";
    if (bmi < 30) return "Push Harder";
    return "Start Today";
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return const Color.fromARGB(255, 196, 223, 255);
    if (bmi < 25) return const Color.fromARGB(255, 14, 255, 22);
    if (bmi < 30) return const Color.fromARGB(255, 255, 174, 0);
    return const Color.fromARGB(255, 209, 14, 0);
  }
}

enum UserGoal { weightLoss, weightGain, muscleGain }

String userGoalToString(UserGoal goal) {
  switch (goal) {
    case UserGoal.weightLoss:
      return "Weight Loss";
    case UserGoal.weightGain:
      return "Weight Gain";
    case UserGoal.muscleGain:
      return "Muscle Gain";
  }
}
