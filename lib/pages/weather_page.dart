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
      case 'Clouds':
      case 'Mist':
      case 'Smoke':
      case 'Haze':
      case 'Dust':
      case 'Fog':
        return 'assets/cloud.json';
      case 'Rain':
        return 'assets/rain.json';
      case 'Drizzle':
      case 'Shower Rain':
        return 'assets/rain.json';
      case 'Thunderstorm':
        return 'assets/thunder.json';
      case 'Clear':
        return 'assets/sun.json';
      default:
        return 'assets/sunny.json';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                Icons.location_on,
                size: 60.0,
                color: Colors.black26,
              ),

              // const SizedBox(width: 10.0),

              //city name
              Text(
                _weather?.cityName ?? "loading city...",
                style: GoogleFonts.bebasNeue(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
                ],
              ),

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
