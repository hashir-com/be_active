import 'package:flutter/material.dart';
import 'package:thryv/models/workout_model.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutPlan workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout.workoutName ?? 'Workout Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (workout.imageUrl != null && workout.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  workout.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            const SizedBox(height: 16),
            Text(workout.workoutName ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(workout.instruction ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(workout.information ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
