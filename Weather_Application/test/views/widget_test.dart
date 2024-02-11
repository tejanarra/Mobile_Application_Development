import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/weather_model.dart';
import 'package:mp5/views/home_screen.dart';
import 'package:mp5/views/search_screen.dart';
import 'package:mp5/views/weather_page.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('Renders HomeScreen with no saved locations',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('SearchPage Widget Tests', () {
    testWidgets('Renders SearchPage with proper UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SearchPage()));
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('WeatherPage Widget Tests', () {
    final WeatherData weatherData = WeatherData(
      request: {},
      location: {'name': 'Test City'},
      current: {
        'temperature': 20,
        'weather_descriptions': ['Sunny']
      },
    );

    testWidgets('Renders WeatherPage with proper UI and data',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: WeatherPage(weatherData: weatherData)));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherPage), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('20°C'), findsOneWidget);
      expect(find.text('Sunny'), findsOneWidget);
    });

    testWidgets('Renders WeatherPage with no weather data',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: WeatherPage(weatherData: null)));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherPage), findsOneWidget);
      expect(find.text('No weather data available. Try searching again.'),
          findsOneWidget);
    });

    testWidgets('Renders WeatherPage with additional weather data',
        (WidgetTester tester) async {
      final WeatherData weatherData = WeatherData(
        request: {},
        location: {'name': 'Test City'},
        current: {
          'temperature': 20,
          'weather_descriptions': ['Sunny']
        },
      );

      await tester
          .pumpWidget(MaterialApp(home: WeatherPage(weatherData: weatherData)));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherPage), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('20°C'), findsOneWidget);
      expect(find.text('Sunny'), findsOneWidget);
    });
  });
}
