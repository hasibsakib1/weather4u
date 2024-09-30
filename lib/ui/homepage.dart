import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_key.dart';
import '../services/dio_service.dart';
import '../services/location_service.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(asyncPositionProvider);
    final apiKey = ref.watch(apiKeyProvider);
    final dioService = ref.watch(dioServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            position.when(
              data: (position) => Text('Location: ${position.latitude}, ${position.longitude}'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
            apiKey.when(
              data: (key) => Text('API Key: $key'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
            for (final option in dioService.options.queryParameters.entries)
              Text('${option.key}: ${option.value}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(dioServiceProvider.notifier).addAdditionalOptions({'units': 'metric'});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}