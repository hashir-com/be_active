import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late Box<UserModel> userBox;
  UserModel? user;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  String? selectedGender;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box<UserModel>('userBox');
    user = userBox.isNotEmpty ? userBox.getAt(0) : null;

    nameController = TextEditingController(text: user?.name ?? '');
    ageController = TextEditingController(text: user?.age.toString() ?? '');
    heightController = TextEditingController(
      text: user?.height.toString() ?? '',
    );
    weightController = TextEditingController(
      text: user?.weight.toString() ?? '',
    );

    final storedGender = user?.gender.toLowerCase();
    if (storedGender == 'male') {
      selectedGender = 'Male';
    } else if (storedGender == 'female') {
      selectedGender = 'Female';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = UserModel(
        name: nameController.text,
        age: int.parse(ageController.text),
        gender: selectedGender ?? '',
        height: double.parse(heightController.text),
        weight: double.parse(weightController.text),
        goalIndex: user?.goalIndex,
        workoutPlan: user?.workoutPlan,
        dietPlan: user?.dietPlan,
        bmi: user?.bmi,
      );

      if (userBox.isEmpty) {
        await userBox.add(updatedUser);
      } else {
        user = userBox.getAt(0);
        user!
          ..name = updatedUser.name
          ..age = updatedUser.age
          ..gender = updatedUser.gender
          ..height = updatedUser.height
          ..weight = updatedUser.weight;
        await user!.save();
      }

      setState(() {
        user = updatedUser;
      });

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('User details updated')));
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.15),
        child: Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(top: height * 0.02, left: width * 0.07),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  "Account Details",
                  style: GoogleFonts.roboto(
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 184, 79, 255), Color(0xFF040B90)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: size.width < 500 ? double.infinity : 500,
              margin: const EdgeInsets.all(26),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      label: 'Name',
                      controller: nameController,
                      icon: Icons.person,
                      validator:
                          (val) =>
                              val == null || val.isEmpty
                                  ? 'Enter your name'
                                  : null,
                    ),
                    _buildTextField(
                      label: 'Age',
                      controller: ageController,
                      icon: Icons.cake,
                      inputType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter your age';
                        final age = int.tryParse(val);
                        if (age == null || age <= 0) return 'Enter a valid age';
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField2<String>(
                        value: selectedGender,
                        isExpanded: true,
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Select gender'
                                    : null,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                        ),

                        items:
                            ['Male', 'Female']
                                .map(
                                  (gender) => DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),
                    _buildTextField(
                      label: 'Height (cm)',
                      controller: heightController,
                      icon: Icons.height,
                      inputType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter height';
                        final h = double.tryParse(val);
                        if (h == null || h <= 0) return 'Enter a valid height';
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Weight (kg)',
                      controller: weightController,
                      icon: Icons.monitor_weight,
                      inputType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter weight';
                        final w = double.tryParse(val);
                        if (w == null || w <= 0) return 'Enter a valid weight';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
