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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    children: [
                      _HeaderBar(controller: controller),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _AnalysisWorkspace(controller: controller),
                      ),
                      const SizedBox(height: 12),
                      _ThermoNotes(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withValues(alpha: 0.65),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Simulation workspace',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 12),
            _HeaderTag(
              label: 'Estimate',
              value: '${controller.estimatedHours.toStringAsFixed(1)} h',
            ),
            const SizedBox(width: 8),
            _HeaderTag(
              label: 'Units',
              value: controller.temperatureUnit.symbol,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderTag extends StatelessWidget {
  const _HeaderTag({
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall,
            children: [
              TextSpan(text: '$label '),
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

class _AnalysisWorkspace extends StatelessWidget {
  const _AnalysisWorkspace({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withValues(alpha: 0.75),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(14),
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
                  compact: true,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, workspaceConstraints) {
                      final sideBySide = workspaceConstraints.maxWidth >= 760;

                      if (sideBySide) {
                        final railWidth =
                            workspaceConstraints.maxWidth >= 1180 ? 360.0 : 320.0;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: railWidth,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: InputPanel(
                                  controller: controller,
                                  compact: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TemperatureChart(
                                points: controller.displayPoints,
                                unit: controller.temperatureUnit,
                                frozenThreshold:
                                    controller.frozenThresholdDisplay,
                                safeThreshold:
                                    controller.safeThresholdDisplay,
                                compact: true,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            flex: 9,
                            child: SizedBox.expand(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: InputPanel(
                                  controller: controller,
                                  compact: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            flex: 10,
                            child: SizedBox.expand(
                              child: TemperatureChart(
                                points: controller.displayPoints,
                                unit: controller.temperatureUnit,
                                frozenThreshold:
                                    controller.frozenThresholdDisplay,
                                safeThreshold:
                                    controller.safeThresholdDisplay,
                                compact: true,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ThermoNotes extends StatelessWidget {
  const _ThermoNotes({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          title: Text(
            'Thermodynamics and calculation notes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            'Newton cooling with a thaw plateau near 32°F/0°C.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          children: [
            Text(
              'CryoSafe uses a staged approximation of Newton’s Law of Cooling. The core rate model is dT/dt = k (T_fridge - T_core), then the slope is intentionally reduced near the freezing boundary to mimic latent heat during phase change. Thickness and meat type modify the effective warming coefficient, and the reported thaw time is the simulated time required for the core to reach the safe-thaw threshold.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
            top: -100,
            right: -40,
            child: _GlowBlob(
              size: 300,
              color: AppTheme.electricBlue.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -50,
            child: _GlowBlob(
              size: 240,
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
