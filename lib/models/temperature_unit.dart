enum TemperatureUnit {
  fahrenheit('Fahrenheit', '°F'),
  celsius('Celsius', '°C'),
  kelvin('Kelvin', 'K');

  const TemperatureUnit(this.label, this.symbol);

  final String label;
  final String symbol;

  double fromFahrenheit(double valueF) {
    switch (this) {
      case TemperatureUnit.fahrenheit:
        return valueF;
      case TemperatureUnit.celsius:
        return (valueF - 32) / 1.8;
      case TemperatureUnit.kelvin:
        return (valueF - 32) / 1.8 + 273.15;
    }
  }

  double toFahrenheit(double value) {
    switch (this) {
      case TemperatureUnit.fahrenheit:
        return value;
      case TemperatureUnit.celsius:
        return value * 1.8 + 32;
      case TemperatureUnit.kelvin:
        return (value - 273.15) * 1.8 + 32;
    }
  }
}
