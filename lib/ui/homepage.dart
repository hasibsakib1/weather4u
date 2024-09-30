import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/current_weather_controller.dart';
import '../services/dio_service.dart';
import '../services/location_service.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(asyncPositionProvider);
    final currentWeather = ref.watch(currentWeatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            position.when(
              data: (position) => Text('Location: ${position.latitude}, ${position.longitude}'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
            currentWeather.when(
              data: (data) => Text('Current Weather: $data'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(dioServiceProvider.notifier).addAdditionalOptions({'units': 'metric'});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}