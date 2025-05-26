import 'package:thryv/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'navigation_screen.dart';
import 'package:thryv/screens/calorie_tracking_page.dart';
import 'sleep.dart';
import 'steps.dart';
import 'water.dart';
import 'weight.dart';

void showTrackOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "What Would You Like to Track?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _trackItem(
              context,
              Icons.restaurant_menu,
              "Food",
              Colors.deepOrange,
              MealTrackerPage(),
            ),
            _trackItem(
              context,
              Icons.monitor_weight,
              "Weight",
              Colors.teal,
              WeightScreen(),
            ),
            _trackItem(
              context,
              Icons.local_drink,
              "Water",
              Colors.blue,
              WaterScreen(),
            ),
            _trackItem(
              context,
              Icons.directions_walk,
              "Steps",
              Colors.deepPurple,
              StepsScreen(),
            ),
            _trackItem(
              context,
              Icons.bedtime,
              "Sleep",
              Colors.indigo,
              SleepScreen(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _trackItem(
  BuildContext context,
  IconData icon,
  String label,
  Color color,
  Widget page,
) {
  return ListTile(
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(label),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
  );
}
