import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/food_item.dart';
import 'foodsearch.dart';

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
      return 'Evening Tea';
    case MealType.dinner:
      return 'Dinner';
  }
}

// ✅ use this for saving to Hive
String mealTypeToKey(MealType meal) {
  return meal.toString().split('.').last; // breakfast, morningSnack, etc.
}

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

  @override
  void initState() {
    super.initState();
    _loadSavedMeals();
  }

  void _loadSavedMeals() {
    final box = Hive.box<FoodItem>('foodBox');
    final allItems = box.values.toList();

    // Clear previous lists to avoid duplicates on reload
    meals.forEach((key, value) => value.clear());

    for (var item in allItems) {
      MealType? type = _stringToMealType(item.mealType);
      if (type != null) {
        meals[type]?.add(item);
      }
    }

    setState(() {}); // Refresh UI
  }

  MealType? _stringToMealType(String type) {
    switch (type.toLowerCase()) {
      // ✅ make lowercase before comparing
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
      MaterialPageRoute(builder: (context) => FoodSearchPage(mealType: meal)),
    );
    _loadSavedMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track Your Meals')),
      body: ListView(
        children:
            MealType.values.map((meal) {
              final foodList = meals[meal]!;
              int totalCalories = foodList.fold(
                0,
                (sum, item) => sum + item.calories.toInt(),
              );

              return Card(
                margin: EdgeInsets.all(30),
                child: ExpansionTile(
                  title: Text(
                    '${mealTypeToString(meal)} - $totalCalories kcal',
                  ),
                  children: [
                    ...foodList.map(
                      (food) => ListTile(
                        title: Text(food.name),
                        trailing: Text('${food.calories} kcal'),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _addFood(meal),
                      icon: Icon(Icons.add),
                      label: Text('Add Food'),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
