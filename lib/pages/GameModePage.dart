import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/utils/DailyMetrics.dart';
import 'package:leitner/utils/StyledTooltip.dart';

import 'DailyPage.dart';
import 'HomePage.dart';

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
                    label: Text("Chill",
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.beach_access_sharp)
                ),
                const SizedBox(width: 10),
                const StyledTooltip(message: "A relaxed, no-pressure quiz experience.")
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
                    label: Text("Classic",
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.school_sharp)
                ),
                const SizedBox(width: 10),
                const StyledTooltip(message: "Challenge yourself with a balanced mix of questions. Receive a dare if more than half are answered incorrectly.")
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
                    label: Text("Sudden death",
                      style: const TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.local_fire_department_sharp)
                ),
                const SizedBox(width: 10),
                const StyledTooltip(message: "High stakes for every question! Get a dare for each incorrect answer. Perfect for those who love a challenge.")
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
                    label: Text("Marathon",
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 24
                      ),
                    ),
                    icon: const Icon(Icons.emoji_events_sharp)
                ),
                const SizedBox(width: 10),
                const StyledTooltip(message: "Endurance is key! Face a dare after every question, regardless of your answer. A true test of persistence and resilience.")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
