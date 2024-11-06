import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../data/model/forecast_response_model.dart';

class ForecastDetailsContainer extends StatelessWidget {
  const ForecastDetailsContainer({super.key, required this.forecast});
  final ListElement forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${forecast.main!.temp!.toStringAsFixed(0)}°', style: const TextStyle(fontSize: 40),),
          Text(() {
            String description = forecast.weather![0].description;
            return description[0].toUpperCase() + description.substring(1);
          }(), style: const TextStyle(fontSize: 20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.accessibility, size: 20,),
              Text('${forecast.main!.feelsLike!.toStringAsFixed(0)}°C', style: const TextStyle(fontSize: 20),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BoxedIcon(WeatherIcons.rain, size: 20,),
              Text('${forecast.main!.humidity}%', style: const TextStyle(fontSize: 20),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BoxedIcon(WeatherIcons.humidity, size: 20,),
              Text('${forecast.main!.humidity}%', style: const TextStyle(fontSize: 20),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WindIcon(degree: forecast.wind!.deg! % 360, size: 20),
              Text('${(forecast.wind!.speed! * 3.6).toStringAsFixed(2)} Km/h', style: const TextStyle(fontSize: 20),),
            ],
          ),
        ],
      ),
    );
  }
}
