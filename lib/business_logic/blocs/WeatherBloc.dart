import 'package:flutter/material.dart'; // Importing the Flutter Material library for UI components.
import '../../data/models/WeatherModel.dart'; // Importing the WeatherModel class.
import '../../data/repositories/WeatherRepository.dart'; // Importing the WeatherRepository class.

// WeatherBloc class that extends ChangeNotifier to handle state management.
class WeatherBloc extends ChangeNotifier {
  final WeatherRepository weatherRepository; // Instance of WeatherRepository to fetch weather data.
  final TextEditingController cityController = TextEditingController(); // Controller for the text field to input city name.

  WeatherModel? weather; // Nullable WeatherModel instance to store fetched weather data.
  bool isLoading = false; // Boolean to track the loading state.
  String? errorMessage; // Nullable string to store error messages.

  // Constructor for WeatherBloc, requires an instance of WeatherRepository.
  WeatherBloc(this.weatherRepository);

  // Asynchronous method to fetch weather data for a given city.
  Future<void> fetchWeather(String city) async {
    isLoading = true; // Set loading state to true.
    errorMessage = null; // Reset error message.
    notifyListeners(); // Notify listeners to update the UI.

    try {
      weather = await weatherRepository.fetchWeather(city); // Fetch weather data from the repository.
    } catch (e) {
      errorMessage = 'Error when loading weather.'; // Set error message if an exception occurs.
    } finally {
      isLoading = false; // Set loading state to false.
      notifyListeners(); // Notify listeners to update the UI.
    }
  }
}