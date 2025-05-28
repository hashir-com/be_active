import 'package:thryv/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/user_model.dart';
import '../explore_screen.dart';
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
        user.bmi = bmi; // ✅ Update value
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
              SafeArea(
                child: Text(
                  "Hi, $name",
                  style: GoogleFonts.righteous(
                    fontSize: width * 0.09,
                    color: Colors.white,
                  ),
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
                    return SizedBox(
                      width: width * 0.29,
                      child: ChoiceChip(
                        checkmarkColor: Colors.white,
                        label: Text(userGoalToString(goal)),
                        selected: isSelected,
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                          fontSize: isSelected ? width * 0.028 : width * 0.03,
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
            const SizedBox(height: 20),
            BmiCard(),
            const SizedBox(height: 10),
            Text(
              "You have selected: ${selectedGoal != null ? userGoalToString(selectedGoal!) : 'N/A'}",
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
}


