import 'package:flutter/material.dart';

class LifePoints extends StatelessWidget {
  final int totalLifePoints;
  final int currentLifePoints;

  const LifePoints({super.key, required this.totalLifePoints, required this.currentLifePoints});

  @override
  Widget build(BuildContext context) {
    List<Widget> hearts = [];
    for(int i = 0; i < totalLifePoints; i++) {
      hearts.add(
        i < currentLifePoints
            ? const Icon(Icons.favorite, color: Colors.red)
            : const Icon(Icons.favorite_border_outlined, color: Colors.red)
      );
    }
    // MUST BE USED IN A STACK WIDGET
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      right: 10,
      child: Row(children: hearts),
    );
  }
}