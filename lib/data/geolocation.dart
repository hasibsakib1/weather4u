import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../services/dio_service.dart';

import 'model/location_model.dart';

class GeoLocation extends FamilyAsyncNotifier<List<LocationModel>, String> {
  @override
  FutureOr<List<LocationModel>> build(String arg) async {
    final dio = ref.watch(dioServiceProvider);
    final queryParam = {
      'q': arg,
      'limit': 10,
    };

    dio.options.queryParameters.addAll(queryParam);
    final response = await dio.get('$baseUrl$geoLocationUrl');
    final data = response.data;
    debugPrint(data.toString());
    final locationList =
        List<LocationModel>.from(data.map((x) => LocationModel.fromJson(x)));
    return locationList;
  }
}

final geoLocationProvider =
    AsyncNotifierProviderFamily<GeoLocation, List<LocationModel>, String>(
  GeoLocation.new,
);
