import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'create_account_screen.dart';
import 'package:be_active/widgets/linechart.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

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
          top: MediaQuery.of(context).size.height * 0.1,
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
                    color: const Color.fromARGB(67, 255, 255, 255),
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
                    color: const Color.fromARGB(68, 255, 255, 255),
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 105,
          right: 10,
          child: SizedBox(
            height: 50,
            width: 50,
            child: Lottie.asset("assets/goal.json"),
          ),
        ),
        Positioned(
          top: 325,
          left: 20,
          child: SizedBox(
            height: 90,
            width: 90,
            child: Lottie.asset("assets/start.json"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0, left: 40, right: 40),
          child: const ProgressLineChart(),
        ),
        Positioned(
          bottom: 150,
          left: 30,
          child: Text(
            "Track Your\nProgress",
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
            "Monitor your improvements to stay\nmotivated and consistent.",
            style: GoogleFonts.roboto(
              fontSize: 12,
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 75,
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
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 82, vertical: 6),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Get Started"),
          ),
        ),
      ],
    );
  }
}
