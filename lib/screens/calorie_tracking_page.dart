import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/food_item.dart';
import 'foodsearch.dart';
import 'nutrient_screen.dart';

enum MealType { breakfast, morningSnack, lunch, eveningTea, dinner }

String mealTypeToString(MealType meal) {
  switch (meal) {
    case MealType.breakfast:
      return 'Breakfast';
    case MealType.morningSnack:
      return 'Morning Snack';
    case MealType.lunch:
      return 'Lunch';
    case MealType.eveningTea:
      return 'Evening Snack';
    case MealType.dinner:
      return 'Dinner';
  }
}

String mealTypeToKey(MealType meal) => meal.toString().split('.').last;

class MealTrackerPage extends StatefulWidget {
  const MealTrackerPage({super.key});
  @override
  MealTrackerPageState createState() => MealTrackerPageState();
}

class MealTrackerPageState extends State<MealTrackerPage> {
  Map<MealType, List<FoodItem>> meals = {
    MealType.breakfast: [],
    MealType.morningSnack: [],
    MealType.lunch: [],
    MealType.eveningTea: [],
    MealType.dinner: [],
  };

  final calorieGoals = {
    MealType.breakfast: 438,
    MealType.morningSnack: 219,
    MealType.lunch: 438,
    MealType.eveningTea: 219,
    MealType.dinner: 438,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedMeals();
  }

  void _loadSavedMeals() {
    final box = Hive.box<FoodItem>('foodBox');
    final allItems = box.values.toList();
    meals.forEach((key, value) => value.clear());

    for (var item in allItems) {
      final meal = _stringToMealType(item.mealType);
      if (meal != null) {
        meals[meal]!.add(item);
      }
    }
    setState(() {});
  }

  MealType? _stringToMealType(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return MealType.breakfast;
      case 'morningsnack':
        return MealType.morningSnack;
      case 'lunch':
        return MealType.lunch;
      case 'eveningtea':
        return MealType.eveningTea;
      case 'dinner':
        return MealType.dinner;
      default:
        return null;
    }
  }

  void _addFood(MealType meal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FoodSearchPage(mealType: meal)),
    );
    _loadSavedMeals();
  }

  int get totalCalories => meals.values
      .expand((e) => e)
      .fold(0, (sum, item) => sum + item.calories.toInt());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Today",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.settings, size: 24),
          SizedBox(width: 12),
          Icon(Icons.more_vert, size: 24),
          SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: CircularProgressIndicator(
                        value: totalCalories / 1750,
                        strokeWidth: 5,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation(Colors.orange),
                      ),
                    ),
                    const Icon(Icons.local_dining, size: 24),
                  ],
                ),
                const SizedBox(width: 16),
                Text(
                  '$totalCalories of 1750 Cal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.bar_chart, color: Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ...MealType.values.map((meal) {
            final foods = meals[meal]!;
            final calories = foods.fold(
              0,
              (sum, f) => sum + f.calories.toInt(),
            );
            final goal = calorieGoals[meal]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      mealTypeToString(meal),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$calories of $goal Cal',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.orange),
                      onPressed: () => _addFood(meal),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        foods.isEmpty
                            ? [_buildEmptyText(meal)]
                            : [
                              ...foods.map(
                                (food) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(food.name)),
                                      Text(
                                        '${food.calories.toStringAsFixed(1)} Cal',
                                      ),
                                      Text(
                                        "${food.protein.toStringAsFixed(1)} prot",
                                      ),
                                      Text(
                                        "${food.carbs.toStringAsFixed(1)} carb",
                                      ),
                                      Text(
                                        "${food.fat.toStringAsFixed(1)} fat",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Show Details"),
                                    Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                              ),
                            ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyText(MealType meal) {
    switch (meal) {
      case MealType.breakfast:
        return const Text("Add something to your breakfast 🍳");
      case MealType.morningSnack:
        return const Text("Get energized by grabbing a morning snack 🥜");
      case MealType.lunch:
        return const Text("Don't miss lunch 🍱 It's time to get a tasty meal");
      case MealType.eveningTea:
        return const Text(
          "Hey, here are some Healthy Snack Suggestions for you",
        );
      case MealType.dinner:
        return const Text("An early dinner can help you sleep better 🍽😴");
    }
  }
}
