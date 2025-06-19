import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../auth/create_account_screen.dart';
import 'package:thryv/widgets/linechart.dart';
import 'package:thryv/widgets/icons_second_onboard.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
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
        Padding(padding: EdgeInsets.only(top: 40), child: IconsPage()),

        Padding(
          padding: const EdgeInsets.only(
            top: 190.0,
            left: 50,
            right: 50,
            bottom: 300,
          ),
          child: const ProgressLineChart(),
        ),
        Positioned(
          bottom: 150,
          left: 30,
          child: Text(
            "Track\nYour Progress",
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
          bottom: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width / 2 - 135,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAccountScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 2, 15, 137),
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
