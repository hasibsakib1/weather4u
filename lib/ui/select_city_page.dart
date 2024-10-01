import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather4u/data/geolocation.dart';

import '../data/current_weather_controller.dart';

class SelectCityPage extends ConsumerWidget {
  const SelectCityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geoLocation = ref.watch(geoLocationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter City Name',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                ref.read(geoLocationProvider.notifier).refreshWith(value);
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                ref.read(geoLocationProvider.notifier).refreshWith(value);
              }
            },
          ),
          const SizedBox(height: 20),
          geoLocation.when(
            data: (data) {
              return Column(
                children: data
                    .map(
                      (entry) => ListTile(
                        onTap: () {
                          ref.read(geoLocationProvider.notifier).clear();
                          ref.read(currentWeatherProvider((entry.lat, entry.lon)));
                          Navigator.pop(context);
                        },
                        title: Text(
                          entry.toString(),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
