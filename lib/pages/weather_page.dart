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
    if (mainCondition == null) return 'assets/sunny.json'; //default animation

    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/rain.json';
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60.0,
              ),
              const Icon(
                Icons.location_on,
                size: 30.0,
                color: Colors.black26,
              ),

              //city name
              Text(
                _weather?.cityName ?? "loading city...",
                style: GoogleFonts.bebasNeue(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),

              //animation
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: Lottie.asset(
                      getWeatherAnimation(_weather?.mainCondition)),
                ),
              ),

              //temperature and weather condition
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_weather?.temperature.round()}' '°',
                    style: GoogleFonts.bebasNeue(
                      color: Colors.black54,
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  //weather condition
                  Text(
                    _weather?.mainCondition ?? "",
                    style: GoogleFonts.bebasNeue(
                      color: Colors.black26,
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 40.0,)
            ],
          ),
        ),
      ),
    );
  }
}
