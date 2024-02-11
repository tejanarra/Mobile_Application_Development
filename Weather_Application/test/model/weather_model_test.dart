import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/weather_model.dart';

void main() {
  String apiKey = '990e9f887ba17b46151ebd09d0c27c92';
  group('WeatherData', () {
    test('fromJson should create WeatherData object from valid JSON', () {
      final jsonData = {
        'request': {'query': 'London'},
        'location': {'name': 'London'},
        'current': {'temperature': '11'},
      };

      final weatherData = WeatherData.fromJson(jsonData);

      expect(weatherData.request, equals(jsonData['request']));
      expect(weatherData.location, equals(jsonData['location']));
      expect(weatherData.current, equals(jsonData['current']));
    });

    test('fromJson should handle null JSON values', () {
      final weatherData = WeatherData.fromJson({});

      expect(weatherData.request, equals({}));
      expect(weatherData.location, equals({}));
      expect(weatherData.current, equals({}));
    });
  });

  group('WeatherService', () {
    test('fetchWeather should return WeatherData for a valid location',
        () async {
      final weatherService = WeatherService(apiKey);
      final weatherData = await weatherService.fetchWeather('London');

      expect(weatherData, isA<WeatherData>());
      expect(weatherData.request, isNotEmpty);
      expect(weatherData.location, isNotEmpty);
      expect(weatherData.current, isNotEmpty);
    });

    test('fetchWeather should return null data for invalid location', () async {
      final weatherService = WeatherService(apiKey);
      final weatherData = await weatherService.fetchWeather('hhhhhhh');

      expect(weatherData, isA<WeatherData>());
      expect(weatherData.request, isEmpty);
      expect(weatherData.location, isEmpty);
      expect(weatherData.current, isEmpty);
    });

    test('fetchWeather should throw an exception for an empty location', () {
      final weatherService = WeatherService(apiKey);
      expect(() => weatherService.fetchWeather(''), throwsA(isA<Exception>()));
    });
  });
}
