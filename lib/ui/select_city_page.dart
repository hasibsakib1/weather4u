import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather4u/data/model/city_model.dart';

import '../data/current_city.dart';
import '../data/current_weather_controller.dart';
import '../data/geolocation.dart';


class SelectCityPage extends ConsumerStatefulWidget {
  const SelectCityPage({super.key});

  @override
  ConsumerState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends ConsumerState<SelectCityPage> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geoLocation = ref.watch(geoLocationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  // border: InputBorder.none,
                  hintText: 'Enter City Name',
                  label: Text("Search for a city"),
                ),
                onChanged: (value) {
                  _onSearchChanged(value);
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
                              debugPrint('Selected: $entry');
                              ref.read(currentWeatherProvider.notifier).refreshWith(entry.lat, entry.lon);
                              final city = CityModel(name: entry.name, country: entry.country, state: entry.state);
                              ref.read(currentCityProvider.notifier).updateCity(city);
                              Navigator.pop(context);
                              ref.read(geoLocationProvider.notifier).clear();
                            },
                            title: Text(
                              entry.name,
                            ),
                            subtitle: entry.state != null
                                ? Text('${entry.state}, ${entry.country}')
                                : Text(entry.country),
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
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (value.isNotEmpty) {
        ref.read(geoLocationProvider.notifier).refreshWith(value);
      }
    });
  }
}
