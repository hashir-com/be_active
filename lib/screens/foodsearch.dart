// ignore_for_file: library_private_types_in_public_api

import 'package:thryv/services/api%20services/search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/food_item.dart';
import '../screens/calorie_tracking_page.dart'; // If needed

class FoodSearchPage extends StatefulWidget {
  final MealType mealType;

  const FoodSearchPage({super.key, required this.mealType});

  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  void _showManualAddDialog() {
    final _nameController = TextEditingController();
    final _caloriesController = TextEditingController();
    final _proteinController = TextEditingController();
    final _fatController = TextEditingController();
    final _carbsController = TextEditingController();
    final _fiberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Food Manually'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Food Name'),
                ),
                TextField(
                  controller: _caloriesController,
                  decoration: InputDecoration(labelText: 'Calories'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _proteinController,
                  decoration: InputDecoration(labelText: 'Protein (g)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _fatController,
                  decoration: InputDecoration(labelText: 'Fat (g)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _carbsController,
                  decoration: InputDecoration(labelText: 'Carbs (g)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _fiberController,
                  decoration: InputDecoration(labelText: 'Fiber (g)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final calories =
                    double.tryParse(_caloriesController.text.trim()) ?? 0;
                final protein =
                    double.tryParse(_proteinController.text.trim()) ?? 0;
                final fat = double.tryParse(_fatController.text.trim()) ?? 0;
                final carbs =
                    double.tryParse(_carbsController.text.trim()) ?? 0;
                final fiber =
                    double.tryParse(_fiberController.text.trim()) ?? 0;

                if (name.isEmpty || calories <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter valid food name and calories',
                      ),
                    ),
                  );
                  return;
                }

                _addManualFood(name, calories, protein, fat, carbs, fiber);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addManualFood(
    String name,
    double calories,
    double protein,
    double fat,
    double carbs,
    double fiber,
  ) async {
    final box = Hive.box<FoodItem>('foodBox');

    final newFood = FoodItem(
      name: name,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      fiber: fiber,
      mealType: mealTypeToKey(widget.mealType),
      date: DateTime.now(),
    );

    await box.add(newFood);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$name added to your meal")));

    Navigator.pop(context); // Close current screen if needed or just refresh
  }

  final TextEditingController _controller = TextEditingController();
  List<FoodItem> _foods = [];
  bool _loading = false;

  void _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);
    try {
      final results = await searchFood(query); // Your API call
      setState(() => _foods = results);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _addToMeal(FoodItem item) async {
    final box = Hive.box<FoodItem>('foodBox');

    // Create new FoodItem with mealType as lowercase string
    final newFood = FoodItem(
      name: item.name,
      calories: item.calories,
      protein: item.protein,
      fat: item.fat,
      carbs: item.carbs,
      mealType: mealTypeToKey(widget.mealType),
      fiber: item.fiber,
      date: DateTime.now(), // ✅ lowercase
    );

    await box.add(newFood);

    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text("${item.name} added to your meal")));

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Food")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter food name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          if (_loading) CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _foods.length,
              itemBuilder: (context, index) {
                final food = _foods[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text(
                    'Calories: ${food.calories}, Protein: ${food.protein}g',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addToMeal(food),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showManualAddDialog,
        tooltip: 'Add Food Manually',
        child: Icon(Icons.add),
      ),
    );
  }
}
