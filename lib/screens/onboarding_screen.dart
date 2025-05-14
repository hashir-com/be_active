import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'create_account_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 184, 79, 255), Color(0xFF001AFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Two circles slightly above center
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1, // adjust to position
            left:
                MediaQuery.of(context).size.width / 2 -
                145, // center horizontally
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(104, 255, 255, 255),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(94, 255, 255, 255),
                      width: 2,
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 10,
                  child: Lottie.asset(
                    'assets/sleep.json',
                    width: 70,
                    height: 70,
                  ),
                ),
                Positioned(
                  top: 23,
                  left: 10,
                  child: Lottie.asset(
                    'assets/running.json',
                    width: 300,
                    height: 300,
                  ),
                ),
                Positioned(
                  top: -10,
                  left: 10,
                  child: Lottie.asset(
                    'assets/food.json',
                    width: 100,
                    height: 100,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 30,
                  child: Lottie.asset(
                    'assets/water.json',
                    width: 100,
                    height: 100,
                  ),
                ),
                Positioned(
                  top: 180,
                  right: 10,
                  child: Lottie.asset(
                    'assets/weight.json',
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 30,
            child: Text(
              "Create Good\nHabits",
              style: GoogleFonts.righteous(
                fontSize: 44,
                height: 1,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 30,
            child: Text(
              "Change your Life by slowly adding new Healthy habits\nand sticking to them.",
              style: GoogleFonts.roboto(
                fontSize: 12,
                height: 1,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 85,
            bottom: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF001AFF),
                backgroundColor: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ), // text (foreground) color
                padding: EdgeInsets.symmetric(horizontal: 82, vertical: 6),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
