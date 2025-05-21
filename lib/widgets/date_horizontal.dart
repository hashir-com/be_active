import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDateList extends StatefulWidget {
  const HorizontalDateList({super.key});

  @override
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
        setState(() {
          selectedDate = now;
          generateWeekDates();
        });
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
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF040B90)
                        : const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF040B90), width: 1.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat.d().format(date),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
