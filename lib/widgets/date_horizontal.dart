import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDateList extends StatefulWidget {
  const HorizontalDateList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HorizontalDateListState createState() => _HorizontalDateListState();
}

class _HorizontalDateListState extends State<HorizontalDateList> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> weekDates = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    generateWeekDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToToday();
    });
    checkNewDay();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void checkNewDay() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      if (!isSameDay(now, selectedDate)) {
        if (mounted) {
          setState(() {
            selectedDate = now;
            generateWeekDates();
          });
        }
        scrollToToday();
      }
    });
  }

  void generateWeekDates() {
    DateTime today = DateTime.now();
    // Create list of 7 days with today in center
    weekDates = List.generate(
      7,
      (index) => today.subtract(Duration(days: 3 - index)),
    );
  }

  void scrollToToday() {
    int todayIndex = 3; // Today is always at index 3
    if (_scrollController.hasClients) {
      double itemWidth = 60 + 12; // item width + margin
      double screenWidth = MediaQuery.of(context).size.width;
      double offset =
          (todayIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      offset = offset < 0 ? 0 : offset;
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth =
            (constraints.maxWidth - 4 * 1 * weekDates.length) /
            weekDates.length;

        return SizedBox(
          height: 80,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              DateTime date = weekDates[index];
              bool isSelected = isSameDay(date, selectedDate);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: Container(
                  width: itemWidth,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).primaryColorDark,
                      width: 0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(date),
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.d().format(date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected
                                  ? Colors.white
                                  : Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
