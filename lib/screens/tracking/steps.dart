import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/steps_model.dart';
import 'package:thryv/theme/app_colors.dart';
import 'package:thryv/util/progress_utils.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  StepCounterScreenState createState() => StepCounterScreenState();
}

class StepCounterScreenState extends State<StepCounterScreen> {
  late Box<StepEntry> stepBox;
  late Box settingsBox;

  int dailyGoal = 10000;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    stepBox = Hive.box<StepEntry>('step_entries');
    settingsBox = Hive.box('settings');
    dailyGoal = settingsBox.get('step_goal', defaultValue: 10000);
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Color getStepColor(int step, int dailyGoal, BuildContext context) {
    final ratio = step / dailyGoal;

    if (ratio >= 1.0) {
      return Colors.green; // goal met or exceeded
    } else if (ratio >= 0.75) {
      return Colors.lightGreen;
    } else if (ratio >= 0.5) {
      return Colors.orange;
    } else if (ratio >= 0.25) {
      return Colors.deepOrange;
    } else {
      return Colors.red; // very low progress
    }
  }

  List<StepEntry> getLast7DaysEntries() {
    DateTime today = DateTime.now();
    List<StepEntry> entries = [];
    for (int i = 6; i >= 0; i--) {
      DateTime date = DateTime(today.year, today.month, today.day - i);
      StepEntry? entry = stepBox.get(date.toIso8601String());
      entries.add(entry ?? StepEntry(date: date, steps: 0));
    }
    return entries;
  }

  void _editGoal() async {
    TextEditingController controller = TextEditingController(
      text: dailyGoal.toString(),
    );
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("Set Step Goal"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter step goal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  int newGoal = int.tryParse(controller.text) ?? dailyGoal;
                  if (_isMounted) {
                    setState(() {
                      dailyGoal = newGoal;
                      settingsBox.put('step_goal', newGoal);
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
    );
  }

  void _addOrEditEntry(DateTime date) async {
    TextEditingController controller = TextEditingController();
    StepEntry? existingEntry = stepBox.get(date.toIso8601String());

    if (existingEntry != null) {
      controller.text = existingEntry.steps.toString();
    }

    int steps = 0;

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Enter steps for ${DateFormat.yMMMd().format(date)}'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Steps walked',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  steps = int.tryParse(controller.text) ?? 0;
                  StepEntry entry = StepEntry(date: date, steps: steps);
                  stepBox.put(date.toIso8601String(), entry);

                  if (_isMounted) {
                    setState(() {});
                  }

                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
    );

    if (_isMounted && steps >= dailyGoal) {
      Future.delayed(Duration.zero, () {
        if (_isMounted) _onGoalCompleted();
      });
      await updateDailyProgress(date: DateTime.now(), type: 'steps');
    }
  }

  void _onGoalCompleted() {
    if (!_isMounted) return;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Goal Achieved! 🎉'),
            content: const Text('You have reached your Steps goal!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nice!'),
              ),
            ],
          ),
    );
  }

  Widget buildBarChart(List<StepEntry> entries) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            maxY: dailyGoal.toDouble(),
            barGroups:
                entries.asMap().entries.map((e) {
                  final step = e.value.steps.toDouble();
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: step.clamp(0, dailyGoal.toDouble()),
                        width: 16,
                        color: getStepColor(step.toInt(), dailyGoal, context),

                        borderRadius: BorderRadius.circular(8),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: dailyGoal.toDouble(),
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                    showingTooltipIndicators: step > 0 ? [0] : [],
                  );
                }).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    DateTime date = entries[value.toInt()].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat.E().format(date),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2000,
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final steps = entries[group.x.toInt()].steps;
                  return BarTooltipItem(
                    '$steps steps',
                    TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StepEntry> last7Days = getLast7DaysEntries();
    int todaySteps = last7Days.last.steps;
    double burnedToday = (todaySteps / 1000) * 40;
    double goalBurn = (dailyGoal / 1000) * 40;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _editGoal,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$todaySteps of $dailyGoal steps walked',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _editGoal,
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: todaySteps / dailyGoal,
                        color: Theme.of(context).primaryColor,
                        backgroundColor: Colors.grey[300],
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories Burned',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your Goal:', style: TextStyle(fontSize: 14)),
                      Text(
                        '${goalBurn.toInt()} Cal 🔥',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Today\'s Burn:', style: TextStyle(fontSize: 14)),
                      Text(
                        '${burnedToday.toInt()} Cal 🔥',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today’s Tip",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Weight it. Weighted vests can be worn to bump up the intensity of your walk. "
                    "Wear one that's no more than 5–10% of your body weight for comfort and safety.",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Daily Steps Trend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            buildBarChart(last7Days),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          DateTime today = DateTime.now();
          _addOrEditEntry(DateTime(today.year, today.month, today.day));
        },
        child: Icon(
          Icons.run_circle_outlined,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
