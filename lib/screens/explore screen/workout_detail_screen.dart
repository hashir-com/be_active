import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thryv/models/workout_model.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutPlan workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.workoutName ?? 'Workout Detail'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(46),
              ),

              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (workout.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(46),
                        child: Hero(
                          tag: 'image',
                          child: Image.file(
                            File(workout.imageUrl!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.fitness_center,
                      'Exercise Name',
                      workout.workoutName ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.format_list_numbered_rounded,
                      '	Number of Sets',
                      workout.sets.toString(),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.replay_sharp,
                      'Repetition Type',
                      workout.unitType ?? "",
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.access_time,
                      'Reps / Duration',
                      workout.unitValue ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.list_alt,
                      'How to Perform',
                      workout.instruction ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.info_outline,
                      'Why this Exercise?',
                      workout.information ?? '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade800, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
