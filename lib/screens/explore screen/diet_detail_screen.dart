import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';

class DietDetailScreen extends StatelessWidget {
  final DietPlan diet;

  const DietDetailScreen({super.key, required this.diet, required int index});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(diet.mealType ?? 'Diet Detail'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 4, 144, 41),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(46),
              ),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (diet.dietImageBytes != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(46),
                        child: Image.memory(
                          diet.dietImageBytes!,
                          height: 200,
                          width: double.infinity,
                          fit: isWide ? BoxFit.fitHeight : BoxFit.fill,
                          errorBuilder:
                              (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 60),
                        ),
                      ),
                    SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.fastfood,
                      'Diet Name',
                      diet.dietName ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.restaurant_menu,
                      'Servings',
                      '${diet.servings ?? 0}',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.local_fire_department,
                      'Calories',
                      '${diet.calorie ?? 0} kcal',
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

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green.shade800, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
