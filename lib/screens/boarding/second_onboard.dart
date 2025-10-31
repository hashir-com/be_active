import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../auth/create_account_screen.dart';
import 'package:thryv/widgets/linechart.dart';
import 'package:thryv/widgets/icons_second_onboard.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Concentric circles decoration
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width / 2 - 145.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200.r,
                height: 200.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(67, 255, 255, 255),
                    width: 2.r,
                  ),
                ),
              ),
              Container(
                width: 300.r,
                height: 300.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(68, 255, 255, 255),
                    width: 2.r,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Animated icons at the top
        Padding(padding: EdgeInsets.only(top: 40.h), child: IconsPage()),

        // Line chart
        Padding(
          padding: EdgeInsets.only(
            top: 190.h,
            left: 50.w,
            right: 50.w,
            bottom: 300.h,
          ),
          child: const ProgressLineChart(),
        ),
        // Headline text
        Positioned(
          bottom: 150.h,
          left: 30.w,
          child: Text(
            "Track\nYour Progress",
            style: GoogleFonts.righteous(
              fontSize: 44.sp,
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
        // Subtitle text
        Positioned(
          bottom: 120.h,
          left: 30.w,
          child: Text(
            "Monitor your improvements to stay\nmotivated and consistent.",
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
        // Get Started button
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width / 2 - 135.w,
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
              padding: EdgeInsets.symmetric(horizontal: 82.w, vertical: 6.h),
              textStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: const Text("Get Started"),
          ),
        ),
      ],
    );
  }
}
