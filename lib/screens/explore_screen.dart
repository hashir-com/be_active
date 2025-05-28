import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/user_model.dart'; // Update path as needed
import 'package:thryv/models/user_goal_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  UserModel? user;
  UserGoalModel? usergoal;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserModel>('userBox');
    final goalbox = Hive.box<UserGoalModel>('userGoalBox');
    user = box.get('user');
    usergoal = goalbox.get('usergoal');
  }

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

  Widget _buildPlanSection(
    String title,
    List<List<String>>? items,
    ThemeData theme,
  ) {
    if (items == null || items.isEmpty) {
      return Text("No $title saved.", style: theme.textTheme.bodyMedium);
    }

    return Column(
      children:
          items.map((item) {
            final itemTitle = item.isNotEmpty ? item[0] : "No Title";
            final itemDesc = item.length > 1 ? item[1] : "No Description";
            final imageUrl = item.length > 2 ? item[2] : null;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(itemTitle, style: theme.textTheme.titleMedium),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(itemDesc, style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoIds = getVideosForGoal(usergoal?.goal);
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
                            infoRow(Icons.cake, "Age", "${user!.age}", theme),
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
                              usergoal?.goal != null
                                  ? userGoalToString(usergoal!.goal!)
                                  : 'Not selected',
                              theme,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // if added
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
