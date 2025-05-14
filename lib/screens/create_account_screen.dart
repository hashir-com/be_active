import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';

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
  final _box = Hive.box('userbox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000DFF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          color: const Color(0xFF000DFF),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                "Create Account",
                style: GoogleFonts.righteous(fontSize: 38, color: Colors.white),
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
              height: 780,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 237, 255),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ), // Spacing above the gender options
                    _buildGenderSelection(), // Gender selection widgets
                    const SizedBox(
                      height: 30,
                    ), // Spacing between gender and form fields
                    _buildForm(), // Form fields with validation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gender selection row
  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Male option
        _buildGenderOption(
          "male",
          Icons.male,
          "Male",
          const Color.fromARGB(255, 69, 62, 255),
        ),
        // Female option
        _buildGenderOption(
          "female",
          Icons.female,
          "Female",
          const Color.fromARGB(255, 247, 126, 235),
        ),
      ],
    );
  }

  // Builds each gender option container
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
                  fontSize: 12, // Reduced text size
                  color: gender == genderType ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form with input fields
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            _nameController,
            "Name",
            "Enter your Name",
            Icons.person,
          ),
          _buildTextField(
            _ageController,
            "Age",
            "Enter your Age",
            Icons.calendar_today,
          ),
          _buildTextField(
            _heightController,
            "Height",
            "Enter your Height",
            Icons.height,
          ),
          _buildTextField(
            _weightController,
            "Weight",
            "Enter your Weight",
            Icons.fitness_center,
          ),
          const SizedBox(height: 50), // Spacing before the button
          _buildContinueButton(), // Continue button
        ],
      ),
    );
  }

  // Creates the input fields for the form
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: TextFormField(
        controller: controller,
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
            return 'Please enter your $label'; // Error message
          }
          return null;
        },
      ),
    );
  }

  // Continue button widget
  Widget _buildContinueButton() {
    return SizedBox(
      width: 250, // Reduced button width
      height: 40, // Reduced button height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF040B90),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Save data to Hive
            _box.put('name', _nameController.text.trim());
            _box.put('age', _ageController.text.trim());
            _box.put('height', _heightController.text.trim());
            _box.put('weight', _weightController.text.trim());

            if (gender == "male" || gender == "female") {
              // Navigate to the home screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => HomeScreen(
                        name: _nameController.text.trim(),
                        sex: gender,
                        age: _ageController.text.trim(),
                        height: _heightController.text.trim(),
                        weight: _weightController.text.trim(),
                      ),
                ),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select your gender'),
                  backgroundColor: const Color.fromARGB(255, 167, 15, 4),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        child: Text('Continue', style: GoogleFonts.righteous(fontSize: 18)),
      ),
    );
  }
}
