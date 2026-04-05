import '../models/temperature_unit.dart';

String formatTemperature(
  double valueF, {
  TemperatureUnit unit = TemperatureUnit.fahrenheit,
}) {
  final converted = unit.fromFahrenheit(valueF);
  final decimals = unit == TemperatureUnit.kelvin ? 2 : 1;
  return '${converted.toStringAsFixed(decimals)}${unit.symbol}';
}

double convertTemperature(
  double valueF, {
  TemperatureUnit unit = TemperatureUnit.fahrenheit,
}) {
  return unit.fromFahrenheit(valueF);
}

String formatHours(double value) => '${value.toStringAsFixed(1)} hrs';

String formatCompactDuration(double value) {
  final totalMinutes = (value * 60).round();
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  if (hours == 0) {
    return '${minutes}m';
  }

  if (minutes == 0) {
    return '${hours}h';
  }

  return '${hours}h ${minutes}m';
}

String formatShortNumber(double value) => value.toStringAsFixed(1);
