import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/weather_elements_shimmer.dart';
import '../data/air_quality_controller.dart';

class AirQualityElementContainer extends ConsumerWidget {
  const AirQualityElementContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airQuality = ref.watch(currentAirQualityProvider);

    return airQuality.when(
      data: (data) => Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: _getColorForAQI(data.airQuality.aqi).withOpacity(0.5),
            width: 2,
          ),
          color: _getColorForAQI(data.airQuality.aqi).withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Text(
                    'Air Quality: ${_getConditionAQI(data.airQuality.aqi)}')),
            Flexible(child: Text('AQI: ${data.airQuality.aqi}')),
          ],
        ),
      ),
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => const WeatherElementsShimmer(),
    );
  }

  Color _getColorForAQI(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getConditionAQI(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }
}
