import 'dart:convert'; // Importing the dart:convert library to handle JSON encoding and decoding.
import 'package:http/http.dart' as http; // Importing the http package for making HTTP requests.
import '../models/WeatherModel.dart'; // Importing the WeatherModel class from the models directory.

class WeatherRepository {
  final String apiKey = 'eb59928bb971912d854c36c5055e313f'; // Storing the API key as a constant string.

  // Defining an asynchronous method to fetch weather data for a given city.
  Future<WeatherModel> fetchWeather(String city) async {
    // Constructing the URL for current weather data.
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=en';

    // Constructing the URL for the weather forecast data.
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=en';

    // Making an HTTP GET request to fetch current weather data.
    final response = await http.get(Uri.parse(url));

    // Making an HTTP GET request to fetch weather forecast data.
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    // Checking if both requests were successful.
    if (response.statusCode == 200 && forecastResponse.statusCode == 200) {
      // Decoding the response body from JSON format.
      final data = jsonDecode(response.body);

      // Decoding the forecast response body from JSON format.
      final forecastData = jsonDecode(forecastResponse.body);

      // Filtering the forecast data to include only future forecasts.
      data['forecast'] = forecastData['list']
          .where((item) => DateTime.parse(item['dt_txt']).isAfter(DateTime.now()))
          .toList();

      // Creating a WeatherModel instance from the combined data and returning it.
      return WeatherModel.fromJson(data);
    } else {
      // Throwing an exception if the request was not successful.
      throw Exception('Failed to load weather data');
    }
  }
}