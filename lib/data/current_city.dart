import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/dio_service.dart';
import '../services/location_service.dart';
import 'model/city_model.dart';

class CurrentCityNotifier extends AsyncNotifier<CityModel> {
  @override
  FutureOr<CityModel> build() async{
    final dio = ref.watch(dioServiceProvider);
    final location = await ref.watch(asyncPositionProvider.future);

    Map<String, dynamic> queryParameters = {
      'lat': location.latitude,
      'lon': location.longitude,
    };
    dio.options.queryParameters.addAll(queryParameters);

    final response = await dio.get('$baseUrl$geoLocationReverseUrl');
    debugPrint(response.toString());
    final data = response.data;
    final currentCity = CityModel.fromJson(data[0]);
    return currentCity;
  }


}

final currentCityProvider = AsyncNotifierProvider<CurrentCityNotifier, CityModel>(
  CurrentCityNotifier.new,
);