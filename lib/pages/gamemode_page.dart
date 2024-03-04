import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/utils/daily_metrics.dart';
import 'package:leitner/utils/styled_tooltip.dart';

import 'daily_page.dart';
import 'home_page.dart';

class GameModePage extends StatelessWidget {
  GameModePage({super.key});
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game mode"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to HomePage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                        foregroundColor: MaterialStatePropertyAll(Colors.black)
                    ),
                    onPressed: () {
                      DailyMetrics dailyMetrics = DailyMetrics(userId: userId, gameMode: GameMode.chill);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DailyPage(dailyMetrics: dailyMetrics)
                          )
                      );
                    },
                    label: Text(AppLocalizations.of(context)!.chill,
                      style: const TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.beach_access_sharp)
                ),
                const SizedBox(width: 10),
                StyledTooltip(message: AppLocalizations.of(context)!.chill_desc)
              ],
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                        foregroundColor: MaterialStatePropertyAll(Colors.black)
                    ),
                    onPressed: () {
                      DailyMetrics dailyMetrics = DailyMetrics(userId: userId, gameMode: GameMode.classic);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DailyPage(dailyMetrics: dailyMetrics)
                          )
                      );
                    },
                    label: Text(AppLocalizations.of(context)!.classic,
                      style: const TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.school_sharp)
                ),
                const SizedBox(width: 10),
                StyledTooltip(message: AppLocalizations.of(context)!.classic_desc)
              ],
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                        foregroundColor: MaterialStatePropertyAll(Colors.black)
                    ),
                    onPressed: () {
                      DailyMetrics dailyMetrics = DailyMetrics(userId: userId, gameMode: GameMode.suddenDeath);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DailyPage(dailyMetrics: dailyMetrics)
                          )
                      );
                    },
                    label: Text(AppLocalizations.of(context)!.sudden_death,
                      style: const TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.local_fire_department_sharp)
                ),
                const SizedBox(width: 10),
                StyledTooltip(message: AppLocalizations.of(context)!.sudden_death_desc)
              ],
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                        foregroundColor: MaterialStatePropertyAll(Colors.black)
                    ),
                    onPressed: () {
                      DailyMetrics dailyMetrics = DailyMetrics(userId: userId, gameMode: GameMode.marathon);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DailyPage(dailyMetrics: dailyMetrics)
                          )
                      );
                    },
                    label: Text(AppLocalizations.of(context)!.marathon,
                      style: const TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.emoji_events_sharp)
                ),
                const SizedBox(width: 10),
                StyledTooltip(message: AppLocalizations.of(context)!.marathon_desc)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
