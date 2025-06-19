import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../home/home_screen.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:thryv/models/user_model.dart';
import '../home/navigation_screen.dart';
import 'package:thryv/screens/auth/widgets/gender_selection_widget.dart';
import 'package:thryv/screens/auth/widgets/form_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<CreateAccountScreen> {
  String selectedGender = '';
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.15),
            child: Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                  child: Text(
                    "Create Account",
                    style: GoogleFonts.righteous(
                      fontSize: 38.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.85,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      GenderSelection(
                        selectedGender: selectedGender,
                        onGenderSelected: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      FormWidget(gender: selectedGender),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
