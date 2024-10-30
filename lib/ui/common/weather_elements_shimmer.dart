import 'package:flutter/material.dart';

class WeatherElementsShimmer extends StatelessWidget {
  const WeatherElementsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.grey,
      ),
    );
  }
}
