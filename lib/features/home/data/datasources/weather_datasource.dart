import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherDatasource {
  // Open-Meteo is a free weather API that doesn't require an API key.
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherModel> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Construct the URL with all necessary parameters for current, hourly, and daily data
      final String url =
          '$baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&hourly=temperature_2m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';
      print('Weather API URL: $url'); // Debugging line

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Weather request timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromOpenMeteoJson(json);
      } else {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
