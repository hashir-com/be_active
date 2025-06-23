// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/screens/tracking/meal_tracking/foodgraph.dart';
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

class MealTrackerPageState extends State<MealTrackerPage>
    with WidgetsBindingObserver {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = "Today";

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
    WidgetsBinding.instance.addObserver(this);

    try {
      final userBox = Hive.box<UserModel>('userBox');
      final userGoalBox = Hive.box<UserGoalModel>('userGoalBox');
      user = userBox.get('user');
      usergoal = userGoalBox.get('usergoal');

      if (usergoal == null) {
        usergoal = UserGoalModel(goal: null);
        userGoalBox.put('usergoal', usergoal!);
      }

      totalCalorieGoal = usergoal!.totalCalorieGoal;
      usergoal!.mealCalorieGoals.forEach((key, value) {
        final meal = _stringToMealType(key);
        if (meal != null) calorieGoals[meal] = value;
      });
    } catch (e) {
      debugPrint("Hive error: $e");
    }

    _loadSavedMeals();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadSavedMeals();
    }
  }

  void _applyMealCalorieGoals() {
    calorieGoals.updateAll((meal, _) {
      final percentage = mealDistribution[meal]!;
      return (totalCalorieGoal * percentage).round();
    });

    usergoal?.totalCalorieGoal = totalCalorieGoal.toInt();
    usergoal?.mealCalorieGoals = {
      for (var entry in calorieGoals.entries)
        mealTypeToKey(entry.key): entry.value,
    };
    usergoal?.save();

    setState(() {});
  }

  void _onGoalCompleted() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
    try {
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

      final completed = total >= totalCalorieGoal;

      await updateDailyProgress(
        date: selectedDate,
        type: 'food',
        completed: completed,
      );

      if (completed) _onGoalCompleted();

      setState(() {});
    } catch (e, st) {
      debugPrint("Error loading meals: $e\n$st");
    }
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
            (_) => FoodSearchPage(mealType: meal, selectedDate: selectedDate),
      ),
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

                  calorieGoals[selectedMeal] = newGoal;

                  final otherMealDistributionSum = otherMeals
                      .map((m) => mealDistribution[m]!)
                      .reduce((a, b) => a + b);

                  for (var meal in otherMeals) {
                    final ratio =
                        mealDistribution[meal]! / otherMealDistributionSum;
                    calorieGoals[meal] =
                        ((totalOldGoal - newGoal) * ratio).round();
                  }

                  totalCalorieGoal = calorieGoals.values.reduce(
                    (a, b) => a + b,
                  );

                  _applyMealCalorieGoals();
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
                  totalCalorieGoal = input;
                  _applyMealCalorieGoals();
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

  Map<DateTime, double> _getLast7DaysCalories() {
    final now = DateTime.now();
    return Map.fromEntries(
      List.generate(7, (i) {
        final day = now.subtract(Duration(days: 6 - i));
        final total = meals.values
            .expand((list) => list)
            .where((f) => isSameDate(f.date, day))
            .fold(0.0, (s, f) => s + f.calories);
        return MapEntry(DateTime(day.year, day.month, day.day), total);
      }),
    );
  }

  Widget _buildEmptyText(MealType meal) {
    return Text(
      'Add Your Food for ${mealTypeToString(meal)} to Track your Calorie intake🔥😋',
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }

  String _getShortFoodName(String fullName) {
    final words = fullName.split(' ');
    if (words.length <= 5) return fullName;
    return '${words.sublist(0, 5).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.primaryColor),
          ),
          child: DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: theme.primaryColor,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20),
            borderRadius: BorderRadius.circular(50),
            items: const [
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
                      data: theme.copyWith(
                        colorScheme: theme.colorScheme.copyWith(
                          primary: theme.colorScheme.primary,
                          onPrimary: theme.primaryColor,
                          onSurface: theme.colorScheme.onSurface,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
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
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.12),
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
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          theme.primaryColorDark,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.local_dining,
                      size: 24,
                      color: theme.primaryColorDark,
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
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _showEditTotalGoalDialog,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => WeeklyCalorieChartScreen(
                              weeklyData: _getLast7DaysCalories(),
                              calorieGoal: totalCalorieGoal.toInt(),
                            ),
                      ),
                    );
                  },
                  child: Icon(Icons.bar_chart, color: theme.primaryColorDark),
                ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$calories of $goal Cal',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (calories > goal)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Over limit!',
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.edit,
                    //     size: 18,
                    //     color: theme.colorScheme.onSurface,
                    //   ),
                    //   onPressed: () => _showEditGoalDialog(meal),
                    // ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: theme.primaryColorDark,
                      ),
                      onPressed: () => _addFood(meal),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.42),
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
                                                      foodName:
                                                          _getShortFoodName(
                                                            food.name,
                                                          ),
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
                                            _getShortFoodName(food.name),
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${food.calories.toStringAsFixed(1)} Cal',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 20,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            17,
                                            0,
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text(
                                                    'Delete Food Item',
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete "${food.name}"?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Hive.box<FoodItem>(
                                                          'foodBox',
                                                        ).delete(food.key);
                                                        Navigator.pop(context);
                                                        _loadSavedMeals();
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
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
}
