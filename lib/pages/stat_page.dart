import 'package:flutter/material.dart';
import 'package:leitner/utils/daily_metrics.dart';

class StatPage extends StatelessWidget {
  final DailyMetrics dailyMetrics;

  const StatPage({super.key, required this.dailyMetrics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stat'),
      ),
      body: buildMetricsDisplay(dailyMetrics),
    );
  }
}

Widget buildMetricsDisplay(DailyMetrics metrics) {
  return Column(
    children: [
      Text('Total Cards: ${metrics.totalCards}'),
      Text('Correct Cards: ${metrics.correctAnswers}'),
      Text('Session start time : ${metrics.sessionStartTime}'),
      Text('Session end time : ${metrics.sessionEndTime}'),
      Text('Cards id : ${metrics.cardIds}'),
      Text('Dares id : ${metrics.dareIds}'),
      if(metrics.gameMode == GameMode.classic) Text('Life point : ${metrics.lifePoint}')
    ],
  );
}
