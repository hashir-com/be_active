import 'package:flutter/foundation.dart';
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

  late ValueListenable<Box<DailyProgress>> _progressListenable;

  @override
  void initState() {
    super.initState();
    progressBox = Hive.box<DailyProgress>('dailyProgressBox');
    data = _generateProgressHeatmapData(progressBox);

    _progressListenable = progressBox.listenable();
    _boxListener = () {
      if (mounted) {
        setState(() {
          data = _generateProgressHeatmapData(progressBox);
        });
      }
    };
    _progressListenable.addListener(_boxListener);
  }

  @override
  void dispose() {
    _progressListenable.removeListener(_boxListener);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        final horizontalPadding = isDesktop ? 40.0.w : 16.0.w;
        final calendarSize = isDesktop ? 55.0.r : 45.0.r;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.2.sh),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Daily Progress Heatmap",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 12.sp : 26.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    todayFormatted,
                    style: TextStyle(
                      color: theme.primaryColorDark,
                      fontSize: isDesktop ? 8.sp : 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: HeatMapCalendar(
                defaultColor: theme.cardColor,
                initDate: DateTime.now(),
                colorMode: ColorMode.color,
                datasets: data,
                colorsets: progressColors,
                size: calendarSize,
                weekFontSize: isDesktop ? 3.sp : 12.sp,
                showColorTip: true,
                colorTipCount: 5,
                colorTipSize: isDesktop ? 6.r : 10.r,
                monthFontSize: isDesktop ? 10.sp : 20.sp,
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
                                _buildCheckTile(
                                  "Food Logged",
                                  progress.foodLogged,
                                  isDesktop,
                                ),
                                _buildCheckTile(
                                  "Water Logged",
                                  progress.waterLogged,
                                  isDesktop,
                                ),
                                _buildCheckTile(
                                  "Sleep Logged",
                                  progress.sleepLogged,
                                  isDesktop,
                                ),
                                _buildCheckTile(
                                  "Steps Logged",
                                  progress.stepsLogged,
                                  isDesktop,
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
                                  style: TextStyle(
                                    fontSize: isDesktop ? 8.sp : 14.sp,
                                  ),
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
      },
    );
  }

  Widget _buildCheckTile(String label, bool done, bool isDesktop) {
    return ListTile(
      leading: Icon(
        done ? Icons.check_circle : Icons.cancel,
        color: done ? Colors.green : Colors.red,
        size: isDesktop ? 24.r : 24.r,
      ),
      title: Text(label, style: TextStyle(fontSize: isDesktop ? 9.sp : 16.sp)),
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
