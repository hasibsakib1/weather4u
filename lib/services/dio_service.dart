import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather4u/constants.dart';

import 'api_key.dart';

class DioService extends Notifier<Dio> {
  final _dio = Dio();


  @override
  build() {
    _getApiKey();
    _dio.options.baseUrl = baseUrl;
    addAdditionalOptions({'units': 'metric'});
    return _dio;
  }

  void addAdditionalOptions(Map<String, dynamic> options) {
    _dio.options.queryParameters.addAll(options);
  }

  void _getApiKey() async{
    final apiKey = await ref.watch(apiKeyProvider.future);
    _dio.options.queryParameters.addAll({'appid': apiKey});
  }

  // Future getRequest(String url, Map<String, dynamic> param) async {
  //   final response = await _dio.get(url);
  //   return response.data;
  // }

  void dispose() {
    print("...............................................DioService disposed");
    _dio.close();
  }

}

final dioServiceProvider = NotifierProvider<DioService, Dio>(DioService.new);
 
