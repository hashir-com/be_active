import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/food_item.dart';
import 'foodsearch.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/util/calorie_screen_utils.dart';
import 'nutrition_details.dart';

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
    user = userBox.get('user');

    if (user != null && user!.bmi != null && user!.goal != null) {
      totalCalorieGoal = suggestInitialCalorieGoal(user!.bmi!, user!.goal!);
    } else {
      totalCalorieGoal = 1750; // Default if no data available
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

  void _loadSavedMeals() {
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
      MaterialPageRoute(builder: (_) => FoodSearchPage(mealType: meal)),
    );
    _loadSavedMeals();
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

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pickedDate = DateTime(date.year, date.month, date.day);

    if (pickedDate == today) return "Today";
    if (pickedDate == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    }

    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  int get totalCalories => meals.values
      .expand((e) => e)
      .fold(0, (sum, item) => sum + item.calories.toInt());
  String dropdownValue = "Today"; // Default dropdown value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color:
                Theme.of(
                  context,
                ).primaryColor, // background color of dropdown button
            borderRadius: BorderRadius.circular(
              12,
            ), // rounded corners on button
            border: Border.all(
              color: const Color.fromARGB(0, 255, 255, 255),
            ), // white border (optional)
          ),
          child: DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: Theme.of(context).primaryColor,
            // background color of dropdown menu (popup)
            underline: const SizedBox(), // remove underline
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: const TextStyle(color: Colors.white, fontSize: 20),
            borderRadius: BorderRadius.circular(50),
            items: const [
              DropdownMenuItem(value: "Today", child: Text("Today")),
              DropdownMenuItem(value: "Yesterday", child: Text("Yesterday")),
              DropdownMenuItem(value: "Pick Date", child: Text("Pick Date")),
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
          Text(DateFormat.yMMMMd().format(selectedDate)),
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
                        value: totalCalories / totalCalorieGoal,
                        strokeWidth: 5,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF020770),
                        ),
                      ),
                    ),
                    const Icon(Icons.local_dining, size: 24),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(
                      '$totalCalories of $totalCalorieGoal Cal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showEditTotalGoalDialog,
                      child: const Icon(Icons.edit, size: 20),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.bar_chart, color: Color(0xFF020770)),
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
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _showEditGoalDialog(meal),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF020770),
                      ),
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
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Text(food.name),
                                        ),
                                      ),
                                      Text(
                                        '${food.calories.toStringAsFixed(1)} Cal',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.redAccent,
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
      'No items added for ${mealTypeToString(meal)}.',
      style: const TextStyle(color: Colors.grey),
    );
  }
}
