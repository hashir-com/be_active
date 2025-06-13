import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/user_goal_model.dart';

String name = '';
String sex = '';
String height = '';
String weight = '';
double bmi = 0;

UserGoal? selectedGoal;

class BmiCard extends StatelessWidget {
  final double bmi;

  const BmiCard({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final isDesktop = width > 1000;

    String bmiCategory = _getBmiCategory(bmi);
    String bmiCategoryinfo = _getBmiCategoryinfo(bmi);
    Color bmiColor = _getBmiColor(bmi);

    return Container(
      width: double.infinity,
      height:
          isDesktop
              ? 150
              : isTablet
              ? 130
              : 100,
      padding: const EdgeInsets.all(16),
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
                fontSize: isDesktop ? 24 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height:
                  isDesktop
                      ? 110
                      : isTablet
                      ? 90
                      : 70,
              width:
                  isDesktop
                      ? 110
                      : isTablet
                      ? 90
                      : 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bmiColor,
              ),
              child: Center(
                child: Text(
                  bmi.toStringAsFixed(1),
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop ? 32 : 24,
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
              _getBmiCategory(bmi),
              style: GoogleFonts.roboto(
                fontSize: isDesktop ? 22 : 18,
                color: bmiColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
