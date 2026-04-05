import 'package:flutter/material.dart';

import '../controllers/thaw_controller.dart';
import '../theme/app_theme.dart';
import 'meat_type_dropdown.dart';
import 'temperature_slider.dart';
import 'thickness_slider.dart';

class InputPanel extends StatelessWidget {
  const InputPanel({
    super.key,
    required this.controller,
  });

  final ThawController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.94),
            const Color(0xFFF8FBFF),
          ],
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withValues(alpha: 0.8),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simulation Inputs',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Adjust the refrigerator environment and meat geometry to estimate a safe thaw curve in real time.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const _InfoCallout(
              icon: Icons.thermostat_rounded,
              title: 'Safety target',
              body: 'The dashboard estimates when the center of the cut reaches 41°F under refrigerator conditions.',
            ),
            const SizedBox(height: 16),
            TemperatureSlider(
              label: 'Fridge Temperature',
              helper: 'Typical safe refrigerator range',
              value: controller.ambientFridgeTempF,
              min: 33,
              max: 45,
              activeColor: AppTheme.frozenBlue,
              onChanged: controller.updateAmbientFridgeTemp,
            ),
            const SizedBox(height: 18),
            TemperatureSlider(
              label: 'Initial Meat Temperature',
              helper: 'Starting core temperature',
              value: controller.initialMeatTempF,
              min: -10,
              max: 32,
              activeColor: AppTheme.dangerRed,
              onChanged: controller.updateInitialMeatTemp,
            ),
            const SizedBox(height: 18),
            ThicknessSlider(
              value: controller.thicknessInches,
              activeColor: AppTheme.safeGreen,
              onChanged: controller.updateThickness,
            ),
            const SizedBox(height: 18),
            MeatTypeDropdown(
              value: controller.meatType,
              onChanged: controller.updateMeatType,
            ),
            const SizedBox(height: 22),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FactChip(label: 'Newton cooling'),
                _FactChip(label: 'Phase change near 32°F'),
                _FactChip(label: 'Real-time updates'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCallout extends StatelessWidget {
  const _InfoCallout({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.chartBlueTint,
            AppTheme.chartBlueTint.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, color: AppTheme.frozenBlue),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
