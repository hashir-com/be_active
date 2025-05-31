// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, duplicate_ignore

import 'dart:async';

import 'package:thryv/screens/tracking/meal_tracking/calorie_tracking_page.dart';
import 'package:thryv/services/api%20services/search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../models/food_item.dart';

class FoodSearchPage extends StatefulWidget {
  final MealType mealType;

  const FoodSearchPage({super.key, required this.mealType});

  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  Timer? _debounce;

  void _showManualAddDialog() {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final fatController = TextEditingController();
    final carbsController = TextEditingController();
    final fiberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Add Food Manually'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField('Food Name', nameController),
                _buildDialogField(
                  'Calories',
                  caloriesController,
                  isNumber: true,
                ),
                _buildDialogField(
                  'Protein (g)',
                  proteinController,
                  isNumber: true,
                ),
                _buildDialogField('Fat (g)', fatController, isNumber: true),
                _buildDialogField('Carbs (g)', carbsController, isNumber: true),
                _buildDialogField('Fiber (g)', fiberController, isNumber: true),
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
                final name = nameController.text.trim();
                final calories =
                    double.tryParse(caloriesController.text.trim()) ?? 0;
                final protein =
                    double.tryParse(proteinController.text.trim()) ?? 0;
                final fat = double.tryParse(fatController.text.trim()) ?? 0;
                final carbs = double.tryParse(carbsController.text.trim()) ?? 0;
                final fiber = double.tryParse(fiberController.text.trim()) ?? 0;

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

  Widget _buildDialogField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
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
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text("$name added to your meal")));
    Navigator.pop(context);
  }

  final TextEditingController _controller = TextEditingController();
  List<FoodItem> _foods = [];
  bool _loading = false;

  void _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);
    try {
      final results = await searchFood(query);
      setState(() => _foods = results);
    } catch (e) {
      if (kDebugMode) print("Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _addToMeal(FoodItem item) async {
    final box = Hive.box<FoodItem>('foodBox');

    final newFood = FoodItem(
      name: item.name,
      calories: item.calories,
      protein: item.protein,
      fat: item.fat,
      carbs: item.carbs,
      mealType: mealTypeToKey(widget.mealType),
      fiber: item.fiber,
      date: DateTime.now(),
    );

    await box.add(newFood);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${item.name} added to your meal")));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Food"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).highlightColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter food name',
                filled: true,
                fillColor: const Color.fromARGB(42, 255, 255, 255),
                prefixIcon: Icon(Icons.fastfood),
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _search(); // Trigger the search after 500ms of no typing
                });
              },
            ),

            const SizedBox(height: 12),
            if (_loading) CircularProgressIndicator(),
            if (!_loading)
              Expanded(
                child:
                    _foods.isEmpty
                        ? Center(child: Text("No results yet."))
                        : ListView.builder(
                          itemCount: _foods.length,
                          itemBuilder: (context, index) {
                            final food = _foods[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                onTap: () => _addToMeal(food),
                                title: Text(
                                  food.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Calories: ${food.calories.toStringAsFixed(1)} kcal\n'
                                  'Protein: ${food.protein.toStringAsFixed(1)}g, '
                                  'Fat: ${food.fat.toStringAsFixed(1)}g, '
                                  'Carbs: ${food.carbs.toStringAsFixed(1)}g',
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => _addToMeal(food),
                                ),
                              ),
                            );
                          },
                        ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showManualAddDialog,
        icon: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).highlightColor,
        label: Text("Add Food"),
        tooltip: 'Add Food Manually',
      ),
    );
  }
}
