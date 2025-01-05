import 'package:flutter/material.dart'; // Importing the Flutter Material library for UI components.
import 'package:provider/provider.dart'; // Importing the Provider package for state management.
import 'package:intl/intl.dart'; // Importing the intl package for date formatting.
import '../../business_logic/blocs/WeatherBloc.dart'; // Importing the WeatherBloc class.
import '../../data/models/WeatherModel.dart'; // Importing the WeatherModel class.
import '../../data/repositories/WeatherRepository.dart'; // Importing the WeatherRepository class.

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(
            color: Colors.white, // Set the text color to white.
          ),
        ),
        centerTitle: true, // Center the title text.
        backgroundColor: Colors.pinkAccent, // Set the background color to pinkAccent.
      ),
      body: ChangeNotifierProvider(
        create: (_) => WeatherBloc(WeatherRepository()), // Providing the WeatherBloc.
        child: WeatherView(), // Displaying the WeatherView.
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Adding padding around the content.
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure minimal height usage.
          crossAxisAlignment: CrossAxisAlignment.stretch, // Expand to fill width.
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your city',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final city = context.read<WeatherBloc>().cityController.text;
                    context.read<WeatherBloc>().fetchWeather(city);
                  },
                ),
              ),
              controller: context.read<WeatherBloc>().cityController,
              onSubmitted: (city) => context.read<WeatherBloc>().fetchWeather(city),
            ),
            const SizedBox(height: 20), // Adding space between elements.
            Consumer<WeatherBloc>(
              builder: (context, bloc, child) {
                if (bloc.isLoading) {
                  return const Center(child: CircularProgressIndicator()); // Display loading indicator.
                }
                if (bloc.errorMessage != null) {
                  return Text(
                    bloc.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ); // Display error message.
                }
                if (bloc.weather == null) {
                  return const Text(
                    'Enter your city to see weather',
                    textAlign: TextAlign.center,
                  ); // Prompt to enter city.
                } else {
                  final dailyForecasts = filterDailyForecasts(bloc.weather!.forecast);
                  return Column(
                    children: [
                      Text(
                        bloc.weather!.cityName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        bloc.weather!.description,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      getWeatherIcon(bloc.weather!.icon),
                      const SizedBox(height: 10),
                      Text(
                        '${bloc.weather!.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Weather forecast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dailyForecasts.length,
                          itemBuilder: (context, index) {
                            final day = dailyForecasts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        formatDate(day.date),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      getWeatherIcon(day.icon, size: 40),
                                      Text(
                                        '${day.temp.toStringAsFixed(1)}°C',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Forecast> filterDailyForecasts(List<Forecast> forecast) {
    final Map<String, Forecast> dailyForecasts = {};
    for (var item in forecast) {
      final date = item.date.split(' ')[0];
      if (!dailyForecasts.containsKey(date)) {
        dailyForecasts[date] = item;
      }
    }
    return dailyForecasts.values.toList();
  }

  Widget getWeatherIcon(String iconCode, {double size = 50}) {
    // Replace "xxn" with "xxd" to display day-specific icons.
    final normalizedIconCode = iconCode.replaceAll('n', 'd');

    switch (normalizedIconCode) {
      case '01d': // Clear sky.
        return Icon(Icons.wb_sunny, size: size, color: Colors.orange);
      case '02d': // Few clouds.
        return Icon(Icons.cloud_queue, size: size, color: Colors.yellow);
      case '03d': // Scattered clouds.
        return Icon(Icons.cloud, size: size, color: Colors.grey[600]);
      case '04d': // Broken clouds.
        return Icon(Icons.cloud, size: size, color: Colors.grey[800]);
      case '09d': // Shower rain.
        return Icon(Icons.grain, size: size, color: Colors.blue);
      case '10d': // Rain.
        return Icon(Icons.umbrella, size: size, color: Colors.indigo);
      case '11d': // Thunderstorm.
        return Icon(Icons.flash_on, size: size, color: Colors.yellowAccent);
      case '13d': // Snow.
        return Icon(Icons.ac_unit, size: size, color: Colors.lightBlueAccent);
      case '50d': // Fog.
        return Icon(Icons.foggy, size: size, color: Colors.grey[400]);
      default: // Default icon if code doesn't match.
        return Icon(Icons.help_outline, size: size, color: Colors.redAccent);
    }
  }

  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE d', 'en_EN').format(dateTime);
  }
}
