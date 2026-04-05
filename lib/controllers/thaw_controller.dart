import 'package:flutter/material.dart';

import '../models/meat_type.dart';
import '../models/temperature_point.dart';
import '../models/temperature_unit.dart';
import '../models/thermo_model.dart';
import '../models/thaw_result.dart';

class ThawController extends ChangeNotifier {
  ThawController({ThermoModel? thermoModel})
      : _thermoModel = thermoModel ?? const ThermoModel();

  final ThermoModel _thermoModel;

  double _ambientFridgeTempF = 37;
  double _initialMeatTempF = 5;
  double _thicknessInches = 1.5;
  MeatType _meatType = MeatType.chicken;
  TemperatureUnit _temperatureUnit = TemperatureUnit.fahrenheit;
  ThemeMode _themeMode = ThemeMode.system;

  ThawResult _result = const ThawResult.empty();

  ThawResult get result => _result;
  List<TemperaturePoint> get points => _result.points;
  double get ambientFridgeTempF => _ambientFridgeTempF;
  double get initialMeatTempF => _initialMeatTempF;
  double get thicknessInches => _thicknessInches;
  MeatType get meatType => _meatType;
  TemperatureUnit get temperatureUnit => _temperatureUnit;
  ThemeMode get themeMode => _themeMode;
  double get estimatedHours => _result.hoursToSafeTemp;
  double get chartMaxHours =>
      points.isEmpty ? 12 : points.last.hours.clamp(6, 48).toDouble();
  double get phaseStartHours => _result.hoursToPhaseStart;
  double get plateauDurationHours => _result.plateauDurationHours;
  bool get safeTargetReached => _result.safeTargetReached;
  double get ambientFridgeTempDisplay =>
      _temperatureUnit.fromFahrenheit(_ambientFridgeTempF);
  double get initialMeatTempDisplay =>
      _temperatureUnit.fromFahrenheit(_initialMeatTempF);
  double get fridgeMinDisplay => _temperatureUnit.fromFahrenheit(33);
  double get fridgeMaxDisplay => _temperatureUnit.fromFahrenheit(45);
  double get meatMinDisplay => _temperatureUnit.fromFahrenheit(-10);
  double get meatMaxDisplay => _temperatureUnit.fromFahrenheit(32);
  double get frozenThresholdDisplay => _temperatureUnit.fromFahrenheit(32);
  double get safeThresholdDisplay => _temperatureUnit.fromFahrenheit(41);
  List<TemperaturePoint> get displayPoints => _result.points
      .map(
        (point) => TemperaturePoint(
          hours: point.hours,
          temperatureF:
              _temperatureUnit.fromFahrenheit(point.temperatureF),
        ),
      )
      .toList();

  String get safetySummary {
    if (_result.safeTargetReached) {
      return 'The model reaches the 41°F safe thaw target while staying in refrigerator conditions.';
    }
    return 'The current simulation window does not reach 41°F. Try a thinner cut or a warmer fridge setting.';
  }

  void updateAmbientFridgeTemp(double value) {
    _ambientFridgeTempF = value.clamp(33.0, 45.0);
    recalculate();
  }

  void updateAmbientFridgeTempDisplay(double value) {
    _ambientFridgeTempF =
        _temperatureUnit.toFahrenheit(value).clamp(33.0, 45.0);
    recalculate();
  }

  void updateInitialMeatTemp(double value) {
    _initialMeatTempF = value.clamp(-10.0, 32.0);
    recalculate();
  }

  void updateInitialMeatTempDisplay(double value) {
    _initialMeatTempF =
        _temperatureUnit.toFahrenheit(value).clamp(-10.0, 32.0);
    recalculate();
  }

  void updateThickness(double value) {
    _thicknessInches = value.clamp(0.5, 6.0);
    recalculate();
  }

  void updateMeatType(MeatType value) {
    _meatType = value;
    recalculate();
  }

  void updateTemperatureUnit(TemperatureUnit value) {
    if (_temperatureUnit == value) {
      return;
    }
    _temperatureUnit = value;
    notifyListeners();
  }

  void cycleThemeMode() {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void recalculate() {
    _result = _thermoModel.estimateThaw(
      ambientFridgeTempF: _ambientFridgeTempF,
      initialMeatTempF: _initialMeatTempF,
      thicknessInches: _thicknessInches,
      meatType: _meatType,
    );
    notifyListeners();
  }
}
