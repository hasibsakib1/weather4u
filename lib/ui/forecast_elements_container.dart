import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
import '../data/forecast_controller.dart';

class ForecastElementsContainer extends ConsumerWidget {
  const ForecastElementsContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(forecastProvider);

    return forecast.when(
      data: (data) {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule, color: Colors.blue),
                    Text('Hourly Forecast',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Text('Forecast: ${data.city!.name}'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: data.list!.map((hourlyForecast) {
                    return Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${hourlyForecast.main!.temp!.toStringAsFixed(0)}°',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Tooltip(
                            preferBelow: false,
                            message:
                                'Feels like: ${hourlyForecast.main!.feelsLike!.toStringAsFixed(0)}°C',
                            child: Text(hourlyForecast.main!.feelsLike!
                                .toStringAsFixed(0)),
                          ),
                          // Text(
                          //   (() {
                          //     String description =
                          //         hourlyForecast.weather![0].description;
                          //     return description[0].toUpperCase() +
                          //         description.substring(1);
                          //   })(),
                          // ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Tooltip(
                              preferBelow: false,
                              message: () {
                                String description =
                                    hourlyForecast.weather![0].description;
                                return description[0].toUpperCase() +
                                    description.substring(1);
                              }(),
                              child: Image.network(
                                '$iconUrl${hourlyForecast.weather![0].icon}@2x.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Tooltip(
                            preferBelow: false,
                            message:
                                'Precipitation: ${hourlyForecast.rain == null ? 0 : (hourlyForecast.pop! * 100).toStringAsFixed(0)}%',
                            child: Text(
                              '${hourlyForecast.pop == null ? 0 : (hourlyForecast.pop! * 100).toStringAsFixed(0)}%',
                            ),
                          ),
                          Text(_showTime(hourlyForecast.dtTxt!)),
                          Text(_showDate(hourlyForecast.dtTxt!)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.8),
        highlightColor: Colors.grey,
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          // padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  String _showTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour $period';
  }

  String _showDate(DateTime dateTime) {
    final currentDate = DateTime.now();
    if (dateTime.day == currentDate.day) {
      return 'Today';
    }
    return _getDayOfWeek(dateTime.weekday);
    // return '${dateTime.day}/${dateTime.month}';
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
