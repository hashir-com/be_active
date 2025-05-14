import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 260,
          right: 130,
          child: Container(
            width: 40,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.line_weight_rounded,
              color: const Color.fromARGB(255, 13, 27, 133),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: 90,
          child: Container(
            width: 40,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.height_rounded,
              color: const Color.fromARGB(255, 255, 12, 190),
            ),
          ),
        ),
        Positioned(
          top: 250,
          left: 80,
          child: Container(
            width: 40,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.directions_walk_rounded),
          ),
        ),
        Positioned(
          top: 180,
          left: 185,
          child: Container(
            width: 40,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.self_improvement_sharp,
              color: Colors.purpleAccent,
            ),
          ),
        ),
        Positioned(
          top: 305,
          left: 140,
          child: Container(
            width: 40,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.sunny,
              color: const Color.fromARGB(255, 255, 163, 3),
            ),
          ),
        ),
        Positioned(
          top: 55,
          right: -14,
          child: SizedBox(
            height: 130,
            width: 130,
            child: Lottie.asset("assets/goal.json"),
          ),
        ),
        Positioned(
          top: 325,
          left: 10,
          child: SizedBox(
            height: 90,
            width: 80,
            child: Lottie.asset("assets/start.json"),
          ),
        ),
      ],
    );
  }
}
