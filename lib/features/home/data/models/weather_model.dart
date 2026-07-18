class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String description;
  final String main;
  final List<DailyWeather> dailyForecast;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.main,
    required this.dailyForecast,
  });

  factory WeatherModel.fromOpenMeteoJson(Map<String, dynamic> json) {
    final current = json["current"] ?? {};
    final daily = json["daily"] ?? {};
    final weatherCode = current["weather_code"] ?? 0;

    // Map WMO Weather Codes to descriptions
    final weatherInfo = _mapWmoCodeToDescription(weatherCode);

    final List<DailyWeather> forecast = [];
    if (daily["time"] != null && daily["temperature_2m_max"] != null) {
      final List times = daily["time"];
      for (int i = 0; i < times.length; i++) {
        forecast.add(DailyWeather(
          tempMax: (daily["temperature_2m_max"][i] ?? 0).toDouble(),
          tempMin: (daily["temperature_2m_min"][i] ?? 0).toDouble(),
          description: _mapWmoCodeToDescription(daily["weather_code"]?[i] ?? 0)["description"]!,
          main: _mapWmoCodeToDescription(daily["weather_code"]?[i] ?? 0)["main"]!,
          dt: (DateTime.tryParse(times[i])?.millisecondsSinceEpoch ?? 0) ~/ 1000,
        ));
      }
    }

    return WeatherModel(
      temperature: (current["temperature_2m"] ?? 0).toDouble(),
      humidity: (current["relative_humidity_2m"] ?? 0).toInt(),
      windSpeed: (current["wind_speed_10m"] ?? 0).toDouble(),
      description: weatherInfo["description"]!,
      main: weatherInfo["main"]!,
      dailyForecast: forecast.take(5).toList(),
    );
  }

  static Map<String, String> _mapWmoCodeToDescription(int code) {
    switch (code) {
      case 0:
        return {"main": "Clear", "description": "Clear sky"};
      case 1:
      case 2:
      case 3:
        return {"main": "Clouds", "description": "Partly cloudy"};
      case 45:
      case 48:
        return {"main": "Fog", "description": "Foggy"};
      case 51:
      case 53:
      case 55:
        return {"main": "Drizzle", "description": "Drizzle"};
      case 61:
      case 63:
      case 65:
        return {"main": "Rain", "description": "Rainy"};
      case 71:
      case 73:
      case 75:
        return {"main": "Snow", "description": "Snowy"};
      case 80:
      case 81:
      case 82:
        return {"main": "Rain", "description": "Rain showers"};
      case 95:
      case 96:
      case 99:
        return {"main": "Thunderstorm", "description": "Thunderstorm"};
      default:
        return {"main": "Clear", "description": "Clear sky"};
    }
  }
}

class DailyWeather {
  final double tempMax;
  final double tempMin;
  final String description;
  final String main;
  final int dt;

  DailyWeather({
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.main,
    required this.dt,
  });
}
