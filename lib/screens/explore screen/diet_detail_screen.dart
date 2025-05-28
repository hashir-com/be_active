import 'package:flutter/material.dart';
import 'package:thryv/models/diet_model.dart';

class DietDetailScreen extends StatelessWidget {
  final DietPlan diet;

  const DietDetailScreen({super.key, required this.diet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(diet.dietName ?? 'Diet Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${diet.dietName ?? ''}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Servings: ${diet.servings ?? 0}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Calories: ${diet.calorie ?? 0}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
