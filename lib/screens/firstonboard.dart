import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FirstOnboardingPage extends StatelessWidget {
  const FirstOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 184, 79, 255), Color(0xFF001AFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width / 2 - 145,
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
                child: Lottie.asset('assets/sleep.json', width: 70, height: 70),
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
            "Create\nGood Habits",
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
      ],
    );
  }
}
