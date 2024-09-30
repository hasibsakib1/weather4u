import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiKey extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async{
    final String response = await rootBundle.loadString('assets/json/api_key.json');
    final data = jsonDecode(response);
    final key = data['API_KEY'];
    if (key == null) {
      throw Exception('API key not found.');
    }
    return key;
  }
}

final apiKeyProvider = AsyncNotifierProvider<ApiKey, String>(
  ApiKey.new,
);