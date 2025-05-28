import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'first_onboard.dart';
import 'second_onboard.dart';
import '../auth/create_account_screen.dart';

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
          PageView.builder(
            controller: _controller,
            itemCount: 2,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return const FirstOnboardingPage();
              } else {
                return const SecondOnboardingPage();
              }
            },
          ),

          // Skip button on first page
          if (currentPage == 0)
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          // Page Indicator
          Positioned(
            bottom: 90,
            left: 30,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect: WormEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white24,
                  dotHeight: 15,
                  dotWidth: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
