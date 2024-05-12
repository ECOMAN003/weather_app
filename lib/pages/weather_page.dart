import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('dafa19e78206ea417828ebf49bee611d');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/loading.json'; //default animation

    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on,
            size: 18.0,
            color: Colors.black26,
            ),
            const SizedBox(height: 5.0,),

            //city name
            Text(_weather?.cityName ?? "loading city...",
            style: GoogleFonts.bebasNeue(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black45
            ),
            ),
            const SizedBox(height: 150.0,),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            const SizedBox(height: 150.0,),

            //temperature
            Text('${_weather?.temperature.round()}' 'º',
              style: GoogleFonts.bebasNeue(
                color: Colors.black54,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            //weather condition
            Text(_weather?.mainCondition ?? "LOADING CONDITION")
          ],
        ),
      ),
    );
  }
}
