import 'package:flutter/material.dart';

Future<double?> showSetGoalDialog(
  BuildContext context,
  double currentGoal,
) async {
  final controller = TextEditingController(text: currentGoal.toString());
  return showDialog<double>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Set Sleep Goal (hours)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Enter hours (e.g., 7.5)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0 && value <= 24) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

Future<Map<String, DateTime>?> showAddEntryDialog(BuildContext context) async {
  DateTime bedTime = DateTime.now().subtract(const Duration(hours: 8));
  DateTime wakeUpTime = DateTime.now();

  return showDialog<Map<String, DateTime>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickBedTime() async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(bedTime),
            );
            if (time != null) {
              final now = DateTime.now();
              setState(() {
                bedTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  time.hour,
                  time.minute,
                );
              });
            }
          }

          Future<void> pickWakeUpTime() async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(wakeUpTime),
            );
            if (time != null) {
              final now = DateTime.now();
              setState(() {
                wakeUpTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  time.hour,
                  time.minute,
                );
              });
            }
          }

          return AlertDialog(
            title: const Text('Add Sleep Entry'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Bed Time'),
                  trailing: Text(
                    '${bedTime.hour.toString().padLeft(2, '0')}:${bedTime.minute.toString().padLeft(2, '0')}',
                  ),
                  onTap: pickBedTime,
                ),
                ListTile(
                  title: const Text('Wake Up Time'),
                  trailing: Text(
                    '${wakeUpTime.hour.toString().padLeft(2, '0')}:${wakeUpTime.minute.toString().padLeft(2, '0')}',
                  ),
                  onTap: pickWakeUpTime,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'bedTime': bedTime,
                    'wakeUpTime': wakeUpTime,
                  });
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
