import 'dart:math' as math;

import 'meat_type.dart';
import 'temperature_point.dart';
import 'thaw_result.dart';

class ThermoModel {
  const ThermoModel();

  static const double safeTargetF = 41;
  static const double phaseChangeTempF = 32;
  static const double phaseBandStartF = 31.25;
  static const double phaseBandEndF = 33.75;

  ThawResult estimateThaw({
    required double ambientFridgeTempF,
    required double initialMeatTempF,
    required double thicknessInches,
    required MeatType meatType,
  }) {
    final clampedAmbient = ambientFridgeTempF.clamp(33.0, 45.0);
    final clampedInitial = initialMeatTempF.clamp(-20.0, 40.0);
    final clampedThickness = thicknessInches.clamp(0.5, 6.0);
    final points = <TemperaturePoint>[];
    final totalHours = _simulationWindow(clampedThickness, meatType);
    const timeStepMinutes = 5;
    const timeStepHours = timeStepMinutes / 60;
    final frozenK = _coolingCoefficient(
      thicknessInches: clampedThickness,
      meatType: meatType,
      ambientFridgeTempF: clampedAmbient,
      initialMeatTempF: clampedInitial,
      stageFactor: 0.72,
    );
    final thawedK = _coolingCoefficient(
      thicknessInches: clampedThickness,
      meatType: meatType,
      ambientFridgeTempF: clampedAmbient,
      initialMeatTempF: clampedInitial,
      stageFactor: 1.1,
    );
    final latentBuffer = _latentHeatBuffer(
      thicknessInches: clampedThickness,
      meatType: meatType,
      ambientFridgeTempF: clampedAmbient,
    );

    var currentTemp = clampedInitial.toDouble();
    var phaseBufferRemaining = latentBuffer;
    double? safeHour;
    double? phaseStartHour;
    double? phaseEndHour;
    double peakTemperature = currentTemp;

    for (var minute = 0; minute <= totalHours * 60; minute += timeStepMinutes) {
      final hours = minute / 60;
      points.add(TemperaturePoint(hours: hours, temperatureF: currentTemp));
      peakTemperature = math.max(peakTemperature, currentTemp);

      if (phaseStartHour == null && currentTemp >= phaseBandStartF) {
        phaseStartHour = hours;
      }

      if (phaseEndHour == null &&
          phaseStartHour != null &&
          phaseBufferRemaining <= 0 &&
          currentTemp >= phaseBandEndF) {
        phaseEndHour = hours;
      }

      if (safeHour == null && currentTemp >= safeTargetF) {
        safeHour = hours;
        break;
      }

      currentTemp = _simulateNextStep(
        currentTempF: currentTemp,
        ambientFridgeTempF: clampedAmbient,
        frozenK: frozenK,
        thawedK: thawedK,
        timeStepHours: timeStepHours,
        phaseBufferRemaining: phaseBufferRemaining,
      );

      if (currentTemp >= phaseBandStartF && phaseBufferRemaining > 0) {
        phaseBufferRemaining =
            math.max(0, phaseBufferRemaining - _phaseEnergySpent(timeStepHours));
      }
    }

    return ThawResult(
      hoursToSafeTemp: safeHour ?? totalHours.toDouble(),
      points: points,
      safeTargetReached: safeHour != null,
      hoursToPhaseStart: phaseStartHour ?? 0,
      hoursToPhaseEnd: phaseEndHour ?? (phaseStartHour ?? 0),
      plateauDurationHours: phaseStartHour != null && phaseEndHour != null
          ? phaseEndHour - phaseStartHour
          : 0,
      simulationHours: points.isEmpty ? 0 : points.last.hours,
      peakTemperatureF: peakTemperature,
    );
  }

  double calculateTemperature({
    required double timeHours,
    required double ambientFridgeTempF,
    required double initialMeatTempF,
    required double coolingCoefficient,
  }) {
    return ambientFridgeTempF +
        (initialMeatTempF - ambientFridgeTempF) *
            math.exp(-coolingCoefficient * timeHours);
  }

  double _simulateNextStep({
    required double currentTempF,
    required double ambientFridgeTempF,
    required double frozenK,
    required double thawedK,
    required double timeStepHours,
    required double phaseBufferRemaining,
  }) {
    final isInPhaseBand =
        currentTempF >= phaseBandStartF && currentTempF <= phaseBandEndF;

    // We still use Newton's law as the base mechanism, but we swap coefficients
    // across thawing stages and heavily dampen progress near 32 F to mimic the
    // latent heat absorbed during phase change.
    var effectiveK = currentTempF < phaseBandStartF ? frozenK : thawedK;

    if (isInPhaseBand || phaseBufferRemaining > 0) {
      final distanceFromCenter = (currentTempF - phaseChangeTempF).abs();
      final plateauBias = (1 - (distanceFromCenter / 2).clamp(0, 1)) * 0.88;
      effectiveK *= math.max(0.08, 0.28 - plateauBias * 0.18);
    }

    final nextTemp = ambientFridgeTempF +
        (currentTempF - ambientFridgeTempF) *
            math.exp(-effectiveK * timeStepHours);

    if (isInPhaseBand || phaseBufferRemaining > 0) {
      final limitedRise = currentTempF + math.min(nextTemp - currentTempF, 0.18);
      return limitedRise.clamp(currentTempF - 1, ambientFridgeTempF);
    }

    return nextTemp.clamp(currentTempF - 1, ambientFridgeTempF);
  }

  double _coolingCoefficient({
    required double thicknessInches,
    required MeatType meatType,
    required double ambientFridgeTempF,
    required double initialMeatTempF,
    required double stageFactor,
  }) {
    final normalizedThickness = thicknessInches.clamp(0.5, 6.0);
    final fridgeDelta = (ambientFridgeTempF - initialMeatTempF).abs().clamp(20, 60);
    final deltaFactor = 0.9 + (fridgeDelta / 100);
    return ((0.34 / normalizedThickness) *
            meatType.conductionFactor *
            deltaFactor *
            stageFactor)
        .clamp(0.05, 1.2);
  }

  double _latentHeatBuffer({
    required double thicknessInches,
    required MeatType meatType,
    required double ambientFridgeTempF,
  }) {
    final ambientFactor = (45 - ambientFridgeTempF).clamp(0, 12) / 12;
    return (0.9 + thicknessInches * 0.85 + ambientFactor * 0.75) /
        meatType.conductionFactor;
  }

  double _phaseEnergySpent(double timeStepHours) => timeStepHours * 0.42;

  int _simulationWindow(double thicknessInches, MeatType meatType) {
    final baseline = 14 + (thicknessInches * 7).round();
    final proteinAdjustment = (3 / meatType.conductionFactor).round();
    return math.max(16, baseline + proteinAdjustment);
  }
}
