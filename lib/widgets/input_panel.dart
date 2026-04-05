import 'package:flutter/material.dart';

import '../controllers/thaw_controller.dart';
import '../models/temperature_unit.dart';
import '../theme/app_theme.dart';
import '../utils/temperature_formatter.dart';
import 'meat_type_dropdown.dart';
import 'temperature_slider.dart';
import 'thickness_slider.dart';

class InputPanel extends StatelessWidget {
  const InputPanel({
    super.key,
    required this.controller,
    this.compact = false,
  });

  final ThawController controller;
  final bool compact;

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
        padding: EdgeInsets.all(compact ? 20 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simulation Inputs',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TemperatureSlider(
              label: 'Fridge Temperature',
              helper: 'Typical safe refrigerator range',
              value: controller.ambientFridgeTempDisplay,
              min: controller.fridgeMinDisplay,
              max: controller.fridgeMaxDisplay,
              activeColor: AppTheme.frozenBlue,
              onChanged: controller.updateAmbientFridgeTempDisplay,
              valueLabel: formatTemperature(
                controller.ambientFridgeTempF,
                unit: controller.temperatureUnit,
              ),
              minLabel: formatTemperature(
                33,
                unit: controller.temperatureUnit,
              ),
              maxLabel: formatTemperature(
                45,
                unit: controller.temperatureUnit,
              ),
              divisions: controller.temperatureUnit == TemperatureUnit.kelvin
                  ? 24
                  : null,
              compact: compact,
            ),
            SizedBox(height: compact ? 12 : 18),
            TemperatureSlider(
              label: 'Initial Meat Temperature',
              helper: 'Starting core temperature',
              value: controller.initialMeatTempDisplay,
              min: controller.meatMinDisplay,
              max: controller.meatMaxDisplay,
              activeColor: AppTheme.dangerRed,
              onChanged: controller.updateInitialMeatTempDisplay,
              valueLabel: formatTemperature(
                controller.initialMeatTempF,
                unit: controller.temperatureUnit,
              ),
              minLabel: formatTemperature(
                -10,
                unit: controller.temperatureUnit,
              ),
              maxLabel: formatTemperature(
                32,
                unit: controller.temperatureUnit,
              ),
              divisions: controller.temperatureUnit == TemperatureUnit.kelvin
                  ? 42
                  : null,
              compact: compact,
            ),
            SizedBox(height: compact ? 12 : 18),
            ThicknessSlider(
              value: controller.thicknessInches,
              activeColor: AppTheme.safeGreen,
              onChanged: controller.updateThickness,
              compact: compact,
            ),
            SizedBox(height: compact ? 12 : 18),
            MeatTypeDropdown(
              value: controller.meatType,
              onChanged: controller.updateMeatType,
              compact: compact,
            ),
            SizedBox(height: compact ? 16 : 22),
            _UnitSelector(
              value: controller.temperatureUnit,
              onChanged: controller.updateTemperatureUnit,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitSelector extends StatelessWidget {
  const _UnitSelector({
    required this.value,
    required this.onChanged,
  });

  final TemperatureUnit value;
  final ValueChanged<TemperatureUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Temperature Units', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<TemperatureUnit>(
          showSelectedIcon: false,
          multiSelectionEnabled: false,
          segments: TemperatureUnit.values
              .map(
                (unit) => ButtonSegment<TemperatureUnit>(
                  value: unit,
                  label: Text(unit.label),
                ),
              )
              .toList(),
          selected: {value},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ],
    );
  }
}
