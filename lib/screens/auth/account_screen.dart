// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:thryv/screens/auth/widgets/form_widget.dart';
import 'package:thryv/screens/auth/widgets/textfield_widget.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        context,
      ).showSnackBar(const SnackBar(content: Text('User details updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final isDesktop = width > 1000;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.only(top: 16.h, left: 24.w),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  "Account Details",
                  style: GoogleFonts.roboto(
                    fontSize: isDesktop ? 48 : 44,
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
            colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 1.sw < 500.w ? double.infinity : 500.w,
              margin: EdgeInsets.all(26.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(0, 164, 101, 101),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextfieldWidget(
                      label: 'Name',
                      controller: nameController,
                      icon: Icons.person,
                      validator:
                          (val) =>
                              val == null || val.trim().isEmpty
                                  ? 'Enter your name'
                                  : null,
                    ),
                    TextfieldWidget(
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
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: DropdownButtonFormField2<String>(
                        value: selectedGender,
                        isExpanded: true,
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Select gender'
                                    : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          labelText: 'Gender',
                          labelStyle: const TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 16.w,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        items:
                            ['Male', 'Female']
                                .map(
                                  (gender) => DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
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
                    TextfieldWidget(
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
                    TextfieldWidget(
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
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
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
