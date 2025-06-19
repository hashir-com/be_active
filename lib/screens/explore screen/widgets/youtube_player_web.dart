import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PlatformYoutubePlayer extends StatelessWidget {
  final String videoId;

  const PlatformYoutubePlayer({required this.videoId, super.key});

  @override
  Widget build(BuildContext context) {
    final String viewId = 'youtube-$videoId';

    // Register the iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final iframe =
          IFrameElement()
            ..width = '100%'
            ..height = '100%'
            ..src = 'https://www.youtube.com/embed/$videoId'
            ..style.border = 'none';
      return iframe;
    });

    return SizedBox(height: 200, child: HtmlElementView(viewType: viewId));
  }
}
