import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:be_active/models/user_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserModel>('userBox');
    user = box.get('user');
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

  Widget youtubeVideo(String videoId) {
    return YoutubePlayerWidget(videoId: videoId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Explore")),
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
                              user!.goal?.name ?? 'N/A',
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
                    youtubeVideo(
                      "https://youtu.be/roHQ3F7d9YQ?si=3NPTyTb5XSUsIvMy",
                    ),
                    const SizedBox(height: 16),
                    youtubeVideo(
                      "https://youtu.be/g9QGQJ1ypp0?si=6wKHvfQSROmQATU7",
                    ),
                  ],
                ),
              ),
    );
  }
}

class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  const YoutubePlayerWidget({super.key, required this.videoId});

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
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Theme.of(context).colorScheme.primary,
    );
  }
}
