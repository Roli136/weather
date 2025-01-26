import 'package:flutter/material.dart';
import '../services/weather_api_service.dart';

class CurrentWeatherTab extends StatefulWidget {
  const CurrentWeatherTab({super.key});

  @override
  State<CurrentWeatherTab> createState() => _CurrentWeatherTabState();
}

class _CurrentWeatherTabState extends State<CurrentWeatherTab> {
  final WeatherApiService _weatherApiService = WeatherApiService();
  String _cityName = "Gotha";
  String _weatherInfo = "Töltsd be az időjárást!";

  Future<void> _getWeather() async {
    try {
      // Javítás: fetchWeather hívása a fetchCurrentWeather helyett
      final data = await _weatherApiService.fetchWeather(_cityName);
      setState(() {
        _weatherInfo = "Hőmérséklet: ${data['main']['temp']} °C\n"
            "Leírás: ${data['weather'][0]['description']}";
      });
    } catch (e) {
      setState(() {
        _weatherInfo = "Hiba történt: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _weatherInfo,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center, // Szöveg középre igazítása
          ),
          const SizedBox(height: 20), // Térköz
          ElevatedButton(
            onPressed: _getWeather,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Frissítés",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
