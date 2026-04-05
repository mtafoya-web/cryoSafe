// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class VideoEmbed extends StatefulWidget {
  const VideoEmbed({
    super.key,
    required this.title,
    required this.description,
    required this.videoId,
    required this.watchUrl,
  });

  final String title;
  final String description;
  final String videoId;
  final String watchUrl;

  @override
  State<VideoEmbed> createState() => _VideoEmbedState();
}

class _VideoEmbedState extends State<VideoEmbed> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'cryo-safe-video-${widget.videoId}';

    // Register a dedicated iframe per video so the embed behaves like a normal
    // browser element on the website while mobile builds can keep a fallback.
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      final iframe = html.IFrameElement()
        ..src = 'https://www.youtube.com/embed/${widget.videoId}'
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow =
            'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
        ..allowFullscreen = true;

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panelColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: HtmlElementView(viewType: _viewType),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
