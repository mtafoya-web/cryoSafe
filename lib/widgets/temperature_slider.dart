import 'package:flutter/material.dart';

import '../utils/temperature_formatter.dart';

class TemperatureSlider extends StatelessWidget {
  const TemperatureSlider({
    super.key,
    required this.label,
    required this.helper,
    required this.value,
    required this.min,
    required this.max,
    required this.activeColor,
    required this.onChanged,
    this.compact = false,
  });

  final String label;
  final String helper;
  final double value;
  final double min;
  final double max;
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
                  Text(label, style: Theme.of(context).textTheme.labelLarge),
                  if (!compact) ...[
                    const SizedBox(height: 2),
                    Text(helper, style: Theme.of(context).textTheme.bodyMedium),
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
                formatTemperature(value),
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
            min: min,
            max: max,
            divisions: ((max - min) * 2).round(),
            label: formatTemperature(value),
            onChanged: onChanged,
          ),
        ),
        Row(
          children: [
            Text(formatTemperature(min),
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(formatTemperature(max),
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
