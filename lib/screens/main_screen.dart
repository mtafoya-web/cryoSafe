import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../controllers/thaw_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/input_panel.dart';
import '../widgets/result_card.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/video_embed_stub.dart'
    if (dart.library.html) '../widgets/video_embed_web.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey _analysisKey = GlobalKey();
  final GlobalKey _howToKey = GlobalKey();

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) {
      return;
    }

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
      alignment: 0.04,
    );
  }

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
                child: LayoutBuilder(
                  builder: (context, constraints) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: _ScreenContent(
                      controller: controller,
                      analysisKey: _analysisKey,
                      howToKey: _howToKey,
                      onOpenSimulation: () => _scrollTo(_analysisKey),
                      onOpenHowTo: () => _scrollTo(_howToKey),
                    ),
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

class _ScreenContent extends StatelessWidget {
  const _ScreenContent({
    required this.controller,
    required this.analysisKey,
    required this.howToKey,
    required this.onOpenSimulation,
    required this.onOpenHowTo,
  });

  final ThawController controller;
  final GlobalKey analysisKey;
  final GlobalKey howToKey;
  final VoidCallback onOpenSimulation;
  final VoidCallback onOpenHowTo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        _HeaderBar(
          controller: controller,
          onOpenSimulation: onOpenSimulation,
          onOpenHowTo: onOpenHowTo,
        ),
        const SizedBox(height: 12),
        KeyedSubtree(
          key: analysisKey,
          child: _AnalysisWorkspace(controller: controller),
        ),
        const SizedBox(height: 8),
        _ThermoNotes(
          controller: controller,
          howToKey: howToKey,
        ),
      ],
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.controller,
    required this.onOpenSimulation,
    required this.onOpenHowTo,
  });

  final ThawController controller;
  final VoidCallback onOpenSimulation;
  final VoidCallback onOpenHowTo;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simulation workspace',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use the header actions to jump between the model and the how-to section.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                _HeaderNavButton(
                  label: 'Simulation',
                  icon: Icons.analytics_rounded,
                  onTap: onOpenSimulation,
                ),
                _HeaderNavButton(
                  label: 'How-to',
                  icon: Icons.menu_book_rounded,
                  onTap: onOpenHowTo,
                ),
                _HeaderTag(
                  label: 'Estimate',
                  value: '${controller.estimatedHours.toStringAsFixed(1)} h',
                ),
                _HeaderTag(
                  label: 'Units',
                  value: controller.temperatureUnit.symbol,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderNavButton extends StatelessWidget {
  const _HeaderNavButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideBySide = constraints.maxWidth >= 900;
        final railWidth = constraints.maxWidth >= 1180 ? 360.0 : 320.0;

        return Column(
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
            if (sideBySide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: railWidth,
                    child: InputPanel(
                      controller: controller,
                      compact: true,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 560,
                      child: TemperatureChart(
                        points: controller.displayPoints,
                        unit: controller.temperatureUnit,
                        frozenThreshold: controller.frozenThresholdDisplay,
                        safeThreshold: controller.safeThresholdDisplay,
                        compact: true,
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  InputPanel(
                    controller: controller,
                    compact: true,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 360,
                    child: TemperatureChart(
                      points: controller.displayPoints,
                      unit: controller.temperatureUnit,
                      frozenThreshold: controller.frozenThresholdDisplay,
                      safeThreshold: controller.safeThresholdDisplay,
                      compact: true,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _ThermoNotes extends StatelessWidget {
  const _ThermoNotes({
    required this.controller,
    required this.howToKey,
  });

  final ThawController controller;
  final GlobalKey howToKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thermodynamics notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Newton cooling with a thaw plateau near 32°F/0°C.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 1080;
                final mediaCardWidth = wide
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectionArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CryoSafe uses a staged approximation of Newton’s Law of Cooling: dT/dt = k (T_fridge - T_core). The slope is reduced near the freezing boundary to mimic latent heat during phase change, and thickness plus meat type adjust the effective warming coefficient.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          KeyedSubtree(
                            key: howToKey,
                            child: Text(
                              'How to measure thickness',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const _NoteBullet(
                            text:
                                'Lay the cut flat and measure from the top surface to the bottom surface at the thickest point.',
                          ),
                          const _NoteBullet(
                            text:
                                'For tapered cuts like chicken breasts or fish fillets, ignore the thin tail and use the thick center section.',
                          ),
                          const _NoteBullet(
                            text:
                                'If the cut is uneven, enter the maximum thickness because the coldest, thickest section controls thaw time.',
                          ),
                          const _NoteBullet(
                            text:
                                'If several pieces are stacked or touching, measure the thickest individual piece rather than the whole pile.',
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'How to measure meat temperature',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          const _NoteBullet(
                            text:
                                'Use an instant-read food thermometer and insert the probe into the center of the thickest section.',
                          ),
                          const _NoteBullet(
                            text:
                                'Avoid bone, large fat pockets, or the tray surface because they can give misleading readings.',
                          ),
                          const _NoteBullet(
                            text:
                                'For thin cuts, insert the probe from the side so the sensing tip lands in the middle instead of poking through.',
                          ),
                          const _NoteBullet(
                            text:
                                'If the cut is large or irregular, take two readings in different spots and use the colder one.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _SectionHeader(
                      title: 'Video walkthroughs',
                      subtitle:
                          'Playable right on the site for quick thermometer and placement demos.',
                      icon: Icons.ondemand_video_rounded,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: mediaCardWidth,
                          child: const VideoEmbed(
                            title: 'How to Properly Use a Meat Thermometer',
                            description:
                                'Probe-placement demo for burgers, chops, chicken breast, and roasts.',
                            videoId: 'YRQ47Ieddkk',
                            watchUrl: 'https://www.youtube.com/watch?v=YRQ47Ieddkk',
                          ),
                        ),
                        SizedBox(
                          width: mediaCardWidth,
                          child: const VideoEmbed(
                            title: 'How to Use a Meat Thermometer',
                            description:
                                'General kitchen walkthrough covering instant-read use and center-point placement.',
                            videoId: 'rtDp1nyXquY',
                            watchUrl: 'https://www.youtube.com/watch?v=rtDp1nyXquY',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _SectionHeader(
                      title: 'Quick reference guides',
                      subtitle:
                          'Trusted food-safety sources for placement, safe temperature checks, and handling basics.',
                      icon: Icons.link_rounded,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: wide
                              ? (constraints.maxWidth - 24) / 3
                              : constraints.maxWidth,
                          child: const _ResourceTile(
                            title: 'CDC thermometer guidance',
                            description:
                                'Short official explainer on why food thermometers matter and when to use them.',
                            url:
                                'https://www.cdc.gov/food-safety/communication-resources/always-use-a-food-thermometer.html',
                          ),
                        ),
                        SizedBox(
                          width: wide
                              ? (constraints.maxWidth - 24) / 3
                              : constraints.maxWidth,
                          child: const _ResourceTile(
                            title: 'USDA food thermometer guide',
                            description:
                                'Official placement guidance for meat, poultry, fish, and thin cuts.',
                            url:
                                'https://www.fsis.usda.gov/food-safety/safe-food-handling-and-preparation/food-safety-basics/food-thermometers',
                          ),
                        ),
                        SizedBox(
                          width: wide
                              ? (constraints.maxWidth - 24) / 3
                              : constraints.maxWidth,
                          child: const _ResourceTile(
                            title: 'USDA safe thawing basics',
                            description:
                                'Best-practice thawing rules to pair with the simulation when planning refrigerator defrosting.',
                            url:
                                'https://www.fsis.usda.gov/food-safety/safe-food-handling-and-preparation/food-safety-basics/big-thaw-safe-defrosting-methods',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.chartBlueTint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppTheme.frozenBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoteBullet extends StatelessWidget {
  const _NoteBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppTheme.electricBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.title,
    required this.description,
    required this.url,
  });

  final String title;
  final String description;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: followLink,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.softShadow.withValues(alpha: 0.28),
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
                            color: AppTheme.chartGreenTint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.open_in_new_rounded,
                            size: 16,
                            color: AppTheme.safeGreen,
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
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.panelColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Text(
                        url,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.electricBlue,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
