import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'air_quality_controller.dart';
import 'forecast_controller.dart';
import '../constants.dart';
import 'current_city.dart';
import 'model/current_weather_model.dart';
import '../services/dio_service.dart';
import '../services/location_service.dart';


class CurrentWeatherController extends AsyncNotifier<CurrentWeatherModel> {

  
  @override
  FutureOr<CurrentWeatherModel> build() async {
    final currentWeather = await _fetchCurrentWeatherFromCurrentLocation();
    return currentWeather;
  }

  Future<CurrentWeatherModel> _fetchCurrentWeatherFromCurrentLocation() async {
    final dio = ref.read(dioServiceProvider);
    final location = await ref.watch(asyncPositionProvider.future);

    ref.read(currentCityProvider);

    Map<String, dynamic> queryParameters = {
      'lat': location.latitude,
      'lon': location.longitude,
    };
    dio.options.queryParameters.addAll(queryParameters);
    final response = await dio.get(currentWeatherUrl);
    debugPrint("Current Weather: ${response.toString()}");
    final data = response.data;
    final currentWeather = CurrentWeatherModel.fromJson(data);
    return currentWeather;
  }

  Future<CurrentWeatherModel> _fetchCurrentWeather(double lat, double lon) async {
    final dio = ref.watch(dioServiceProvider);
    ref.read(currentAirQualityProvider.notifier).refreshWith(lat, lon);
    ref.read(forecastProvider.notifier).refreshWith(lat, lon);

    Map<String, dynamic> queryParameters = {
      'lat': lat,
      'lon': lon,
    };
    dio.options.queryParameters.addAll(queryParameters);
    debugPrint('fetching current weather for $lat, $lon');
    debugPrint('current weather parameter for ${dio.options.queryParameters}');

    final response = await dio.get(currentWeatherUrl);
    debugPrint("Current Weather: ${response.toString()}");
    final data = response.data;
    final currentWeather = CurrentWeatherModel.fromJson(data);
    return currentWeather;
  }

  Future<void> refreshWith(double lat, double lon) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchCurrentWeather(lat,lon));
  }
}

final currentWeatherProvider =
    AsyncNotifierProvider<CurrentWeatherController, CurrentWeatherModel>(
        CurrentWeatherController.new);


// final currentWeatherProvider = AsyncNotifierProviderFamily<CurrentWeatherController, CurrentWeatherModel, (double, double)>(
//   CurrentWeatherController.new,
// );