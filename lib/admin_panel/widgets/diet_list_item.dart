import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thryv/admin_panel/edit_diet_screen.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/screens/explore screen/diet_detail_screen.dart';

class DietListItem extends StatelessWidget {
  final DietPlan diet;
  final int index;
  final UserGoalModel userGoal;
  final VoidCallback onDietDeleted; // Callback to notify parent on delete
  final VoidCallback onDietEdited; // Callback to notify parent on edit

  const DietListItem({
    super.key,
    required this.diet,
    required this.index,
    required this.userGoal,
    required this.onDietDeleted,
    required this.onDietEdited,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(42),
      ),
      elevation: 4,
      child: ListTile(
        leading: diet.dietimage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  File(diet.dietimage!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.grey,
                  ),
                ),
              )
            : const Icon(
                Icons.fitness_center, // This icon might be misleading for diet, consider changing
                color: Colors.indigo,
              ),
        title: Text(diet.mealType ?? ''),
        subtitle: Text(diet.dietName ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () => _confirmDelete(context),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEdit(context),
              tooltip: 'Edit',
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DietDetailScreen(
                diet: diet,
                index: index, // Pass index if needed for DietDetailScreen
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this diet item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                userGoal.dietPlans!.removeAt(index);
                onDietDeleted(); // Trigger parent rebuild/save
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    // Validate index before pushing
    if (index < 0 || index >= (userGoal.dietPlans?.length ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid diet item index.')),
      );
      return;
    }

    final edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditDietScreen(
          diet: diet,
          index: index,
          userGoal: userGoal,
        ),
      ),
    );

    if (edited == true) {
      onDietEdited(); // Trigger parent rebuild/save
    }
  }
}