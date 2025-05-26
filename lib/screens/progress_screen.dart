import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeatMapChart extends StatelessWidget {
  final int year;
  final int month;
  final Map<DateTime, int> progressData;

  const HeatMapChart({super.key, 
    required this.year,
    required this.month,
    required this.progressData,
  });

  List<Widget> buildCalendarCells() {
    int daysInMonth = DateUtils.getDaysInMonth(year, month);
    List<Widget> cells = [];

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(year, month, i);
      final status = progressData[day] ?? 0;

      Color getColor(int status) {
        switch (status) {
          case 1:
            return Colors.green.shade100;
          case 2:
            return Colors.green.shade300;
          case 3:
            return Colors.green.shade500;
          case 4:
            return Colors.green.shade700;
          default:
            return Colors.grey.shade300;
        }
      }

      cells.add(
        Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: getColor(status),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text('$i')),
        ),
      );
    }

    return cells;
  }

  Widget buildChart() {
    Map<int, int> weekdayCounts = {};
    progressData.forEach((date, status) {
      if (status > 0) {
        int weekday = date.weekday % 7; // Sunday=0 to Saturday=6
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
                Icon(Icons.check, color: Colors.green, size: 16),
            ],
          ),
        );
      }),
    );
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
          color: theme.primaryColor, // dynamic appbar bg
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
                    color: Colors.white, // dynamic color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            '${_monthName(month)} $year',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: buildCalendarCells(),
            ),
          ),
          SizedBox(height: 20),
          buildChart(),
        ],
      ),
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
}
