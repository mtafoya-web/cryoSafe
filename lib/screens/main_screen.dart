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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1080;
                final useCompactDesktop =
                    constraints.maxWidth < 1320 || constraints.maxHeight < 860;
                final desktopRailWidth = useCompactDesktop ? 340.0 : 388.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1440),
                    child: ListView(
                      primary: true,
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 24 : 16,
                        14,
                        isWide ? 24 : 16,
                        28,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        _DashboardHero(
                          controller: controller,
                          compact: !isWide || useCompactDesktop,
                        ),
                        SizedBox(height: isWide ? 22 : 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          child: isWide
                              ? Row(
                                  key: const ValueKey('desktop-browser-layout'),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: desktopRailWidth,
                                      child: InputPanel(
                                        controller: controller,
                                        compact: useCompactDesktop,
                                      ),
                                    ),
                                    SizedBox(
                                      width: useCompactDesktop ? 20 : 28,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ResultCard(
                                            result: controller.result,
                                            meatType: controller.meatType,
                                            fridgeTempF:
                                                controller.ambientFridgeTempF,
                                            initialTempF:
                                                controller.initialMeatTempF,
                                            thicknessInches:
                                                controller.thicknessInches,
                                            summary:
                                                controller.safetySummary,
                                            compact: useCompactDesktop,
                                          ),
                                          SizedBox(
                                            height:
                                                useCompactDesktop ? 16 : 20,
                                          ),
                                          SizedBox(
                                            height:
                                                useCompactDesktop ? 620 : 720,
                                            child: TemperatureChart(
                                              points: controller.points,
                                              compact: useCompactDesktop,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  key: const ValueKey('mobile-browser-layout'),
                                  children: [
                                    InputPanel(
                                      controller: controller,
                                      compact: true,
                                    ),
                                    const SizedBox(height: 12),
                                    ResultCard(
                                      result: controller.result,
                                      meatType: controller.meatType,
                                      fridgeTempF:
                                          controller.ambientFridgeTempF,
                                      initialTempF:
                                          controller.initialMeatTempF,
                                      thicknessInches:
                                          controller.thicknessInches,
                                      summary: controller.safetySummary,
                                      compact: true,
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 360,
                                      child: TemperatureChart(
                                        points: controller.points,
                                        compact: true,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
              size: 360,
              color: AppTheme.electricBlue.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            top: 120,
            left: -80,
            child: _GlowBlob(
              size: 280,
              color: AppTheme.safeGreen.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -140,
            right: 180,
            child: _GlowBlob(
              size: 340,
              color: AppTheme.violetInk.withValues(alpha: 0.08),
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

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.controller,
    this.compact = false,
  });

  final ThawController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 28 : 34),
        border: Border.all(color: Colors.white.withValues(alpha: 0.75)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.96),
            const Color(0xFFF5F9FF),
            AppTheme.mintGlow.withValues(alpha: 0.82),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withValues(alpha: 0.9),
            blurRadius: 42,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 22 : 28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 900;

            return stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCopy(controller: controller, compact: compact),
                      SizedBox(height: compact ? 14 : 20),
                      _HeroStats(controller: controller),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child:
                            _HeroCopy(controller: controller, compact: compact),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: _HeroStats(controller: controller),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.controller,
    this.compact = false,
  });

  final ThawController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_graph_rounded,
                    size: 16, color: AppTheme.frozenBlue),
                SizedBox(width: 8),
                Text('Thermodynamics-powered thaw forecasting'),
              ],
            ),
          ),
        ),
        SizedBox(height: compact ? 12 : 18),
        Text(
          'Beautifully clear refrigerator thaw analysis for real-world kitchen safety.',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: compact ? 30 : 42,
                height: 1.02,
              ),
        ),
        SizedBox(height: compact ? 10 : 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            'Track how temperature rises through the frozen band, stalls around 32°F, and eventually reaches the 41°F safety threshold with a cleaner, SaaS-style dashboard.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mutedTextColor,
                  height: compact ? 1.4 : 1.55,
                ),
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 22),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroPill(label: 'Live sliders'),
              _HeroPill(label: 'Phase-change model'),
              _HeroPill(label: 'Responsive layout'),
            ],
          ),
        ],
      ],
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats({required this.controller});

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _HeroStatCard(
          label: 'Estimated thaw',
          value: '${controller.estimatedHours.toStringAsFixed(0)}h',
          accent: AppTheme.frozenBlue,
          icon: Icons.schedule_rounded,
        ),
        _HeroStatCard(
          label: 'Phase slowdown',
          value: '${controller.plateauDurationHours.toStringAsFixed(1)}h',
          accent: AppTheme.safeGreen,
          icon: Icons.ac_unit_rounded,
        ),
        _HeroStatCard(
          label: 'Fridge temp',
          value: '${controller.ambientFridgeTempF.toStringAsFixed(1)}°F',
          accent: AppTheme.dangerRed,
          icon: Icons.thermostat_rounded,
        ),
      ],
    );
  }
}

class _HeroStatCard extends StatelessWidget {
  const _HeroStatCard({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
  });

  final String label;
  final String value;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
