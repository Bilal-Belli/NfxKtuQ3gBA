class WeatherModel {
  // Defining the properties of the WeatherModel class.
  final String cityName;
  final String description;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String icon;
  final List<Forecast> forecast;

  // Constructor for the WeatherModel class.
  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.forecast,
  });

  // Factory constructor to create a WeatherModel instance from a JSON map.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'], // Retrieving the city name from the JSON.
      description: json['weather'][0]['description'], // Retrieving the weather description from the JSON.
      temperature: (json['main']['temp'] as num).toDouble(), // Retrieving and converting the temperature from the JSON.
      humidity: (json['main']['humidity'] as num).toDouble(), // Retrieving and converting the humidity from the JSON.
      windSpeed: (json['wind']['speed'] as num).toDouble(), // Retrieving and converting the wind speed from the JSON.
      icon: json['weather'][0]['icon'], // Retrieving the weather icon from the JSON.
      forecast: (json['forecast'] as List)
          .map((item) => Forecast.fromJson(item)) // Mapping the forecast list from JSON.
          .toList(), // Converting the mapped items to a list.
    );
  }
}

class Forecast {
  // Defining the properties of the Forecast class.
  final String date;
  final double temp;
  final String icon;
  final double humidity;
  final double windSpeed;

  // Constructor for the Forecast class.
  Forecast({
    required this.date,
    required this.temp,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  // Factory constructor to create a Forecast instance from a JSON map.
  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: json['dt_txt'], // Retrieving the date from the JSON.
      temp: (json['main']['temp'] as num).toDouble(), // Retrieving and converting the temperature from the JSON.
      icon: json['weather'][0]['icon'], // Retrieving the weather icon from the JSON.
      humidity: (json['main']['humidity'] as num).toDouble(), // Retrieving and converting the humidity from the JSON.
      windSpeed: (json['wind']['speed'] as num).toDouble(), // Retrieving and converting the wind speed from the JSON.
    );
  }
}