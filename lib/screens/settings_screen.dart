import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFE6E7FF),
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.12),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            padding: EdgeInsets.only(top: height * 0.02, left: width * 0.07),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: GoogleFonts.righteous(
                    fontSize: width * 0.1,
                    color: const Color(0xFF040B90),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
