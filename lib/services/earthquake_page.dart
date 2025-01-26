import 'package:flutter/material.dart';
import '../services/earthquake_service.dart';

class EarthquakePage extends StatefulWidget {
  const EarthquakePage({super.key});

  @override
  EarthquakePageState createState() => EarthquakePageState();
}

class EarthquakePageState extends State<EarthquakePage> {
  final EarthquakeService _earthquakeService = EarthquakeService();
  List<dynamic> _earthquakes = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEarthquakes();
  }

  Future<void> _fetchEarthquakes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _earthquakeService.fetchEarthquakes("all_day");

      if (data.containsKey('features') && data['features'] is List) {
        setState(() {
          _earthquakes = data['features'] as List;
        });
      } else {
        setState(() {
          _errorMessage = "Hibás API válasz: A 'features' mező hiányzik vagy hibás.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Hiba történt az adatok lekérése közben: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Földrengések'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : _earthquakes.isEmpty
                  ? const Center(
                      child: Text(
                        "Nincsenek földrengési adatok.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _earthquakes.length,
                      itemBuilder: (context, index) {
                        final quake = _earthquakes[index];
                        final timestamp = quake['properties']['time'];
                        DateTime quakeTime;

                        try {
                          if (timestamp is int) {
                            quakeTime =
                                DateTime.fromMillisecondsSinceEpoch(timestamp);
                          } else if (timestamp is String) {
                            quakeTime = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(timestamp));
                          } else {
                            quakeTime = DateTime.now();
                          }
                        } catch (e) {
                          quakeTime = DateTime.now();
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            title: Text(
                              quake['properties']['place'] ?? "Nincs adat",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Magnitúdó: ${quake['properties']['mag']?.toStringAsFixed(1) ?? "N/A"}",
                                ),
                                Text(
                                  "Időpont: $quakeTime",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
