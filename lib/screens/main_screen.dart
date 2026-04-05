import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/thaw_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/input_panel.dart';
import '../widgets/result_card.dart';
import '../widgets/temperature_chart.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThawController>();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.ac_unit_rounded, size: 18, color: AppTheme.frozenBlue),
            SizedBox(width: 10),
            Text('CryoSafe'),
          ],
        ),
      ),
      body: Stack(
        children: [
          const _BackgroundGlow(),
          SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1360),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: [
                    _Header(controller: controller),
                    const SizedBox(height: 18),
                    _AnalysisWorkspace(controller: controller),
                    const SizedBox(height: 18),
                    _ThermoExplanation(controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withValues(alpha: 0.7),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 760;

            final summary = Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _HeaderPill(
                  label: 'Estimated thaw',
                  value: '${controller.estimatedHours.toStringAsFixed(1)} h',
                ),
                _HeaderPill(
                  label: 'Frozen to thaw plateau',
                  value:
                      '${controller.plateauDurationHours.toStringAsFixed(1)} h',
                ),
                _HeaderPill(
                  label: 'Display units',
                  value: controller.temperatureUnit.label,
                ),
              ],
            );

            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refrigerator thaw simulator',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'The inputs and chart below are linked as one analysis workspace so you can tune the model and read the temperature curve together.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.mutedTextColor,
                      ),
                ),
              ],
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  copy,
                  const SizedBox(height: 16),
                  summary,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 24),
                Expanded(flex: 5, child: summary),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panelColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _AnalysisWorkspace extends StatelessWidget {
  const _AnalysisWorkspace({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withValues(alpha: 0.78),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1040;
            final compact = constraints.maxWidth < 1240;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: compact ? 340 : 380,
                    child: InputPanel(
                      controller: controller,
                      compact: compact,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        ResultCard(
                          result: controller.result,
                          meatType: controller.meatType,
                          fridgeTempF: controller.ambientFridgeTempF,
                          initialTempF: controller.initialMeatTempF,
                          thicknessInches: controller.thicknessInches,
                          summary: controller.safetySummary,
                          temperatureUnit: controller.temperatureUnit,
                          compact: compact,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: compact ? 560 : 660,
                          child: TemperatureChart(
                            points: controller.displayPoints,
                            unit: controller.temperatureUnit,
                            frozenThreshold: controller.frozenThresholdDisplay,
                            safeThreshold: controller.safeThresholdDisplay,
                            compact: compact,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                InputPanel(
                  controller: controller,
                  compact: true,
                ),
                const SizedBox(height: 12),
                ResultCard(
                  result: controller.result,
                  meatType: controller.meatType,
                  fridgeTempF: controller.ambientFridgeTempF,
                  initialTempF: controller.initialMeatTempF,
                  thicknessInches: controller.thicknessInches,
                  summary: controller.safetySummary,
                  temperatureUnit: controller.temperatureUnit,
                  compact: true,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 380,
                  child: TemperatureChart(
                    points: controller.displayPoints,
                    unit: controller.temperatureUnit,
                    frozenThreshold: controller.frozenThresholdDisplay,
                    safeThreshold: controller.safeThresholdDisplay,
                    compact: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ThermoExplanation extends StatelessWidget {
  const _ThermoExplanation({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thermodynamics and calculation notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'CryoSafe uses a practical staged approximation of Newton’s Law of Cooling. The core idea is that the temperature change rate is proportional to the gap between the meat core temperature and the refrigerator temperature.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            const _EquationBlock(
              lines: [
                'dT/dt = k (T_fridge - T_core)',
                'Stage 1: below 32°F, ordinary warming toward the fridge temperature',
                'Stage 2: near 32°F, the curve slows to mimic latent heat during phase change',
                'Stage 3: above 32°F, warming resumes until the safe-thaw target at 41°F',
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _InfoTile(
                  title: 'Current meat profile',
                  body:
                      '${controller.meatType.label} at ${controller.thicknessInches.toStringAsFixed(1)} in thickness',
                ),
                _InfoTile(
                  title: 'Fridge environment',
                  body:
                      'Ambient setpoint is ${controller.ambientFridgeTempDisplay.toStringAsFixed(controller.temperatureUnit.name == 'kelvin' ? 2 : 1)}${controller.temperatureUnit.symbol}',
                ),
                _InfoTile(
                  title: 'Phase plateau',
                  body:
                      '${controller.plateauDurationHours.toStringAsFixed(1)} hours of slowed warming are currently modeled near the thaw boundary.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EquationBlock extends StatelessWidget {
  const _EquationBlock({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panelColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines
              .map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    line,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF7FBFF),
            AppTheme.shellColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -40,
            child: _GlowBlob(
              size: 320,
              color: AppTheme.electricBlue.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 180,
            left: -80,
            child: _GlowBlob(
              size: 260,
              color: AppTheme.safeGreen.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
