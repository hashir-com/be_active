import 'package:Thryv/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:Thryv/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  UserModel? user;
  bool _isFullScreen = false; // Track fullscreen state

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserModel>('userBox');
    user = box.get('user');
  }

  // Callback from child to toggle fullscreen
  void _onFullScreenChanged(bool isFullScreen) {
    setState(() {
      _isFullScreen = isFullScreen;
    });
  }

  List<String> getVideosForGoal(UserGoal? goal) {
    switch (goal) {
      case UserGoal.weightLoss:
        return ["ahnl7GaV_rU", "YJcecddIdWo"];
      case UserGoal.weightGain:
        return ["S21o1IdwWf8", "KM3ko1Z4amA"];
      case UserGoal.muscleGain:
        return ["2tM1LFFxeKg", "M4K0s792wAU"];
      default:
        return [];
    }
  }

  Widget infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text("$label:", style: theme.textTheme.titleMedium),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoIds = getVideosForGoal(user?.goal);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
          _isFullScreen
              ? null
              : PreferredSize(
                preferredSize: Size.fromHeight(height * 0.15),
                child: Container(
                  color: theme.primaryColor,
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.07,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Text(
                          "Explore",
                          style: GoogleFonts.roboto(
                            fontSize: height * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      body:
          user == null
              ? Center(
                child: Text(
                  "No user data found.",
                  style: theme.textTheme.headlineMedium,
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Details", style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            infoRow(Icons.person, "Name", user!.name, theme),
                            infoRow(
                              Icons.cake,
                              "Age",
                              user!.age.toString(),
                              theme,
                            ),
                            infoRow(Icons.male, "Gender", user!.gender, theme),
                            infoRow(
                              Icons.height,
                              "Height",
                              "${user!.height} cm",
                              theme,
                            ),
                            infoRow(
                              Icons.monitor_weight,
                              "Weight",
                              "${user!.weight} kg",
                              theme,
                            ),
                            infoRow(
                              Icons.fitness_center,
                              "BMI",
                              user!.bmi?.toStringAsFixed(1) ?? 'N/A',
                              theme,
                            ),
                            infoRow(
                              Icons.flag,
                              "Goal",
                              user!.goal != null
                                  ? userGoalToString(user!.goal!)
                                  : 'N/A',

                              theme,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text("Plans", style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Workout Plan",
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              user!.workoutPlan ?? "No workout plan saved.",
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Diet Plan",
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              user!.dietPlan ?? "No diet plan saved.",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Recommended Videos",
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    ...videoIds.map(
                      (id) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: YoutubePlayerWidget(
                          videoId: id,
                          onFullScreenChanged: _onFullScreenChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  final ValueChanged<bool> onFullScreenChanged;

  const YoutubePlayerWidget({
    super.key,
    required this.videoId,
    required this.onFullScreenChanged,
  });

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        isLive: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    widget.onFullScreenChanged(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        widget.onFullScreenChanged(true);
      },
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        widget.onFullScreenChanged(false);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).colorScheme.primary,
      ),
      builder: (context, player) {
        return AspectRatio(aspectRatio: 16 / 9, child: player);
      },
    );
  }
}
