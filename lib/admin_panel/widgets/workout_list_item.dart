import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thryv/admin_panel/workout_edit_page.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/screens/explore screen/workout_detail_screen.dart';

class WorkoutListItem extends StatelessWidget {
  final WorkoutPlan workout;
  final int index;
  final UserGoalModel userGoal;
  final VoidCallback onWorkoutDeleted; // Callback to notify parent on delete
  final VoidCallback onWorkoutEdited; // Callback to notify parent on edit

  const WorkoutListItem({
    super.key,
    required this.workout,
    required this.index,
    required this.userGoal,
    required this.onWorkoutDeleted,
    required this.onWorkoutEdited,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      elevation: 4,
      child: ListTile(
        leading:
            workout.imageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    File(workout.imageUrl!),
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                )
                : const Icon(Icons.fitness_center, color: Colors.indigo),
        title: Text(workout.workoutName ?? ''),
        subtitle: Text(workout.information ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
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
              builder: (_) => WorkoutDetailScreen(workout: workout),
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
          content: const Text("Are you sure you want to delete this workout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                userGoal.workoutPlans!.removeAt(index);
                onWorkoutDeleted(); // Trigger parent rebuild/save
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditWorkoutScreen(
              workout: workout,
              index: index,
              userGoal: userGoal,
            ),
      ),
    );

    if (edited == true) {
      onWorkoutEdited(); // Trigger parent rebuild/save
    }
  }
}
