import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/temperature_point.dart';
import '../theme/app_theme.dart';
import '../utils/temperature_formatter.dart';

class TemperatureChart extends StatelessWidget {
  const TemperatureChart({
    super.key,
    required this.points,
    this.compact = false,
  });

  final List<TemperaturePoint> points;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final spots =
        points.map((point) => FlSpot(point.hours, point.temperatureF)).toList();
    final maxX = points.isEmpty ? 12.0 : points.last.hours.clamp(6, 48).toDouble();

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF9FBFF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.softShadow.withValues(alpha: 0.75),
              blurRadius: 34,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(compact ? 18 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temperature vs Time',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (!compact) ...[
                          const SizedBox(height: 6),
                          Text(
                            'A cleaner visual read of frozen, thaw, and danger bands with live temperature interpolation.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: compact ? 10 : 16),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _LegendChip(label: 'Frozen', color: AppTheme.frozenBlue),
                      _LegendChip(label: 'Safe', color: AppTheme.safeGreen),
                      _LegendChip(label: 'Danger', color: AppTheme.dangerRed),
                    ],
                  ),
                ],
              ),
              SizedBox(height: compact ? 12 : 18),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.borderColor.withValues(alpha: 0.75),
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 6 : 10,
                        compact ? 10 : 14,
                        compact ? 10 : 14,
                        compact ? 4 : 8,
                      ),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: maxX,
                          minY: -10,
                          maxY: 50,
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              getTooltipColor: (_) => AppTheme.inkColor,
                              getTooltipItems: (touchedSpots) => touchedSpots
                                  .map(
                                    (spot) => LineTooltipItem(
                                      '${spot.x.toStringAsFixed(1)}h\n${formatTemperature(spot.y)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            getTouchedSpotIndicator: (barData, spotIndexes) =>
                                spotIndexes
                                    .map(
                                      (_) => TouchedSpotIndicatorData(
                                        const FlLine(
                                          color: AppTheme.inkColor,
                                          strokeWidth: 1,
                                          dashArray: [3, 3],
                                        ),
                                        FlDotData(
                                          getDotPainter: (_, __, ___, ____) =>
                                              FlDotCirclePainter(
                                            radius: 5,
                                            color: Colors.white,
                                            strokeColor: AppTheme.inkColor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 32,
                                color: AppTheme.frozenBlue.withValues(alpha: 0.35),
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                                label: HorizontalLineLabel(
                                  show: true,
                                  alignment: Alignment.topLeft,
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 2),
                                  style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.frozenBlue,
                                            fontWeight: FontWeight.w700,
                                          ) ??
                                      const TextStyle(),
                                  labelResolver: (_) => '32°F thaw point',
                                ),
                              ),
                              HorizontalLine(
                                y: 41,
                                color: AppTheme.safeGreen.withValues(alpha: 0.4),
                                strokeWidth: 1.5,
                                dashArray: [6, 4],
                                label: HorizontalLineLabel(
                                  show: true,
                                  alignment: Alignment.topLeft,
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 2),
                                  style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.safeGreen,
                                            fontWeight: FontWeight.w700,
                                          ) ??
                                      const TextStyle(),
                                  labelResolver: (_) => '41°F target',
                                ),
                              ),
                            ],
                          ),
                          rangeAnnotations: RangeAnnotations(
                            horizontalRangeAnnotations: [
                              HorizontalRangeAnnotation(
                                y1: -10,
                                y2: 32,
                                color: AppTheme.chartBlueTint,
                              ),
                              HorizontalRangeAnnotation(
                                y1: 32,
                                y2: 41,
                                color: AppTheme.chartGreenTint,
                              ),
                              HorizontalRangeAnnotation(
                                y1: 41,
                                y2: 50,
                                color: AppTheme.chartRedTint,
                              ),
                            ],
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Temp (°F)',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: compact ? 34 : 44,
                                interval: 10,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Time (hours)',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: compact ? 26 : 32,
                                interval: maxX > 18 ? 4 : 2,
                                getTitlesWidget: (value, meta) => Text(
                                  '${value.toInt()}h',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 5,
                            verticalInterval: 2,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color:
                                  AppTheme.borderColor.withValues(alpha: 0.55),
                              strokeWidth: 1,
                            ),
                            getDrawingVerticalLine: (_) => FlLine(
                              color:
                                  AppTheme.borderColor.withValues(alpha: 0.28),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              color: AppTheme.frozenBlue,
                              barWidth: 3.6,
                              isCurved: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppTheme.frozenBlue.withValues(alpha: 0.15),
                                    AppTheme.frozenBlue.withValues(alpha: 0.02),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) =>
                                    spot == spots.first || spot == spots.last,
                                getDotPainter: (_, __, ___, ____) =>
                                    FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: AppTheme.frozenBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
