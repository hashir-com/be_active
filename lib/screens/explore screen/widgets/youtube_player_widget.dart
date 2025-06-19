// universal_youtube_player.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'youtube_player_mobile.dart'
    if (dart.library.html) 'youtube_player_web.dart';

class UniversalYoutubePlayer extends StatelessWidget {
  final String videoId;

  const UniversalYoutubePlayer({
    required this.videoId,
    super.key,
    required void Function(bool isFullScreen) onFullScreenChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformYoutubePlayer(videoId: videoId);
  }
}
