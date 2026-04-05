class TemperaturePoint {
  const TemperaturePoint({
    required this.hours,
    required this.temperatureF,
  });

  final double hours;
  final double temperatureF;

  bool get isFrozen => temperatureF < 32;
  bool get isSafeThawBand => temperatureF >= 32 && temperatureF <= 41;
  bool get isDangerZone => temperatureF > 41;
}
