import 'package:flutter/material.dart'; // Importing the Flutter Material library for UI components.
import 'package:intl/date_symbol_data_local.dart'; // Importing the intl package for date formatting.
import 'presentation/page/WeatherPage.dart'; // Importing the WeatherPage class.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensuring proper initialization of Flutter bindings.
  await initializeDateFormatting('en_EN', null); // Initializing date formatting for the 'en_EN' locale.
  runApp(const MyApp()); // Running the MyApp widget as the root of the application.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for MyApp with a constant key.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Application', // Setting the title of the application.
      theme: ThemeData(
        primarySwatch: Colors.pink, // Setting the primary color theme to pink.
      ),
      home: const WeatherPage(), // Setting the home screen of the application to WeatherPage.
    );
  }
}