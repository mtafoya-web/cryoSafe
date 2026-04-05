import 'temperature_point.dart';

class ThawResult {
  const ThawResult({
    required this.hoursToSafeTemp,
    required this.points,
    required this.safeTargetReached,
    required this.hoursToPhaseStart,
    required this.hoursToPhaseEnd,
    required this.plateauDurationHours,
    required this.simulationHours,
    required this.peakTemperatureF,
  });

  const ThawResult.empty()
      : hoursToSafeTemp = 0,
        points = const [],
        safeTargetReached = false,
        hoursToPhaseStart = 0,
        hoursToPhaseEnd = 0,
        plateauDurationHours = 0,
        simulationHours = 0,
        peakTemperatureF = 0;

  final double hoursToSafeTemp;
  final List<TemperaturePoint> points;
  final bool safeTargetReached;
  final double hoursToPhaseStart;
  final double hoursToPhaseEnd;
  final double plateauDurationHours;
  final double simulationHours;
  final double peakTemperatureF;
}
