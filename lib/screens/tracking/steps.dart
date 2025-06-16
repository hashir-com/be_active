import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/steps_model.dart';
import 'package:thryv/theme/app_colors.dart';
import 'package:thryv/util/progress_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  Color getStepColor(int step, int goal, BuildContext context) {
    final ratio = step / goal;
    if (ratio >= 1.0) return Colors.green;
    if (ratio >= 0.75) return Colors.lightGreen;
    if (ratio >= 0.5) return Colors.orange;
    if (ratio >= 0.25) return Colors.deepOrange;
    return Colors.red;
  }

  List<StepEntry> getLast7DaysEntries() {
    DateTime today = DateTime.now();
    List<StepEntry> entries = [];
    for (int i = 6; i >= 0; i--) {
      DateTime date = DateTime(today.year, today.month, today.day - i);
      StepEntry? entry = stepBox.get(date.toIso8601String());
      entries.add(entry ?? StepEntry(date: date, steps: 0, stepGoal: 10000));
    }
    return entries;
  }

  void _editGoal() async {
    final controller = TextEditingController(text: dailyGoal.toString());
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Set Step Goal"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter step goal'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  int newGoal = int.tryParse(controller.text) ?? dailyGoal;
                  if (_isMounted && newGoal > 0) {
                    setState(() {
                      dailyGoal = newGoal;
                      settingsBox.put('step_goal', newGoal);
                    });

                    // ✅ Update today's StepEntry with new goal
                    final today = DateTime.now();
                    final todayKey =
                        DateTime(
                          today.year,
                          today.month,
                          today.day,
                        ).toIso8601String();
                    final existing = stepBox.get(todayKey);
                    final updatedEntry = StepEntry(
                      date: today,
                      steps: existing?.steps ?? 0,
                      stepGoal: newGoal,
                    );
                    await stepBox.put(todayKey, updatedEntry);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Goal updated to $newGoal steps")),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _addOrEditEntry(DateTime date) async {
    final controller = TextEditingController();
    final existingEntry = stepBox.get(date.toIso8601String());
    if (existingEntry != null) controller.text = existingEntry.steps.toString();

    int steps = 0;
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Steps for ${DateFormat.yMMMd().format(date)}'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter steps'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  steps = int.tryParse(controller.text) ?? 0;
                  stepBox.put(
                    date.toIso8601String(),
                    StepEntry(date: date, steps: steps, stepGoal: dailyGoal),
                  );
                  if (_isMounted) setState(() {});
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );

    if (_isMounted && steps >= dailyGoal) {
      _onGoalCompleted();
      await updateDailyProgress(date: date, type: 'steps');
    }
  }

  void _onGoalCompleted() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Goal Achieved 🎉'),
            content: const Text('You have reached your step goal!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Nice!'),
              ),
            ],
          ),
    );
  }

  Widget buildBarChart(List<StepEntry> entries, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SizedBox(
        height: isDesktop ? 300 : 250,
        child: BarChart(
          BarChartData(
            maxY:
                entries
                    .map((e) => e.stepGoal)
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble(),

            barGroups:
                entries.asMap().entries.map((e) {
                  final step = e.value.steps.toDouble();
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: step.clamp(0, dailyGoal.toDouble()),
                        width: isDesktop ? 20 : 12,
                        color: getStepColor(step.toInt(), dailyGoal, context),
                        borderRadius: BorderRadius.circular(isDesktop ? 10 : 6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: dailyGoal.toDouble(),
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
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
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat.E().format(date),
                        style: TextStyle(fontSize: isDesktop ? 14 : 10),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5000,
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, _, rod, __) {
                  final steps = entries[group.x.toInt()].steps;
                  return BarTooltipItem(
                    '$steps 👟',
                    TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 8 : 10,
                    ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    final last7Days = getLast7DaysEntries();
    final todaySteps = last7Days.last.steps;
    final burnedToday = (todaySteps / 1000) * 40;
    final goalBurn = (dailyGoal / 1000) * 40;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Step Counter',
          style: TextStyle(fontSize: isDesktop ? 20 : 26),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child:
            isDesktop
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: _buildLeftColumn(
                          todaySteps,
                          burnedToday,
                          goalBurn,
                          isDesktop,
                        ),
                      ),
                    ),
                    SizedBox(width: isDesktop ? 20 : 10),
                    Expanded(child: buildBarChart(last7Days, isDesktop)),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildLeftColumn(
                      todaySteps,
                      burnedToday,
                      goalBurn,
                      isDesktop,
                    ),
                    SizedBox(height: isDesktop ? 24 : 18),
                    Text(
                      'Steps Trend',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 12),
                    buildBarChart(last7Days, isDesktop),
                    SizedBox(height: 60),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          final today = DateTime.now();
          _addOrEditEntry(DateTime(today.year, today.month, today.day));
        },
        child: Icon(
          Icons.directions_walk_rounded,
          size: isDesktop ? 28 : 22,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }

  List<Widget> _buildLeftColumn(
    int todaySteps,
    double burnedToday,
    double goalBurn,
    bool isDesktop,
  ) {
    return [
      GestureDetector(
        onTap: _editGoal,
        child: Container(
          padding: EdgeInsets.all(isDesktop ? 20 : 22),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(isDesktop ? 20 : 22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$todaySteps of $dailyGoal steps walked',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.edit, size: isDesktop ? 22 : 18),
                ],
              ),
              SizedBox(height: isDesktop ? 12 : 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: todaySteps / dailyGoal,
                  color: Theme.of(context).primaryColor,
                  backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                  minHeight: isDesktop ? 12 : 8,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: isDesktop ? 20 : 14),
      _buildCaloriesCard(goalBurn, burnedToday, isDesktop),
      SizedBox(height: isDesktop ? 20 : 14),
      _buildTipCard(isDesktop),
    ];
  }

  Widget _buildCaloriesCard(
    double goalBurn,
    double burnedToday,
    bool isDesktop,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDesktop ? 18 : 12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories Burned',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16 : 18,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Goal:',
                style: TextStyle(fontSize: isDesktop ? 14 : 14),
              ),
              Text(
                '${goalBurn.toInt()} Cal 🔥',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 14 : 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Burn:',
                style: TextStyle(fontSize: isDesktop ? 14 : 14),
              ),
              Text(
                '${burnedToday.toInt()} Cal 🔥',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 14 : 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(isDesktop ? 18 : 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today’s Tip",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 16 : 14,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Weighted vests can make your walks more effective. Use one that’s only 5–10% of your body weight for safety and comfort.",
            style: TextStyle(fontSize: isDesktop ? 13 : 11),
          ),
        ],
      ),
    );
  }
}
