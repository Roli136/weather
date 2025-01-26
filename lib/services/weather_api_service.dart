import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  final String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String _apiKey = "YOUR_API_KEY"; // Cseréld ki a saját kulcsodra

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final Uri url = Uri.parse("$_baseUrl?q=$cityName&appid=$_apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Hiba történt: ${response.statusCode}");
    }
  }
}
