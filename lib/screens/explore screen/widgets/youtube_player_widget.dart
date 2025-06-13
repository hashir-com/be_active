import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'dart:ui' as ui; // for HtmlElementView
import 'dart:html'; // only used on web

class UniversalYoutubePlayer extends StatelessWidget {
  final String videoId;

  const UniversalYoutubePlayer({super.key, required this.videoId, required void Function(bool isFullScreen) onFullScreenChanged});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Register a unique iframe for this videoId
      final String viewId = 'youtube-video-$videoId';
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int _) =>
            IFrameElement()
              ..src = 'https://www.youtube.com/embed/$videoId'
              ..style.border = 'none'
              ..allowFullscreen = true,
      );

      return SizedBox(height: 200, child: HtmlElementView(viewType: viewId));
    } else {
      // Mobile: Use youtube_player_flutter
      return SizedBox(
        height: 200,
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          ),
          showVideoProgressIndicator: true,
        ),
      );
    }
  }
}
