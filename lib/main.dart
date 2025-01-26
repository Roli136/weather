import 'package:flutter/material.dart';
import 'services/weather_api_service.dart';
import 'earthquake_page.dart'; // Importálja a földrengési oldalt

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false, // Debug banner eltávolítása
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  WeatherHomePageState createState() => WeatherHomePageState();
}

class WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherApiService _weatherApiService = WeatherApiService();
  String _weatherInfo = "Üdvözöllek az időjárás appban!";
  String _cityName = "Gotha";
  String? _iconPath;
  final List<String> _searchHistory = [];

  Future<void> _getWeather(String cityName) async {
    try {
      final weatherData = await _weatherApiService.fetchWeather(cityName);
      setState(() {
        _weatherInfo = "Hőmérséklet: ${weatherData['main']['temp']} °C\n"
            "Leírás: ${weatherData['weather'][0]['description']}";
        _iconPath = _getWeatherIcon(weatherData['weather'][0]['main']);

        if (!_searchHistory.contains(cityName)) {
          _searchHistory.add(cityName);
        }
      });
    } catch (e) {
      setState(() {
        _weatherInfo = "Hiba történt: $e";
      });
    }
  }

  String? _getWeatherIcon(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return 'assets/images/007-sun.png';
      case 'clouds':
        return 'assets/images/004-clouds.png';
      case 'rain':
        return 'assets/images/006-heavy-rain.png';
      case 'snow':
        return 'assets/images/005-snow.png';
      case 'storm':
        return 'assets/images/002-storm.png';
      case 'windy':
        return 'assets/images/001-windy.png';
      default:
        return null;
    }
  }

  void _showCitySearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempCityName = _cityName;
        return AlertDialog(
          title: const Text("Város keresése"),
          content: TextField(
            onChanged: (value) {
              tempCityName = value;
            },
            decoration: const InputDecoration(labelText: "Város neve"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Mégse"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cityName = tempCityName;
                });
                _getWeather(_cityName);
                Navigator.of(context).pop();
              },
              child: const Text("Keresés"),
            ),
          ],
        );
      },
    );
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Előzmények törölve!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearSearchHistory,
            tooltip: "Előzmények törlése",
          ),
          IconButton(
            icon: const Icon(Icons.public), // Ikon a földrengési oldalhoz
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EarthquakePage()),
              );
            },
            tooltip: "Földrengési adatok",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/new-background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_iconPath != null)
                      Image.asset(
                        _iconPath!,
                        width: 150,
                        height: 150,
                      ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _weatherInfo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Előzmények:",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  for (var city in _searchHistory)
                    GestureDetector(
                      onTap: () {
                        _getWeather(city);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          city,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCitySearchDialog,
        backgroundColor: Colors.white,
        child: Image.asset(
          'assets/images/searching-bar.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
