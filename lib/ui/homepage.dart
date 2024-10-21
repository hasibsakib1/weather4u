import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../data/air_quality_controller.dart';
import '../data/current_city.dart';
import '../data/current_weather_controller.dart';
import '../data/forecast_controller.dart';
import '../data/geolocation.dart';
import '../data/model/air_quality_response_model.dart';
import '../data/model/current_weather_model.dart';
import '../data/model/forecast_response_model.dart';
import 'select_city_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherProvider);
    final forecast = ref.watch(forecastProvider);
    final airQuality = ref.watch(currentAirQualityProvider);
    final city = ref.watch(currentCityProvider);

    return Scaffold(
      // appBar: AppBar(
      //   forceMaterialTransparency: true,
      //   title: Row(
      //     children: [
      //       const Icon(Icons.location_on),
      //       city.when(
      //         data: (data) => SizedBox(
      //           width: MediaQuery.of(context).size.width * 0.8,
      //           child: FittedBox(
      //             child: GestureDetector(
      //               onTap: () {
      //                 ref.read(geoLocationProvider.notifier).clear();
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => const SelectCityPage(),
      //                   ),
      //                 );
      //               },
      //               child: data.state == null
      //                   ? Text("${data.name}, ${data.country}")
      //                   : Text("${data.name}, ${data.state}, ${data.country}"),
      //             ),
      //           ),
      //         ),
      //         loading: () => Shimmer.fromColors(
      //           baseColor: Colors.grey.withOpacity(0.5),
      //           highlightColor: Colors.grey,
      //           child: Container(
      //             width: MediaQuery.of(context).size.width * 0.8,
      //             height: 30,
      //             color: Colors.white,
      //           ),
      //         ),
      //         error: (error, stackTrace) {
      //           debugPrint('Error: $error');
      //           return Text('Error: $error $stackTrace');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              children: [
                const Icon(Icons.location_on),
                city.when(
                  data: (data) => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FittedBox(
                      child: GestureDetector(
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
                            : Text(
                                "${data.name}, ${data.state}, ${data.country}"),
                      ),
                    ),
                  ),
                  loading: () => Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.5),
                    highlightColor: Colors.grey,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 30,
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
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              minHeight: 150.0,
              maxHeight: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                alignment: Alignment.center,
                child: currentWeather.when(
                  data: (data) => _showCurrentWeather(context, data),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: forecast.when(
              data: (data) => _showHourlyForecast(context, data),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ),
          SliverToBoxAdapter(
            child: currentWeather.when(
              data: (data) => Column(
                children: [
                  GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _showHumidity(context, data),
                      _showWind(context, data),
                      _showVisibility(context, data),
                      _showVisibility(context, data),
                      _showVisibility(context, data),
                      _showVisibility(context, data),
                      _showPressure(context, data),
                      airQuality.when(
                        data: (data) => _showAirQuality(context, data),
                        loading: () => const SizedBox.shrink(),
                        error: (error, stackTrace) => Text('Error: $error'),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Widget _showCurrentWeather(BuildContext context, CurrentWeatherModel current) {
  return Container(
    alignment: Alignment.center,
    // height: MediaQuery.of(context).size.height * 0.4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${current.main!.temp!.toStringAsFixed(0)}°C',
          style: const TextStyle(
            fontSize: 48,
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
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

Widget _showHourlyForecast(BuildContext context, ForecastResponseModel forecast) {
  return Container(
    alignment: Alignment.center,
    child: Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, color: Colors.blue),
            Text('Hourly Forecast',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        Text('Forecast: ${forecast.city.name}'),
      ],
    ),
  );
}

Widget _showHumidity(BuildContext context, CurrentWeatherModel current) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.4,
    width: MediaQuery.of(context).size.width * 0.4,
    margin: const EdgeInsets.all(15),
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      color: Colors.white.withOpacity(0.8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop, color: Colors.blue),
            Text('Humidity',
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
        const Spacer(),
        Text(
          '${current.main!.humidity}%',
          style: const TextStyle(color: Colors.black, fontSize: 30),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}

Widget _showWind(BuildContext context, CurrentWeatherModel current) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.4,
    width: MediaQuery.of(context).size.width * 0.4,
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, color: Colors.blue),
            Text('Wind', style: TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
        const Spacer(),
        Text(
          '${(current.wind!.speed! * 3.6).toStringAsFixed(2)} Km/h',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}

Widget _showVisibility(BuildContext context, CurrentWeatherModel current) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.4,
    width: MediaQuery.of(context).size.width * 0.4,
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility, color: Colors.blue),
            Text('Visibility',
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
        const Spacer(),
        Text(
          '${current.visibility! / 1000} Km',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}

Widget _showPressure(BuildContext context, CurrentWeatherModel current) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.4,
    width: MediaQuery.of(context).size.width * 0.4,
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      color: Colors.white.withOpacity(0.8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.compress, color: Colors.blue),
            Text('Pressure',
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ],
        ),
        const Spacer(),
        Text(
          '${current.main!.pressure} hPa',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}

Widget _showAirQuality(BuildContext context, AirQualityResponseModel data) {
  return Container(
    height: MediaQuery.of(context).size.width * 0.4,
    width: MediaQuery.of(context).size.width * 0.4,
    margin: const EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(
        color: _getColorForAQI(data.airQuality.aqi).withOpacity(0.5),
        width: 2,
      ),
      color: _getColorForAQI(data.airQuality.aqi).withOpacity(0.2),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child:
                Text('Air Quality: ${_getConditionAQI(data.airQuality.aqi)}')),
        Flexible(child: Text('AQI: ${data.airQuality.aqi}')),
      ],
    ),
  );
}

Color _getColorForAQI(int aqi) {
  switch (aqi) {
    case 1:
      return Colors.green;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.orange;
    case 4:
      return Colors.red;
    case 5:
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

String _getConditionAQI(int aqi) {
  switch (aqi) {
    case 1:
      return 'Good';
    case 2:
      return 'Fair';
    case 3:
      return 'Moderate';
    case 4:
      return 'Poor';
    case 5:
      return 'Very Poor';
    default:
      return 'Unknown';
  }
}
