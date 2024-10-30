import 'package:flutter/material.dart';

class WeatherElementsContainer extends StatelessWidget {
  const WeatherElementsContainer({super.key, required this.child, this.isCircular = false});
  final Widget child;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.4,
      width: MediaQuery.sizeOf(context).width * 0.4,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        color: Colors.white.withOpacity(0.8),
        borderRadius: isCircular ? null : const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            // spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}