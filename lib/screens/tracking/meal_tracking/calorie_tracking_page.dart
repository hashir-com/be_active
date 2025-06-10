// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/screens/tracking/meal_tracking/nutrition_details.dart';
import 'package:thryv/util/progress_utils.dart';
import '../../../models/food_model.dart/food_item.dart';
import 'foodsearch.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/util/image_utility.dart';
import 'package:thryv/models/user_goal_model.dart';

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
  DateTime selectedDate = DateTime.now();

  UserModel? user;
  UserGoalModel? usergoal;
  Map<MealType, List<FoodItem>> meals = {
    MealType.breakfast: [],
    MealType.morningSnack: [],
    MealType.lunch: [],
    MealType.eveningTea: [],
    MealType.dinner: [],
  };

  num totalCalorieGoal = 1750;

  final Map<MealType, int> calorieGoals = {
    MealType.breakfast: 438,
    MealType.morningSnack: 219,
    MealType.lunch: 438,
    MealType.eveningTea: 219,
    MealType.dinner: 438,
  };

  final Map<MealType, double> mealDistribution = {
    MealType.breakfast: 0.25,
    MealType.morningSnack: 0.125,
    MealType.lunch: 0.25,
    MealType.eveningTea: 0.125,
    MealType.dinner: 0.25,
  };

  @override
  void initState() {
    super.initState();

    final userBox = Hive.box<UserModel>('userBox');
    final userGoalBox = Hive.box<UserGoalModel>('userGoalBox');
    user = userBox.get('user');
    usergoal = userGoalBox.get('usergoal');

    if (user?.bmi != null && usergoal?.goal != null) {
      totalCalorieGoal = suggestInitialCalorieGoal(user!.bmi!, usergoal!.goal!);
    } else {
      totalCalorieGoal = 1750;
    }

    _applyMealCalorieGoals();
    _loadSavedMeals();
  }

  void _applyMealCalorieGoals() {
    calorieGoals.updateAll((meal, _) {
      final percentage = mealDistribution[meal]!;
      return (totalCalorieGoal * percentage).round();
    });
  }

  void _onGoalCompleted() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Goal Achieved! 🎉'),
            content: const Text('You have reached your daily calorie goal!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nice!'),
              ),
            ],
          ),
    );
  }

  void _loadSavedMeals() async {
    final box = Hive.box<FoodItem>('foodBox');
    final allItems = box.values.toList();

    for (var meal in meals.keys) {
      meals[meal]!.clear();
    }

    for (var item in allItems) {
      final meal = _stringToMealType(item.mealType);
      if (meal != null && isSameDate(item.date, selectedDate)) {
        meals[meal]!.add(item);
      }
    }

    final total = meals.values
        .expand((e) => e)
        .fold(0, (sum, item) => sum + item.calories.toInt());

    if (total >= totalCalorieGoal) {
      Future.delayed(
        Duration.zero,
        _onGoalCompleted,
      ); // ⚠️ avoid setState during build

      await updateDailyProgress(date: DateTime.now(), type: 'food');
    }

    setState(() {});
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
      MaterialPageRoute(
        builder:
            (_) => FoodSearchPage(
              mealType: meal,
              selectedDate: selectedDate, // ✅ pass selected date
            ),
      ),
    );
    _loadSavedMeals(); // reload to reflect new items
  }

  void _showEditGoalDialog(MealType selectedMeal) {
    final controller = TextEditingController(
      text: calorieGoals[selectedMeal]!.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Calorie Goal for ${mealTypeToString(selectedMeal)}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter goal in Calories',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newGoal = int.tryParse(controller.text);
                if (newGoal == null || newGoal <= 0) {
                  Navigator.pop(context);
                  return;
                }

                setState(() {
                  final totalOldGoal = calorieGoals.values.reduce(
                    (a, b) => a + b,
                  );
                  final otherMeals =
                      calorieGoals.keys
                          .where((m) => m != selectedMeal)
                          .toList();

                  // Update selected meal goal
                  calorieGoals[selectedMeal] = newGoal;

                  final otherMealDistributionSum = otherMeals
                      .map((m) => mealDistribution[m]!)
                      .reduce((a, b) => a + b);

                  for (var meal in otherMeals) {
                    final ratio =
                        mealDistribution[meal]! / otherMealDistributionSum;
                    final newMealGoal =
                        ((totalOldGoal - newGoal) * ratio).round();
                    calorieGoals[meal] = newMealGoal;
                  }

                  totalCalorieGoal = calorieGoals.values.reduce(
                    (a, b) => a + b,
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTotalGoalDialog() {
    final controller = TextEditingController(text: totalCalorieGoal.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Daily Calorie Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter your calorie goal',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final input = int.tryParse(controller.text);
                if (input != null && input > 0) {
                  setState(() {
                    totalCalorieGoal = input;
                    _applyMealCalorieGoals();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  int get totalCalories => meals.values
      .expand((e) => e)
      .fold(0, (sum, item) => sum + item.calories.toInt());
  String dropdownValue = "Today"; // Default dropdown value

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(
                    context,
                  ).primaryColor, // Border color matching primary to effectively hide it
            ),
          ),
          child: DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: Theme.of(context).primaryColor,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
            ),
            borderRadius: BorderRadius.circular(50),
            items: [
              DropdownMenuItem(
                value: "Today",
                child: Text("Today", style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: "Yesterday",
                child: Text("Yesterday", style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: "Pick Date",
                child: Text("Pick Date", style: TextStyle(color: Colors.white)),
              ),
            ],
            onChanged: (value) async {
              if (value == "Today") {
                setState(() {
                  dropdownValue = "Today";
                  selectedDate = DateTime.now();
                  _loadSavedMeals();
                });
              } else if (value == "Yesterday") {
                setState(() {
                  dropdownValue = "Yesterday";
                  selectedDate = DateTime.now().subtract(
                    const Duration(days: 1),
                  );
                  _loadSavedMeals();
                });
              } else if (value == "Pick Date") {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary:
                              Theme.of(
                                context,
                              ).colorScheme.primary, // header background color
                          onPrimary:
                              Theme.of(
                                context,
                              ).primaryColor, // header text color
                          onSurface:
                              Theme.of(
                                context,
                              ).colorScheme.onSurface, // body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                Theme.of(
                                  context,
                                ).colorScheme.primary, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    dropdownValue = "Pick Date";
                    _loadSavedMeals();
                  });
                } else {
                  // User canceled, keep previous dropdownValue
                }
              }
            },
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Selected Date: ${DateFormat.yMMMMd().format(selectedDate)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).shadowColor.withOpacity(0.12),
                  blurRadius: 6,
                ),
              ],
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
                        value: totalCalories / totalCalorieGoal,
                        strokeWidth: 5,
                        backgroundColor:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          theme.primaryColorDark,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.local_dining,
                      size: 24,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(
                      '$totalCalories of $totalCalorieGoal Cal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showEditTotalGoalDialog,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.bar_chart,
                  color: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Meals list
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$calories of $goal Cal',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => _showEditGoalDialog(meal),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () => _addFood(meal),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.42),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        foods.isEmpty
                            ? [
                              GestureDetector(
                                onTap: () => _addFood(meal),
                                child: _buildEmptyText(meal),
                              ),
                            ]
                            : [
                              ...foods.map(
                                (food) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => NutritionDetailsPage(
                                                      foodName: food.name,
                                                      calories: food.calories,
                                                      protein: food.protein,
                                                      fat: food.fat,
                                                      carbs: food.carbs,
                                                      fiber: food.fiber,
                                                      foodItems: [],
                                                      mealType: '',
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            food.name,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${food.calories.toStringAsFixed(1)} Cal',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            17,
                                            0,
                                          ),
                                        ),
                                        onPressed: () {
                                          Hive.box<FoodItem>(
                                            'foodBox',
                                          ).delete(food.key);
                                          _loadSavedMeals();
                                        },
                                      ),
                                    ],
                                  ),
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
    return Text(
      'Add Your Food for ${mealTypeToString(meal)} to Track your Calorie intake🔥😋',
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}
