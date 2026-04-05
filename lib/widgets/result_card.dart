import 'package:flutter/material.dart';

import '../models/meat_type.dart';
import '../models/thaw_result.dart';
import '../models/temperature_unit.dart';
import '../theme/app_theme.dart';
import '../utils/temperature_formatter.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.result,
    required this.meatType,
    required this.fridgeTempF,
    required this.initialTempF,
    required this.thicknessInches,
    required this.summary,
    required this.temperatureUnit,
    this.compact = false,
  });

  final ThawResult result;
  final MeatType meatType;
  final double fridgeTempF;
  final double initialTempF;
  final double thicknessInches;
  final String summary;
  final TemperatureUnit temperatureUnit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent =
        result.safeTargetReached ? AppTheme.safeGreen : AppTheme.dangerRed;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              accent.withValues(alpha: 0.05),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.12),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(compact ? 20 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: compact ? 78 : 96,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Time To Safe Thaw',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: compact ? 6 : 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: Text(
                            formatCompactDuration(result.hoursToSafeTemp),
                            key: ValueKey(
                              result.hoursToSafeTemp.toStringAsFixed(2),
                            ),
                            style:
                                Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      color: AppTheme.inkColor,
                                      height: 1,
                                      fontSize: compact ? 44 : null,
                                    ),
                          ),
                        ),
                        SizedBox(height: compact ? 6 : 8),
                        Text(
                          summary,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 14 : 18),
              Wrap(
                spacing: compact ? 8 : 10,
                runSpacing: compact ? 8 : 10,
                children: [
                  _MetricPill(label: 'Protein', value: meatType.label),
                  _MetricPill(
                    label: 'Fridge',
                    value: formatTemperature(
                      fridgeTempF,
                      unit: temperatureUnit,
                    ),
                  ),
                  _MetricPill(
                    label: 'Start',
                    value: formatTemperature(
                      initialTempF,
                      unit: temperatureUnit,
                    ),
                  ),
                  _MetricPill(
                    label: 'Thickness',
                    value: '${formatShortNumber(thicknessInches)} in',
                  ),
                  _MetricPill(
                    label: 'Phase plateau',
                    value: formatCompactDuration(result.plateauDurationHours),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(text: '$label  '),
              TextSpan(
                text: value,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
