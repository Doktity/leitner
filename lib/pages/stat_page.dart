import 'package:flutter/material.dart';
import 'package:leitner/pages/home_page.dart';
import 'package:leitner/utils/daily_metrics.dart';

class StatPage extends StatelessWidget {
  final DailyMetrics dailyMetrics;

  const StatPage({super.key, required this.dailyMetrics});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stat'),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.blue.shade50,
        body: buildMetricsDisplay(context, dailyMetrics),
      ),
    );
  }
}

Widget buildMetricsDisplay(BuildContext context, DailyMetrics metrics) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Total Cards: ${metrics.totalCards}'),
        Text('Correct Cards: ${metrics.correctAnswers}'),
        Text('Session start time : ${metrics.sessionStartTime}'),
        Text('Session end time : ${metrics.sessionEndTime}'),
        Text('Cards id : ${metrics.cardIds}'),
        Text('Dares id : ${metrics.dareIds}'),
        if(metrics.gameMode == GameMode.classic) Text('Total Life point : ${metrics.totalLifePoint}'),
        if(metrics.gameMode == GameMode.classic) Text('Current Life point : ${metrics.currentLifePoint}'),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text("Home")
        )
      ],
    ),
  );
}
