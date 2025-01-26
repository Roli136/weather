import 'services/earthquake_service.dart';

void main() async {
  final EarthquakeService earthquakeService = EarthquakeService();
  
  try {
    final List<dynamic> earthquakes = await earthquakeService.fetchEarthquakes("all_day");
    for (var quake in earthquakes) {
      print("Földrengés helyszíne: ${quake['properties']['place']}");
      print("Magnitúdó: ${quake['properties']['mag']}");
      print("Időpont: ${DateTime.fromMillisecondsSinceEpoch(quake['properties']['time'])}");
    }
  } catch (e) {
    print("Hiba történt: $e");
  }
}
