import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather4u/constants.dart';
import 'package:weather4u/data/model/current_weather_model.dart';
import '../services/dio_service.dart';

class CurrentWeatherController extends FamilyAsyncNotifier<CurrentWeatherModel, (double, double)> {

  
  @override
  FutureOr<CurrentWeatherModel> build((double,double) arg) async {

    final double lat = arg.$1;
    final double lon = arg.$2;

    final dio = ref.watch(dioServiceProvider);
    const unit = 'metric';

    Map<String, dynamic> queryParameters = {
      'lat': lat,
      'lon': lon,
      'units': unit,
    };
    dio.options.queryParameters.addAll(queryParameters);

    final response = await dio.get('$baseUrl$currentWeatherUrl');
    debugPrint(response.toString());
    final data = response.data;
    final currentWeather = CurrentWeatherModel.fromJson(data);
    return currentWeather;
  }
}

// final currentWeatherProvider =
//     AsyncNotifierProvider<CurrentWeatherController, CurrentWeatherModel>(
//         CurrentWeatherController.new);


final currentWeatherProvider = AsyncNotifierProviderFamily<CurrentWeatherController, CurrentWeatherModel, (double, double)>(
  CurrentWeatherController.new,
);