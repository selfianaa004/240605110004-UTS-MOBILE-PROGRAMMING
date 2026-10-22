
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService();

  late Future<Weather> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = weatherService.fetchWeather();
  }

  void refreshWeather() {
    setState(() {
      weatherFuture = weatherService.fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2878D0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: refreshWeather,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang cuaca',
          ),
        ],
      ),
      body: FutureBuilder<Weather>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sedang mengambil data cuaca...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat data cuaca',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Periksa koneksi internet kamu, lalu coba lagi.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: refreshWeather,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Data cuaca belum tersedia.'),
            );
          }

          final weather = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => refreshWeather(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Cuaca Saat Ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Jakarta, Indonesia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2878D0),
                        Color(0xFF62B6F5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        weather.weatherCode == 0
                            ? Icons.wb_sunny
                            : weather.weatherCode >= 51
                            ? Icons.water_drop
                            : Icons.cloud,
                        size: 76,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.weatherDescription,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Waktu data: ${weather.time}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Detail Cuaca',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _WeatherDetailCard(
                        icon: Icons.water_drop,
                        title: 'Kelembapan',
                        value: '${weather.humidity}%',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WeatherDetailCard(
                        icon: Icons.air,
                        title: 'Kecepatan Angin',
                        value:
                        '${weather.windSpeed.toStringAsFixed(1)} km/j',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Data diperbarui langsung dari Open-Meteo API.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _WeatherDetailCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2878D0), size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
