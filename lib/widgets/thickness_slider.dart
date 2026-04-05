import 'package:flutter/material.dart';

class ThicknessSlider extends StatelessWidget {
  const ThicknessSlider({
    super.key,
    required this.value,
    required this.activeColor,
    required this.onChanged,
    this.compact = false,
  });

  final double value;
  final Color activeColor;
  final ValueChanged<double> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thickness',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Thicker cuts slow the thaw curve noticeably.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 10,
                vertical: compact ? 5 : 6,
              ),
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${value.toStringAsFixed(1)} in',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: activeColor,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 4 : 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: 0.14),
            trackHeight: compact ? 3 : null,
            inactiveTrackColor: activeColor.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: value,
            min: 0.5,
            max: 6.0,
            divisions: 22,
            label: '${value.toStringAsFixed(1)} in',
            onChanged: onChanged,
          ),
        ),
        Row(
          children: [
            Text('0.5 in', style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text('6.0 in', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
