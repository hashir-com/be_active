import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/daily_progress.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressHeatmapScreen extends StatefulWidget {
  const ProgressHeatmapScreen({super.key});

  @override
  State<ProgressHeatmapScreen> createState() => _ProgressHeatmapScreenState();
}

class _ProgressHeatmapScreenState extends State<ProgressHeatmapScreen> {
  late Box<DailyProgress> progressBox;
  late Map<DateTime, int> data;
  late VoidCallback _boxListener;

  @override
  void initState() {
    super.initState();
    progressBox = Hive.box<DailyProgress>('dailyProgressBox');
    data = _generateProgressHeatmapData(progressBox);

    // Add listener to update UI on box changes
    _boxListener = () {
      setState(() {
        data = _generateProgressHeatmapData(progressBox);
      });
    };

    progressBox.listenable().addListener(_boxListener);
  }

  @override
  void dispose() {
    progressBox.listenable().removeListener(_boxListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final Map<int, Color> progressColors = {
      0: const Color.fromARGB(255, 255, 255, 255), // gray for 0 tasks
      1: const Color(0xFFA5D6A7), // light green for 1 task
      2: const Color(0xFF81C784), // green for 2 tasks
      3: const Color(0xFF4CAF50), // medium green for 3 tasks
      4: const Color(0xFF2E7D32), // dark green for 4 tasks
    };

    final todayFormatted = DateFormat("EEEE, MMM d, y").format(DateTime.now());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(1000, 100),
        child: AppBar(
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Daily Progress Heatmap",
                  style: GoogleFonts.roboto(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                Text(
                  todayFormatted,
                  style: TextStyle(color: theme.primaryColorDark, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: HeatMapCalendar(
            defaultColor: Theme.of(context).cardColor,
            initDate: DateTime.now(),
            colorMode: ColorMode.color,
            datasets: data,
            colorsets: progressColors,
            size: 50,
            weekFontSize: 12,
            showColorTip: true,
            colorTipCount: 5,
            colorTipSize: 12,
            monthFontSize: 20,
            weekTextColor: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).colorScheme.onBackground,
            onClick: (date) {
              final key = _dateToKey(date);
              final progress = progressBox.get(key);

              if (progress != null) {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: Text(DateFormat.yMMMd().format(date)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCheckTile("Food Logged", progress.foodLogged),
                            _buildCheckTile(
                              "Water Logged",
                              progress.waterLogged,
                            ),
                            _buildCheckTile(
                              "Sleep Logged",
                              progress.sleepLogged,
                            ),
                            _buildCheckTile(
                              "Steps Logged",
                              progress.stepsLogged,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                data = _generateProgressHeatmapData(
                                  progressBox,
                                );
                              });
                            },
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCheckTile(String label, bool done) {
    return ListTile(
      leading: Icon(
        done ? Icons.check_circle : Icons.cancel,
        color: done ? Colors.green : Colors.red,
      ),
      title: Text(label),
    );
  }

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _keyToDate(String key) {
    return DateTime.parse(key);
  }

  Map<DateTime, int> _generateProgressHeatmapData(Box<DailyProgress> box) {
    final Map<DateTime, int> data = {};

    for (var key in box.keys) {
      final progress = box.get(key);
      if (progress != null) {
        final date = _keyToDate(key);
        int completed = 0;
        if (progress.foodLogged == true) completed++;
        if (progress.waterLogged == true) completed++;
        if (progress.sleepLogged == true) completed++;
        if (progress.stepsLogged == true) completed++;
        data[date] = completed;
      }
    }

    return data;
  }
}
