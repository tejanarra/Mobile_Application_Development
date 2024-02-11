import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final Map<String, dynamic> request;
  final Map<String, dynamic> location;
  final Map<String, dynamic> current;

  WeatherData({
    required this.request,
    required this.location,
    required this.current,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      request: json['request'] ?? {},
      location: json['location'] ?? {},
      current: json['current'] ?? {},
    );
  }
}

class WeatherService {
  final String apiKey;
  late final String apiUrl = 'http://api.weatherstack.com/current';
  WeatherService(this.apiKey);
  Future<WeatherData> fetchWeather(String location) async {
    if (location.isEmpty) {
      throw Exception('Location cannot be empty');
    }
    final uri = Uri.parse('$apiUrl?access_key=$apiKey&query=$location');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData != null) {
        return WeatherData.fromJson(jsonData);
      } else {
        throw Exception('Invalid data received for weather');
      }
    } else {
      throw Exception(
          'Failed to load weather data (Status: ${response.statusCode}):');
    }
  }
}
