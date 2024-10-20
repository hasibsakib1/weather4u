import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../data/air_quality_controller.dart';
import '../data/current_city.dart';
import '../data/current_weather_controller.dart';
import '../data/geolocation.dart';
import '../data/model/air_quality_response_model.dart';
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
                baseColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.grey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          currentWeather.when(
            data: (data) => Column(
              children: [
                showCurrentWeather(data),
                showHumidity(data),
                showWind(data),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          airQuality.when(
            data: (data) => showAirQuality(data),
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }

  Widget showCurrentWeather(CurrentWeatherModel current) {
    return Center(
      child: Column(
        children: [
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
      ),
    );
  }

  Widget showHumidity(CurrentWeatherModel current) {
    return Container(
      height: 150,
      width: 150,
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
          const Text('Humidity',
              style: TextStyle(color: Colors.black, fontSize: 20)),
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

  Widget showWind(CurrentWeatherModel current) {
    return Container(
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        
        color: Colors.white.withOpacity(0.8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Wind',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          const Spacer(),
          Text(
            '${current.wind!.speed! * 3.6} Km/h',
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget showAirQuality(AirQualityResponseModel data) {
    return Container(
      height: 150,
      width: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: getColorForAQI(data.airQuality.aqi).withOpacity(0.5),
          width: 2,
        ),
        color: getColorForAQI(data.airQuality.aqi).withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child:
                  Text('Air Quality: ${getConditionAQI(data.airQuality.aqi)}')),
          Flexible(child: Text('AQI: ${data.airQuality.aqi}')),
        ],
      ),
    );
  }

  Color getColorForAQI(int aqi) {
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

  String getConditionAQI(int aqi) {
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
}
