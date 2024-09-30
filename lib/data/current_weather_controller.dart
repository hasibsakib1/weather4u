import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dio_service.dart';

class CurrentWeatherController extends AsyncNotifier {
  @override
  FutureOr build() async {
    final dio = ref.watch(dioServiceProvider);
    const lat = 35.6895;
    const lon = 139.6917;
    const unit = 'metric';

    Map<String, dynamic> queryParameters = {
      'lat': lat,
      'lon': lon,
      'units': unit,
    };
    dio.options.queryParameters.addAll(queryParameters);
    debugPrint('Query Parameters: ${dio.options.queryParameters}');

    final response = await dio.get('https://api.openweathermap.org/data/2.5/weather');
    debugPrint(response.toString());
    return response.data;
  }
}

final currentWeatherProvider =
    AsyncNotifierProvider<CurrentWeatherController, dynamic>(
        CurrentWeatherController.new);
