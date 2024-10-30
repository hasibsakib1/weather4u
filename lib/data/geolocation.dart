import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/dio_service.dart';

import 'model/location_model.dart';

class GeoLocation extends AsyncNotifier<List<LocationModel>> {
  @override
  FutureOr<List<LocationModel>> build() async {
    return [];
    // return locationList;
  }

  Future<List<LocationModel>> _fetchGeoLocation(String queryParam) async {
    final dio = ref.watch(dioServiceProvider);
    dio.options.queryParameters.addAll({'q': queryParam, 'limit': 10});
    final response = await dio.get(geoLocationUrl);
    final data = response.data;
    debugPrint(data.toString());
    final locationList =
        List<LocationModel>.from(data.map((x) => LocationModel.fromJson(x)));
    // ref.read(dioServiceProvider.notifier).dispose(); 
    dio.options.queryParameters.remove('q');
    dio.options.queryParameters.remove('limit');
    debugPrint("queryParam after removing::::::::::::::::::::::::::::::::::::::::::::::: ${dio.options.queryParameters}");
    return locationList;
  }

  Future<void> refreshWith(String newCity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchGeoLocation(newCity));
  }

  void clear(){
    state = const AsyncValue.data([]) ;
  }
}

final geoLocationProvider =
    AsyncNotifierProvider<GeoLocation, List<LocationModel>>(
  GeoLocation.new,
);
