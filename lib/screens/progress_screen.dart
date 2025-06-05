import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thryv/models/daily_progress.dart'; // adjust path as needed

class HeatMapChart extends StatefulWidget {
  final int year;
  final int month;

  const HeatMapChart({super.key, required this.year, required this.month});

  @override
  State<HeatMapChart> createState() => _HeatMapChartState();
}

class _HeatMapChartState extends State<HeatMapChart> {
  Map<DateTime, int> progressData = {};

  @override
  void initState() {
    super.initState();
    loadProgressData();

    // Listen to changes in the Hive box to reload data dynamically
    Hive.box<DailyProgress>('dailyProgressBox').listenable().addListener(() {
      loadProgressData();
    });
  }

  Future<void> loadProgressData() async {
    final Box<DailyProgress> box = Hive.box<DailyProgress>('dailyProgressBox');

    final Map<DateTime, int> temp = {};

    for (var item in box.values) {
      if (item.date.year == widget.year && item.date.month == widget.month) {
        final day = DateTime(item.date.year, item.date.month, item.date.day);
        temp[day] = item.completionScore;
      }
    }

    setState(() {
      progressData = temp;
    });
  }

  List<Widget> buildCalendarCells() {
    int daysInMonth = DateUtils.getDaysInMonth(widget.year, widget.month);
    List<Widget> cells = [];

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(widget.year, widget.month, i);
      final status = progressData[day] ?? 0;

      Color getColor(int status) {
        switch (status) {
          case 1:
            return Colors.green.shade200;
          case 2:
            return Colors.green.shade400;
          case 3:
            return Colors.green.shade600;
          case 4:
            return Colors.green.shade800;
          default:
            return Colors.grey.shade300;
        }
      }

      cells.add(
        Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: getColor(status),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              '$i',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return cells;
  }

  Widget buildChart() {
    Map<int, int> weekdayCounts = {};
    progressData.forEach((date, score) {
      if (score > 0) {
        int weekday = date.weekday % 7; // Sunday = 0
        weekdayCounts[weekday] = (weekdayCounts[weekday] ?? 0) + 1;
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        return Expanded(
          child: Column(
            children: [
              Container(
                height: (weekdayCounts[index] ?? 0) * 10.0,
                width: 8,
                color: Colors.blue,
              ),
              if ((weekdayCounts[index] ?? 0) > 0)
                const Icon(Icons.check, color: Colors.green, size: 16),
            ],
          ),
        );
      }),
    );
  }

  String _monthName(int month) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.12),
        child: Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(top: height * 0.02, left: width * 0.07),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  "Progress",
                  style: GoogleFonts.roboto(
                    fontSize: width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '${_monthName(widget.month)} ${widget.year}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: buildCalendarCells(),
            ),
          ),
          const SizedBox(height: 20),
          buildChart(),
        ],
      ),
    );
  }
}
