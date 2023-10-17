import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService("9e3e7e717c92e74eaa2ea23e9d3758cf");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get the weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (error) {
      print(error);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'thunderstorm':
        return 'assets/stormy.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //initial state
  @override
  void initState() {
    super.initState();
    //fetch weather on start up
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading City..."),

            // Lottie animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            Text("${_weather?.temperature.round()}°C"),
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
