import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final currentWeather = ref.watch(currentWeatherProvider((57.7749, -122.4194)));
    final geolocation = ref.watch(geoLocationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Service'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text('Current Weather: ${data.toString()}'),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          geolocation.when(
            data: (data) {
              return Column(
                children: data.map((e) => Text(e.toString())).toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(geoLocationProvider.notifier).clear();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectCityPage()));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}