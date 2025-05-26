import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:thryv/widgets/icons_first_onboard.dart';

class FirstOnboardingPage extends StatelessWidget {
  const FirstOnboardingPage({super.key});

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
              Padding(padding: EdgeInsets.all(1), child: FirstPageIcons()),
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
