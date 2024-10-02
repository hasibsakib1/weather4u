import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/air_quality_controller.dart';
import '../data/current_city.dart';
import '../data/current_weather_controller.dart';
import '../data/geolocation.dart';
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
              loading: () => const Text('Loading...'),
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
            data: (data) => Text('Current Weather: ${data.toString()}'),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     ref.read(geoLocationProvider.notifier).clear();
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const SelectCityPage()));
      //     // location.then((value) {
      //     //   ref.read(currentWeatherProvider.notifier).refreshWith(value.lat, value.lon);
      //     // });
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }
}
