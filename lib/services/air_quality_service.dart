import 'dart:convert';
import 'package:http/http.dart' as http;

class AirQualityService {
  final String _baseUrl = "http://api.openweathermap.org/data/2.5/air_pollution";
  final String _apiKey = "d3466a1496a36e8c89f9ad1f590b18e9"; // API kulcs

  Future<Map<String, dynamic>> fetchAirQuality(double lat, double lon) async {
    final Uri url = Uri.parse("$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Hiba történt: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Nem sikerült a levegőminőség adatainak lekérése: $e");
    }
  }
}
