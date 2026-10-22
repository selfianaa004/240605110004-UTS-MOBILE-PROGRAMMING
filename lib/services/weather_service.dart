
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String apiUrl =
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=-6.221441'
      '&longitude=106.78094'
      '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m';

  Future<Weather> fetchWeather() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;

      return Weather.fromJson(data);
    } else {
      throw Exception(
        'Gagal mengambil data cuaca. '
            'Kode status: ${response.statusCode}',
      );
    }
  }
}
