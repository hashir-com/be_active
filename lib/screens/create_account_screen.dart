import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'package:be_active/services/hive_service.dart';
import 'package:be_active/models/user_model.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF040B90),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: Container(
          color: const Color(0xFF040B90),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03),
              child: Text(
                "Create Account",
                style: GoogleFonts.righteous(
                  fontSize: screenWidth * 0.08,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.85,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 237, 255),
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
                      _buildForm(screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
            const Color.fromARGB(255, 255, 0, 217),
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
                  : const Color.fromARGB(255, 202, 202, 202),
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

  Widget _buildForm(double screenWidth) {
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
          ),
          _buildTextField(
            _ageController,
            "Age",
            "Enter your Age",
            Icons.calendar_today,
            screenWidth,
            isNumeric: true,
          ),
          _buildTextField(
            _heightController,
            "Height",
            "Enter your Height",
            Icons.height,
            screenWidth,
            isNumeric: true,
          ),
          _buildTextField(
            _weightController,
            "Weight",
            "Enter your Weight",
            Icons.fitness_center,
            screenWidth,
            isNumeric: true,
          ),
          const SizedBox(height: 30),
          _buildContinueButton(screenWidth),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    double screenWidth, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: 10,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color.fromARGB(0, 229, 231, 255),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          if (isNumeric && double.tryParse(value) == null) {
            return 'Please enter a valid number for $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildContinueButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.6,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF040B90),
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (gender == 'male' || gender == 'female') {
              final user = UserModel(
                name: _nameController.text.trim(),
                gender: gender,
                age: int.parse(_ageController.text.trim()),
                height: double.parse(_heightController.text.trim()),
                weight: double.parse(_weightController.text.trim()),
              );

              await HiveService().saveUser(user);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select your gender.')),
              );
            }
          }
        },
        child: Text('Continue', style: GoogleFonts.righteous(fontSize: 18)),
      ),
    );
  }
}
