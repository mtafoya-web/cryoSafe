import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../theme/app_theme.dart';

class VideoEmbed extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.outline(context)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadow(context).withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppTheme.redTint(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 18,
                    color: AppTheme.dangerRed,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 16 / 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.panelSurface(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.outline(context)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Inline video playback is available in the web version.\n\n$watchUrl',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.panelSurface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outline(context)),
              ),
              child: Link(
                uri: Uri.parse(watchUrl),
                target: LinkTarget.blank,
                builder: (context, followLink) {
                  return InkWell(
                    onTap: followLink,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        watchUrl,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.electricBlue,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
