import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:thryv/models/user_model.dart';
import 'navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String gender = '';
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                      fontSize: screenWidth * 0.09,
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
                      _buildGenderSelection(screenWidth),
                      SizedBox(height: screenHeight * 0.03),
                      _buildForm(screenWidth, screenHeight),
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

  Widget _buildGenderSelection(double screenWidth) {
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
    String genderLabel,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = genderType;
        });
      },
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          color:
              gender == genderType
                  ? color
                  : const Color.fromARGB(255, 255, 255, 255),
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
                genderLabel,
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

  Widget _buildForm(double screenWidth, double screenHieght) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            _nameController,
            "Name",
            "Enter your Name",
            Icons.person,
            screenWidth,
            screenHieght,
          ),
          _buildTextField(
            _ageController,
            "Age",
            "Enter your Age",
            Icons.calendar_today,
            screenWidth,
            screenHieght,
            isNumeric: true,
          ),
          _buildTextField(
            _heightController,
            "Height",
            "Enter your Height",
            Icons.height,
            screenWidth,
            screenHieght,
            isNumeric: true,
          ),
          _buildTextField(
            _weightController,
            "Weight",
            "Enter your Weight",
            Icons.fitness_center,
            screenWidth,
            screenHieght,
            isNumeric: true,
          ),
          const SizedBox(height: 30),
          _buildContinueButton(screenWidth, screenHieght),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    double screenWidth,
    double screenHeight, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: screenHeight * 0.015,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          errorStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 0, 0),
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your $label';
          }

          if (isNumeric) {
            if (label == "Age") {
              final age = int.tryParse(value);
              if (age == null) return 'Please enter a valid number for Age';
              if (age < 12 || age > 120) {
                return 'Age must be between 12 and 120';
              }
            }
            String formattedValue = value.replaceAll(',', '.');

            if (label == "Height") {
              final height = double.tryParse(formattedValue);
              if (height == null) {
                return 'Please enter a valid number for Height';
              }
              if (height < 50 || height > 300) {
                return 'Height must be between 50 and 300 cm';
              }
            }

            if (label == "Weight") {
              final weight = double.tryParse(formattedValue);
              if (weight == null) {
                return 'Please enter a valid number for Weight';
              }
              if (weight < 20 || weight > 500) {
                return 'Weight must be between 20 and 500 kg';
              }
            }
          }

          return null;
        },
      ),
    );
  }

  Widget _buildContinueButton(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * 0.6,
      height: screenHeight * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: const Color(0xFF040B90),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (gender == 'male' || gender == 'female') {
              final user = UserModel(
                name: _nameController.text.trim(),
                gender: gender,
                age: int.parse(_ageController.text.trim()),
                height: double.parse(
                  _heightController.text.trim().replaceAll(",", "."),
                ),
                weight: double.parse(
                  _weightController.text.trim().replaceAll(",", "."),
                ),
              );

              await HiveService().saveUser(user);

              Navigator.pushAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationScreen(),
                ),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select your gender.')),
              );
            }
          }
        },
        child: Text('Continue', style: GoogleFonts.righteous(fontSize: 20)),
      ),
    );
  }
}
