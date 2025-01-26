import 'package:flutter/material.dart';
import '../services/air_quality_service.dart';

class AirQualityTab extends StatefulWidget {
  const AirQualityTab({super.key});

  @override
  _AirQualityTabState createState() => _AirQualityTabState();
}

class _AirQualityTabState extends State<AirQualityTab> {
  final AirQualityService _airQualityService = AirQualityService();
  String _airQualityInfo = "Levegőminőségi adatok betöltése...";

  @override
  void initState() {
    super.initState();
    _getAirQuality();
  }

  Future<void> _getAirQuality() async {
    try {
      final airQualityData = await _airQualityService.fetchAirQuality(47.4979, 19.0402); // Budapest koordinátái
      setState(() {
        _airQualityInfo = "Levegőminőség:\n"
            "CO: ${airQualityData['list'][0]['components']['co']} µg/m³\n"
            "NO: ${airQualityData['list'][0]['components']['no']} µg/m³\n"
            "PM2.5: ${airQualityData['list'][0]['components']['pm2_5']} µg/m³\n"
            "PM10: ${airQualityData['list'][0]['components']['pm10']} µg/m³\n"
            "AQI Index: ${airQualityData['list'][0]['main']['aqi']}";
      });
    } catch (e) {
      setState(() {
        _airQualityInfo = "Hiba történt: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Levegőminőség"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _airQualityInfo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
