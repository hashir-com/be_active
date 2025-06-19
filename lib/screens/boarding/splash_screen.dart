import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thryv/helpers/hive_setup_registration.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/screens/home/navigation_screen.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final userBox = Hive.box<UserModel>('userBox');
    final bool hasUserData = userBox.get('user') != null;

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  hasUserData ? const NavigationScreen() : OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              // Center(
              //   child: Container(
              //     height: 180,
              //     width: 180,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: const Color.fromARGB(255, 0, 0, 0),
              //       border: Border.all(color: Colors.white, width: 2),
              //     ),
              //   ),
              // ),
              // Center(
              //   child: Container(
              //     height: 200,
              //     width: 200,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: const Color.fromARGB(0, 0, 0, 0),
              //       border: Border.all(color: Colors.white, width: 2),
              //     ),
              //   ),
              // ),
              Center(
                child: Text(
                  'Train. Track. Transform.',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
