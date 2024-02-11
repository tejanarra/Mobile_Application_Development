import 'package:flutter/material.dart';
import 'package:mp5/models/weather_model.dart';
import 'package:mp5/utils/location.dart';
import 'package:mp5/views/weather_page.dart';
import 'package:mp5/views/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService =
      WeatherService('990e9f887ba17b46151ebd09d0c27c92');
  List<String> savedLocations = [];
  List<WeatherData> weatherDataList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    savedLocations = await Location.loadSavedLocations();
    setState(() {});
    await _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    weatherDataList.clear();
    for (var location in savedLocations) {
      WeatherData weatherData = await weatherService.fetchWeather(location);
      setState(() {
        weatherDataList.add(weatherData);
      });
    }
  }

  void _navigateToWeatherDetails(String location, WeatherData weatherData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherPage(
          weatherData: weatherData,
          onAddPressed: () {
            _loadSavedLocations();
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadSavedLocations();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(onAdd: _loadSavedLocations),
            ),
          );
        },
        backgroundColor: Colors.blue[200],
        child: const Icon(Icons.search),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: savedLocations.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(savedLocations[index]),
            onDismissed: (direction) {
              _removeLocation(savedLocations[index]);
            },
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: Card(
              color: Colors.green[100],
              elevation: 4.0,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      savedLocations[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (weatherDataList.isNotEmpty &&
                        index < weatherDataList.length &&
                        weatherDataList[index]
                            .current
                            .containsKey('temperature'))
                      Text(
                        '${weatherDataList[index].current['temperature']}°C',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                onTap: () {
                  _navigateToWeatherDetails(
                    savedLocations[index],
                    weatherDataList[index],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _removeLocation(String location) {
    setState(() {
      savedLocations.remove(location);
    });
    _fetchWeatherData();
    Location.removeLocation(location, savedLocations);
  }
}
