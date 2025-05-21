import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:be_active/services/hive_service.dart';
import 'package:be_active/models/user_model.dart';
import 'explore_screen.dart';
import 'settings_screen.dart';
import 'progress_screen.dart';
import 'package:be_active/widgets/date_horizontal.dart';

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.2),
        child: Container(
          color: const Color(0xFF040B90),
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
          children: [
            HorizontalDateList(),
            SizedBox(height: 20),
            _buildBmiCard(width),
            SizedBox(height: height * 0.04),
            const Text("", style: TextStyle(color: Colors.grey)),
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
        color: const Color(0xFF040B90),
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
                color: Colors.white,
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
                    color: bmi < 18.5 ? const Color(0xFF040B90) : Colors.white,
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
    if (bmi < 18.5) {
      return "Build Strength";
    }
    if (bmi < 25) {
      return "Stay Consistent";
    }
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
