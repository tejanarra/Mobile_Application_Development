import 'package:flutter/material.dart';
import 'package:mp5/models/weather_model.dart';
import 'package:mp5/utils/location.dart';
import 'package:mp5/views/weather_page.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onAdd;

  const SearchPage({
    Key? key,
    this.onAdd,
  }) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final WeatherService weatherService =
      WeatherService('990e9f887ba17b46151ebd09d0c27c92');
  List<String> savedLocations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  void _searchWeather() async {
    WeatherData weatherData =
        await weatherService.fetchWeather(searchController.text);
    final locationdata = weatherData.location['name'];
    if (!mounted) return;
    if (weatherData.current['temperature'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherPage(
            weatherData: weatherData,
            onAddPressed: () {
              addLocation(locationdata);
              setState(() {});
              widget.onAdd!();
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid location. Please enter a valid location.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Search Locations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Enter location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchWeather,
              child: const Text('Search Weather'),
            ),
          ],
        ),
      ),
    );
  }

  void addLocation(String location) async {
    await Location.addLocation(location, savedLocations);
  }

  Future<void> _loadSavedLocations() async {
    savedLocations = await Location.loadSavedLocations();
    setState(() {});
  }
}
