import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../data/air_quality_controller.dart';
import '../data/current_city.dart';
import '../data/current_weather_controller.dart';
import '../data/geolocation.dart';
import '../data/model/current_weather_model.dart';
import 'select_city_page.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  Widget build(BuildContext context) {
    final currentWeather = ref.watch(currentWeatherProvider);
    final airQuality = ref.watch(currentAirQualityProvider);
    final city = ref.watch(currentCityProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on),
            city.when(
              data: (data) {
                return GestureDetector(
                  onTap: () {
                    ref.read(geoLocationProvider.notifier).clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectCityPage(),
                      ),
                    );
                  },
                  child: data.state == null
                      ? Text("${data.name}, ${data.country}")
                      : Text("${data.name}, ${data.state}, ${data.country}"),
                );
              },
              loading: () => Shimmer.fromColors(
                baseColor: const Color.fromARGB(179, 255, 255, 255),
                highlightColor: Colors.grey,
                child: Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              error: (error, stackTrace) {
                debugPrint('Error: $error');
                return Text('Error: $error $stackTrace');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => showCurrentWeather(data),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          airQuality.when(
            data: (data) => Text('Air Quality: ${data.toString()}'),
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }

  Widget showCurrentWeather(CurrentWeatherModel current) {
    return Column(
      children: [
        // Text('Current Weather: ${current.toString()}'),
        Text(
          '${current.main!.temp!.toStringAsFixed(0)}°C',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          (() {
            String description = current.weather![0].description!;
            return description[0].toUpperCase() + description.substring(1);
          })(),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          'Feels like ${current.main!.feelsLike!.toStringAsFixed(0)}°C',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
