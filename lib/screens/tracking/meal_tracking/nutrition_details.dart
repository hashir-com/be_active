import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thryv/models/food_model.dart/food_item.dart';

class NutritionDetailsPage extends StatelessWidget {
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final List<FoodItem> foodItems;
  final String mealType;

  const NutritionDetailsPage({
    super.key,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.foodItems,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.2),
        child: Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(
            top: size.height * 0.07,
            left: isLargeScreen ? 60 : size.width * 0.05,
            right: isLargeScreen ? 60 : size.width * 0.05,
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  foodName,
                  style: GoogleFonts.righteous(
                    fontSize: isLargeScreen ? 32 : size.width * 0.06,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Nutritional Details.",
                style: GoogleFonts.roboto(
                  fontSize: isLargeScreen ? 18 : size.width * 0.035,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final padding = EdgeInsets.symmetric(
            horizontal: isWide ? 80 : 16,
            vertical: 24,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildNutritionCard(
                        'Calories',
                        calories,
                        Icons.local_fire_department,
                        Colors.orange,
                        isWide,
                      ),
                      _buildNutritionCard(
                        'Protein',
                        protein,
                        Icons.fitness_center,
                        Colors.blue,
                        isWide,
                      ),
                      _buildNutritionCard(
                        'Fat',
                        fat,
                        Icons.oil_barrel,
                        Colors.red,
                        isWide,
                      ),
                      _buildNutritionCard(
                        'Carbs',
                        carbs,
                        Icons.bubble_chart,
                        Colors.green,
                        isWide,
                      ),
                      _buildNutritionCard(
                        'Fiber',
                        fiber,
                        Icons.grass,
                        Colors.purple,
                        isWide,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: isLargeScreen ? 300 : double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontSize: isLargeScreen ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColorLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNutritionCard(
    String label,
    double value,
    IconData icon,
    Color color,
    bool isWide,
  ) {
    return SizedBox(
      width: isWide ? 300 : double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
