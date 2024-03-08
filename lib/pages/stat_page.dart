import 'package:flutter/material.dart';
import 'package:leitner/pages/home_page.dart';
import 'package:leitner/utils/daily_metrics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatPage extends StatelessWidget {
  final DailyMetrics dailyMetrics;

  const StatPage({super.key, required this.dailyMetrics});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.stat),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.blue.shade50,
        body: buildMetricsDisplay(context, dailyMetrics),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            backgroundColor: Colors.blue,
            tooltip: AppLocalizations.of(context)!.home,
            child: const Icon(Icons.home)
        ),
      ),
    );
  }
}

Widget buildMetricsDisplay(BuildContext context, DailyMetrics metrics) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Center(
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.total_cards(metrics.totalCards),
                style: const TextStyle(
                  fontSize: 20
                ),
              ),
              Text(AppLocalizations.of(context)!.correct_cards(metrics.correctAnswers),
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              Text(AppLocalizations.of(context)!.session_start(metrics.sessionStartTime),
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              Text(AppLocalizations.of(context)!.session_end(metrics.sessionEndTime!),
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              Text(AppLocalizations.of(context)!.card_id_list(metrics.cardIds.toString()),
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              Text(AppLocalizations.of(context)!.dare_id_list(metrics.dareIds.toString()),
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              if(metrics.gameMode == GameMode.classic) Text(AppLocalizations.of(context)!.total_life(metrics.totalLifePoint),
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              if(metrics.gameMode == GameMode.classic) Text(AppLocalizations.of(context)!.current_life(metrics.currentLifePoint),
                style: const TextStyle(
                    fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
