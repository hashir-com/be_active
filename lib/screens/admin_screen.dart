import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart'; // Adjust path
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'package:Thryv/services/hive_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final HiveService _hiveService = HiveService(); // Use HiveService

  UserModel? user;

  final _workoutController = TextEditingController();
  final _dietController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _hiveService.getUser(); // Use HiveService to get user

    if (user != null) {
      _workoutController.text = user!.workoutPlan ?? '';
      _dietController.text = user!.dietPlan ?? '';
    }
  }

  void _savePlans() {
    if (user == null) return;

    user!.workoutPlan = _workoutController.text;
    user!.dietPlan = _dietController.text;
    user!.save();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Plans saved successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (user == null) {
      // Show fallback UI if no user found
      return Scaffold(
        appBar: AppBar(title: const Text("Admin Panel")),
        body: Center(
          child: Text('No user found', style: theme.textTheme.headlineMedium),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("User Info", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              _infoRow("Name", user!.name),
              _infoRow("Age", user!.age.toString()),
              _infoRow("Gender", user!.gender),
              _infoRow("BMI", user!.bmi?.toStringAsFixed(1) ?? 'N/A'),
              _infoRow(
                "Goal",
                userGoalToString(user!.goal ?? UserGoal.weightLoss),
              ),
              const SizedBox(height: 24),
              Text("Workout Plan", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _workoutController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter workout suggestions...",
                ),
              ),
              const SizedBox(height: 24),
              Text("Diet Plan", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _dietController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter diet plan...",
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: const Color(0xFF040B90),
                  ),
                  onPressed: () {
                    _savePlans();
                    // Navigator.pop(context);
                  },
                  child: Text(
                    "Save Suggestions",
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
