import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/screens/home/navigation_screen.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({super.key, required this.gender});
  final String gender;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
            screenHeight,
          ),
          _buildTextField(
            _ageController,
            "Age",
            "Enter your Age",
            Icons.calendar_today,
            screenWidth,
            screenHeight,
            isNumeric: true,
          ),
          _buildTextField(
            _heightController,
            "Height",
            "Enter your Height",
            Icons.height,
            screenWidth,
            screenHeight,
            isNumeric: true,
          ),
          _buildTextField(
            _weightController,
            "Weight",
            "Enter your Weight",
            Icons.fitness_center,
            screenWidth,
            screenHeight,
            isNumeric: true,
          ),
          const SizedBox(height: 30),
          _buildContinueButton(screenWidth, screenHeight),
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
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
            final parsedValue = value.replaceAll(',', '.');
            if (label == "Age") {
              final age = int.tryParse(parsedValue);
              if (age == null || age < 12 || age > 120) {
                return 'Age must be between 12 and 120';
              }
            } else if (label == "Height") {
              final height = double.tryParse(parsedValue);
              if (height == null || height < 50 || height > 300) {
                return 'Height must be between 50 and 300 cm';
              }
            } else if (label == "Weight") {
              final weight = double.tryParse(parsedValue);
              if (weight == null || weight < 20 || weight > 500) {
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
      width: 260.w,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF040B90),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (widget.gender == 'male' || widget.gender == 'female') {
              final user = UserModel(
                name: _nameController.text.trim(),
                gender: widget.gender,
                age: int.parse(_ageController.text.trim()),
                height: double.parse(
                  _heightController.text.trim().replaceAll(",", "."),
                ),
                weight: double.parse(
                  _weightController.text.trim().replaceAll(",", "."),
                ),
              );

              await HiveService().saveUser(user);

              // ignore: use_build_context_synchronously
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
