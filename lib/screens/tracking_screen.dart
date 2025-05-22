import 'package:be_active/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import 'package:be_active/screens/calorie_tracking_page.dart';

void showTrackOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "What would you like to track?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 30,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _trackOption(context, Icons.fastfood, "Calorie"),
                _trackOption(context, Icons.local_drink, "Water"),
                _trackOption(context, Icons.hotel, "Sleep"),
                _trackOption(context, Icons.directions_walk, "Steps"),
                _trackOption(context, Icons.monitor_weight, "Weight"),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _trackOption(BuildContext context, IconData icon, String label) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealTrackerPage()),
      );
      // Add your navigation or action here.
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade50,
          ),
          child: Icon(icon, size: 28, color: Colors.blue),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    ),
  );
}
