import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(
            "thryv is a Health tracking app helps users to track their habits and make changes to lead a better lifestyle",
          ),
        ),
      ),
    );
  }
}

class Appversion extends StatelessWidget {
  const Appversion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text("         thryv \nVersion : v1.0.0.0"),
        ),
      ),
    );
  }
}

class Liscence extends StatelessWidget {
  const Liscence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text("thryv is Lisenced!"),
        ),
      ),
    );
  }
}
