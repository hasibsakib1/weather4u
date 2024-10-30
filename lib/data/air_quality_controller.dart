import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/dio_service.dart';
import '../services/location_service.dart';
import 'current_city.dart';
import 'model/air_quality_response_model.dart';

class AirQualityController extends AsyncNotifier<AirQualityResponseModel> {

  
  @override
  FutureOr<AirQualityResponseModel> build() async {
    final currentWeather = await _fetchAirQualityFromCurrentLocation();
    return currentWeather;
  }

  Future<AirQualityResponseModel> _fetchAirQualityFromCurrentLocation() async {
    final dio = ref.watch(dioServiceProvider);
    final location = await ref.watch(asyncPositionProvider.future);

    ref.read(currentCityProvider);

    Map<String, dynamic> queryParameters = {
      'lat': location.latitude,
      'lon': location.longitude,
    };
    dio.options.queryParameters.addAll(queryParameters);
    final response = await dio.get(airQualityUrl);
    debugPrint(response.toString());
    final data = response.data;
    final currentWeather = AirQualityResponseModel.fromJson(data);
    return currentWeather;
  }

  Future<AirQualityResponseModel> _fetchCurrentAirQuality(double lat, double lon) async {
    final dio = ref.watch(dioServiceProvider);

    Map<String, dynamic> queryParameters = {
      'lat': lat,
      'lon': lon,
    };
    dio.options.queryParameters.addAll(queryParameters);
    debugPrint('fetching current weather for $lat, $lon');
    debugPrint('current weather parameter for ${dio.options.queryParameters}');

    final response = await dio.get(airQualityUrl);
    debugPrint(response.toString());
    final data = response.data;
    final currentWeather = AirQualityResponseModel.fromJson(data);
    return currentWeather;
  }

  Future<void> refreshWith(double lat, double lon) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchCurrentAirQuality(lat,lon));
  }
}

final currentAirQualityProvider =
    AsyncNotifierProvider<AirQualityController, AirQualityResponseModel>(
        AirQualityController.new);

