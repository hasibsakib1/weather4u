import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather4u/data/model/forecast_response_model.dart';

import '../constants.dart';
import '../services/dio_service.dart';
import '../services/location_service.dart';
import 'current_city.dart';

class ForecastController extends AsyncNotifier<ForecastResponseModel>{
  @override
  FutureOr<ForecastResponseModel> build() {

    final forecast = _fetchForecastFromCurrentLocation();
    return forecast;
  }
  
  Future<ForecastResponseModel> _fetchForecastFromCurrentLocation() async {
    final dio = ref.watch(dioServiceProvider);
    final location = await ref.watch(asyncPositionProvider.future);
    const unit = 'metric';

    ref.read(currentCityProvider);

    Map<String, dynamic> queryParameters = {
      'lat': location.latitude,
      'lon': location.longitude,
      'units': unit,
    };
    dio.options.queryParameters.addAll(queryParameters);
    final response = await dio.get('$baseUrl$forecastUrl');
    debugPrint("Forecast: ${response.toString()}");
    final data = response.data;
    final forecast = ForecastResponseModel.fromJson(data);
    return forecast;
  }

  Future<ForecastResponseModel> _fetchForecast(double lat, double lon) async {
    final dio = ref.watch(dioServiceProvider);
    const unit = 'metric';

    Map<String, dynamic> queryParameters = {
      'lat': lat,
      'lon': lon,
      'units': unit,
    };
    dio.options.queryParameters.addAll(queryParameters);
    debugPrint('fetching Forecast weather for $lat, $lon');
    debugPrint('current weather parameter for ${dio.options.queryParameters}');

    final response = await dio.get('$baseUrl$forecastUrl');
    debugPrint("Forecast: ${response.toString()}");
    final data = response.data;
    final forecast = ForecastResponseModel.fromJson(data);
    return forecast;
  }

  Future<void> refreshWith(double lat, double lon) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchForecast(lat,lon));
  }

}

final forecastProvider = AsyncNotifierProvider<ForecastController, ForecastResponseModel>(ForecastController.new);