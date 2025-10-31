import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/screens/home/navigation_screen.dart';

class GenderSelection extends StatefulWidget {
  final dynamic selectedGender;

  final dynamic onGenderSelected;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  State<GenderSelection> createState() => _AuthWidgetsState();
}

class _AuthWidgetsState extends State<GenderSelection> {
  String gender = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGenderOption(
            "male",
            Icons.male,
            "Male",
            const Color(0xFF040B90),
          ),
          _buildGenderOption(
            "female",
            Icons.female,
            "Female",
            const Color.fromARGB(255, 255, 0, 234),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    String genderType,
    IconData icon,
    String label,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = genderType;
        });
        widget.onGenderSelected(genderType);
      },
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          color: gender == genderType ? color : Colors.white,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 40,
              child: Icon(
                icon,
                size: 40,
                color: gender == genderType ? Colors.white : Colors.black,
              ),
            ),
            Positioned(
              bottom: 6,
              left: 45,
              child: Text(
                label,
                style: GoogleFonts.aBeeZee(
                  fontSize: 12,
                  color: gender == genderType ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
