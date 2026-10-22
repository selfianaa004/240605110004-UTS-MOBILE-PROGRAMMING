
class Weather {
  final double temperature;
  final int humidity;
  final int weatherCode;
  final double windSpeed;
  final String time;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];

    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      weatherCode: (current['weather_code'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      time: current['time'] as String,
    );
  }

  String get weatherDescription {
    if (weatherCode == 0) return 'Cerah';
    if (weatherCode == 1) return 'Cerah berawan';
    if (weatherCode == 2) return 'Berawan sebagian';
    if (weatherCode == 3) return 'Mendung';
    if ([45, 48].contains(weatherCode)) return 'Berkabut';
    if ([51, 53, 55, 56, 57].contains(weatherCode)) {
      return 'Gerimis';
    }
    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(weatherCode)) {
      return 'Hujan';
    }
    if ([71, 73, 75, 77, 85, 86].contains(weatherCode)) {
      return 'Bersalju';
    }
    if ([95, 96, 99].contains(weatherCode)) {
      return 'Badai petir';
    }
    return 'Kondisi cuaca tidak diketahui';
  }
}
