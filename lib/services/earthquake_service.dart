import 'dart:convert';
import 'package:http/http.dart' as http;

class EarthquakeService {
  final String _baseUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary";
  
  /// Lekérdezés földrengésekre.
  /// [magnitude] lehet például "all_day", "significant_month", stb.
  Future<List<dynamic>> fetchEarthquakes(String magnitude) async {
    final Uri url = Uri.parse("$_baseUrl/$magnitude.geojson");

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['features'] ?? [];
      } else {
        throw Exception("Hiba történt a földrengési adatok lekérése során: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Nem sikerült lekérni a földrengési adatokat: $error");
    }
  }
}
