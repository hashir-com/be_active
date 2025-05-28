import 'package:flutter/material.dart';
import 'package:thryv/models/food_item.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionDetailsPage extends StatelessWidget {
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;

  const NutritionDetailsPage({
    super.key,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber, required List<FoodItem> foodItems, required String mealType,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.2),
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: height * 0.07, left: width * 0.05),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  foodName,
                  style: GoogleFonts.righteous(
                    fontSize: width * 0.08,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Nutritional Details.",
                style: GoogleFonts.roboto(
                  fontSize: width * 0.035,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNutritionCard(
                'Calories',
                calories,
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildNutritionCard(
                'Protein',
                protein,
                Icons.fitness_center,
                Colors.blue,
              ),
              _buildNutritionCard('Fat', fat, Icons.oil_barrel, Colors.red),
              _buildNutritionCard(
                'Carbs',
                carbs,
                Icons.bubble_chart,
                Colors.green,
              ),
              _buildNutritionCard('Fiber', fiber, Icons.grass, Colors.purple),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCard(
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
