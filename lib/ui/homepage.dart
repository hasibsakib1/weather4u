import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'forecast_elements_container.dart';
import 'common/weather_elements_container.dart';
import 'common/weather_elements_shimmer.dart';
import '../data/air_quality_controller.dart';
import '../data/current_city.dart';
import '../data/current_weather_controller.dart';
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
    final airQuality = ref.watch(currentAirQualityProvider);
    final city = ref.watch(currentCityProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              // toolbarHeight: 100,
              title: GestureDetector(
                onTap: () {
                  ref.read(geoLocationProvider.notifier).clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectCityPage(),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: kToolbarHeight * 0.8,
                    ),
                    city.when(
                      data: (data) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name, style: const TextStyle(fontSize: 30),),
                          data.state == null
                              ? Text(data.country, style: const TextStyle(fontSize: 16),)
                              : Text("${data.state}, ${data.country}", style: const TextStyle(fontSize: 16),),
                        ],
                      ),
                      loading: () => Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.grey,
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.6),
                          height: kToolbarHeight,
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
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                minHeight: 150.0,
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                child: Container(
                  alignment: Alignment.center,
                  child: currentWeather.when(
                    data: (data) => _showCurrentWeather(data),
                    loading: () => Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.5),
                      highlightColor: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 50,
                            margin: const EdgeInsets.all(5),
                            color: Colors.grey,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 20,
                            margin: const EdgeInsets.all(5),
                            color: Colors.grey,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 20,
                            margin: const EdgeInsets.all(5),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    error: (error, stackTrace) => Text('Error: $error'),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              // child: forecast.when(
              //   data: (data) => _showHourlyForecast(context, data),
              //   loading: () => const SizedBox.shrink(),
              //   error: (error, stackTrace) {
              //     debugPrint('Error: $error, $stackTrace');
              //     return Text('Error: $error');
              //   },
              // ),
              child: ForecastElementsContainer(),
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
                        _showHumidity(data),
                        _showWind(data),
                        _showPressure(data),
                        _showVisibility(data),
                        // airQuality.when(
                        //   data: (data) => _showAirQuality(context, data),
                        //   loading: () => const SizedBox.shrink(),
                        //   error: (error, stackTrace) => Text('Error: $error'),
                        // ),
                      ],
                    ),
                  ],
                ),
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.grey,
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      WeatherElementsShimmer(),
                      WeatherElementsShimmer(),
                      WeatherElementsShimmer(),
                      WeatherElementsShimmer(),
                      WeatherElementsShimmer(),
                      WeatherElementsShimmer(),
                    ],
                  ),
                ),
                error: (error, stackTrace) => Text('Error: $error'),
              ),
            ),
          ],
        ),
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

Widget _showCurrentWeather(CurrentWeatherModel current) {
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

Widget _showHumidity(CurrentWeatherModel current) {
  return WeatherElementsContainer(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop, color: Colors.blue),
            Text(
              'Humidity',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '${current.main!.humidity}%',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}

Widget _showWind(CurrentWeatherModel current) {
  return WeatherElementsContainer(
    isCircular: true,
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

Widget _showVisibility(CurrentWeatherModel current) {
  return WeatherElementsContainer(
    // isCircular: true,
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

Widget _showPressure(CurrentWeatherModel current) {
  return WeatherElementsContainer(
    isCircular: true,
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
          '${(current.main!.pressure! * 0.02952998057228).toStringAsFixed(2)} inHg',
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
