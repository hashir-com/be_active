import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlatformYoutubePlayer extends StatefulWidget {
  final String videoId;

  const PlatformYoutubePlayer({required this.videoId, super.key});

  @override
  State<PlatformYoutubePlayer> createState() => _PlatformYoutubePlayerState();
}

class _PlatformYoutubePlayerState extends State<PlatformYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
