import 'package:flutter/material.dart';

class AirQualityDetailsScreen extends StatelessWidget {
  const AirQualityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'air-quality-details',
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
        
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
