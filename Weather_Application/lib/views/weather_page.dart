import 'package:flutter/material.dart';
import 'package:mp5/models/weather_model.dart';

class WeatherPage extends StatelessWidget {
  final WeatherData? weatherData;
  final VoidCallback? onAddPressed;

  const WeatherPage({
    Key? key,
    required this.weatherData,
    this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Weather Details'),
        centerTitle: true,
        actions: [
          if (onAddPressed != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (onAddPressed != null) {
                  onAddPressed!();
                }
              },
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLocationHeader(weatherData?.location['name'] ?? ''),
              const SizedBox(height: 16),
              if (weatherData != null)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    shrinkWrap: true,
                    children: [
                      _buildInfoCard('Temperature',
                          '${weatherData?.current['temperature']}°C'),
                      _buildInfoCard('Weather',
                          '${weatherData?.current['weather_descriptions']}'),
                      _buildInfoCard('Wind',
                          '${weatherData?.current['wind_speed']} m/s ${weatherData?.current['wind_dir']}'),
                      _buildInfoCard(
                          'Humidity', '${weatherData?.current['humidity']}%'),
                      _buildInfoCard('Pressure',
                          '${weatherData?.current['pressure']} hPa'),
                      _buildInfoCard('Observation Time',
                          '${weatherData?.current['observation_time']}'),
                      _buildInfoCard('Cloud Cover',
                          '${weatherData?.current['cloudcover']}%'),
                      _buildInfoCard('Feels Like',
                          '${weatherData?.current['feelslike']}°C'),
                      _buildInfoCard(
                          'UV Index', '${weatherData?.current['uv_index']}'),
                      _buildInfoCard('Visibility',
                          '${weatherData?.current['visibility']} km'),
                    ],
                  ),
                ),
              if (weatherData == null)
                const Text('No weather data available. Try searching again.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader(String locationName) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (locationName.isNotEmpty)
            Text(
              locationName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(width: 16),
          if (weatherData != null &&
              weatherData?.current['weather_icons'] != null)
            Image.network(
              weatherData?.current['weather_icons'].first ?? '',
              height: 50,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      color: const Color.fromARGB(255, 219, 247, 255),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
