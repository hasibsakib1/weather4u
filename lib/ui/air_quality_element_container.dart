import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          // border: Border.all(
          //   color: Colors.white.withOpacity(0.8),
          //   width: 2,
          // ),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.aq,
                      size: 30,
                      color: Colors.blue,
                    ),
                    Text('Air Quality',
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                Flexible(
                    child: Text(
                  '${data.airQuality.aqi}',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                )),
                Flexible(
                  child: Text(
                    _getConditionAQI(data.airQuality.aqi),
                    style: TextStyle(
                      fontSize: 20,
                      color: _getColorForAQI(data.airQuality.aqi),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
            // const Spacer(
            //   flex: 1,
            // ),
            FittedBox(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.airQuality.components.entries.map((entry){
                      return Text(entry.key.toUpperCase(), style: const TextStyle(fontSize: 15, color: Colors.black),);
                    }).toList(),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.airQuality.components.entries.map((entry){
                      return Text(entry.value.toStringAsFixed(2), style: const TextStyle(fontSize: 15, color: Colors.black),);
                    }).toList(),
                  ),
                ],
              ),
            )
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
