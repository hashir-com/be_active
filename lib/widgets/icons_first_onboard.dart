import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FirstPageIcons extends StatelessWidget {
  const FirstPageIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        children: [
          Positioned(
            top: 150,
            left: 10,
            child: Lottie.asset('assets/sleep.json', width: 70, height: 70),
          ),
          Positioned(
            top: 23,
            left: 10,
            child: Lottie.asset('assets/running.json', width: 300, height: 300),
          ),
          Positioned(
            top: -10,
            left: 10,
            child: Lottie.asset('assets/food.json', width: 100, height: 100),
          ),
          Positioned(
            top: 0,
            right: 30,
            child: Lottie.asset('assets/water.json', width: 100, height: 100),
          ),
          Positioned(
            top: 180,
            right: 10,
            child: Lottie.asset('assets/weight.json', width: 60, height: 60),
          ),
        ],
      ),
    );
  }
}
