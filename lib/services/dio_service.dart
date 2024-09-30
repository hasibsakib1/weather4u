import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_key.dart';

class DioService extends Notifier<Dio> {
  final _dio = Dio();


  @override
  build() {
    final apiKey = ref.watch(apiKeyProvider);
    apiKey.whenData((key){
      _dio.options.queryParameters = {'appid': key};
    });
    return _dio;
  }

  void addAdditionalOptions(Map<String, dynamic> options) {
    _dio.options.queryParameters.addAll(options);
    Dio newDio = Dio();
    newDio.options.queryParameters = _dio.options.queryParameters;
    state = newDio;
  }

}

final dioServiceProvider = NotifierProvider<DioService, Dio>(DioService.new);
 
