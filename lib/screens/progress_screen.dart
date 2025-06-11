import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final Map<int, Color> progressColors = {
      0: const Color.fromARGB(255, 255, 255, 255),
      1: const Color(0xFFA5D6A7),
      2: const Color(0xFF81C784),
      3: const Color(0xFF4CAF50),
      4: const Color(0xFF2E7D32),
    };

    final todayFormatted = DateFormat("EEEE, MMM d, y").format(DateTime.now());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.2.sh),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Daily Progress Heatmap",
              style: GoogleFonts.roboto(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
              ),
            ),
            Text(
              todayFormatted,
              style: TextStyle(color: theme.primaryColorDark, fontSize: 12.sp),
            ),
          ],
        ),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: HeatMapCalendar(
            defaultColor: Theme.of(context).cardColor,
            initDate: DateTime.now(),
            colorMode: ColorMode.color,
            datasets: data,
            colorsets: progressColors,
            size: 55.r,
            weekFontSize: 12.sp,
            showColorTip: true,
            colorTipCount: 5,
            colorTipSize: 10.r,
            monthFontSize: 20.sp,
            weekTextColor: theme.primaryColorDark,
            textColor: theme.colorScheme.onSurface,
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
                            child: Text(
                              "Close",
                              style: TextStyle(fontSize: 14.sp),
                            ),
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
        size: 24.r,
      ),
      title: Text(label, style: TextStyle(fontSize: 16.sp)),
    );
  }

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _keyToDate(String key) => DateTime.parse(key);

  Map<DateTime, int> _generateProgressHeatmapData(Box<DailyProgress> box) {
    final Map<DateTime, int> data = {};

    for (var key in box.keys) {
      final progress = box.get(key);
      if (progress != null) {
        final date = _keyToDate(key);
        int completed = 0;
        if (progress.foodLogged) completed++;
        if (progress.waterLogged) completed++;
        if (progress.sleepLogged) completed++;
        if (progress.stepsLogged) completed++;
        data[date] = completed;
      }
    }
    return data;
  }
}
