import 'package:flutter/material.dart';
import 'package:thryv/models/diet_model.dart';

class DietDetailScreen extends StatelessWidget {
  final DietPlan diet;

  const DietDetailScreen({super.key, required this.diet, required int index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diet.mealType ?? 'Diet Detail'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
