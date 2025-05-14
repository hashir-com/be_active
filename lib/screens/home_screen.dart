import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final dynamic sex;
  final String age;
  final String height;
  final String weight;
  const HomeScreen({
    super.key,
    required this.name,
    required this.sex,
    required this.height,
    required this.weight,
    required this.age,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double bmi;

  @override
  void initState() {
    super.initState();
    int he = int.parse(widget.height);
    int we = int.parse(widget.weight);

    bmi = we / (he / 100 * he / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Container(
          color: const Color(0xFF000DFF),
          child: Padding(
            padding: const EdgeInsets.only(top: 130.0, left: 120),
            child: Text(
              "Hi,${widget.name}",
              style: GoogleFonts.righteous(fontSize: 38, color: Colors.white),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text("Name ${widget.name},  Sex ${widget.sex},bmi = $bmi"),
      ),
    );
  }
}
