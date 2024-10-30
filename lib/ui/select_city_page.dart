import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
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
              _buildPlatformSpecificTextField(),
              // TextField(
              //   decoration: const InputDecoration(
              //     // border: InputBorder.none,
              //     hintText: 'Enter City Name',
              //     label: Text("Search for a city"),
              //   ),
              //   onChanged: (value) {
              //     _onSearchChanged(value);
              //   },
              //   onSubmitted: (value) {
              //     if (value.isNotEmpty) {
              //       ref.read(geoLocationProvider.notifier).refreshWith(value);
              //     }
              //   },
              // ),
              const SizedBox(height: 20),
              geoLocation.when(
                data: (data) {
                  return Column(
                    children: data
                        .map(
                          (entry) => ListTile(
                            onTap: () {
                              debugPrint('Selected: $entry');
                              ref
                                  .read(currentWeatherProvider.notifier)
                                  .refreshWith(entry.lat, entry.lon);
                              final city = CityModel(
                                  name: entry.name,
                                  country: entry.country,
                                  state: entry.state);
                              ref
                                  .read(currentCityProvider.notifier)
                                  .updateCity(city);
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
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.grey,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        5,
                        (index) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 30,
                              margin: const EdgeInsets.all(5),
                              color: Colors.white,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 24,
                              margin: const EdgeInsets.all(5),
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) => Text('Error: $error'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformSpecificTextField() {
    if (Platform.isIOS) {
      return SizedBox(
        height: 50,
        width: double.infinity,
        child: CupertinoTextField(
          onChanged: (value) {
            _onSearchChanged(value);
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              ref.read(geoLocationProvider.notifier).refreshWith(value);
            }
          },
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          placeholder: 'Enter City Name',
          placeholderStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      );
    } else {
      return TextField(
        decoration: const InputDecoration(
          hintText: 'Enter City Name',
        ),
        onChanged: (value) {
          _onSearchChanged(value);
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            ref.read(geoLocationProvider.notifier).refreshWith(value);
          }
        },
      );
    }
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
