import 'package:shared_preferences/shared_preferences.dart';

class Location {
  static Future<List<String>> loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('savedLocations') ?? [];
  }

  static Future<void> saveLocationsToPrefs(List<String> locations) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedLocations', locations);
  }

  static Future<void> addLocation(
      String location, List<String> savedLocations) async {
    if (!savedLocations.contains(location)) {
      savedLocations.add(location);
      await saveLocationsToPrefs(savedLocations);
    }
  }

  static Future<void> removeLocation(
      String location, List<String> savedLocations) async {
    savedLocations.remove(location);
    await saveLocationsToPrefs(savedLocations);
  }
}
