import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/services/user_service.dart';
import 'package:leitner/utils/daily_metrics.dart';
import 'package:leitner/utils/styled_tooltip.dart';

import 'daily_page.dart';
import 'home_page.dart';

class GameModePage extends StatefulWidget {
  GameModePage({super.key});

  @override
  State<GameModePage> createState() => _GameModePageState();
}

class _GameModePageState extends State<GameModePage> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  GameMode? selectedGameMode;
  String? selectedDescription;
  bool isAvailableCards = false;

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _userService.updateAvailableCardCount(userId);
    bool fetchedBool = await _userService.isAvailableCards(userId);
    setState(() {
      isAvailableCards = fetchedBool;
    }); // Trigger a rebuild after data is loaded
  }

  void selectGameMode(GameMode mode, String description) {
    setState(() {
      selectedGameMode = mode;
      selectedDescription = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gamemode),
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
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09)),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
              GameMode.classic,
              AppLocalizations.of(context)!.classic,
              Icons.school_sharp,
              AppLocalizations.of(context)!.classic_desc,
              Colors.green
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
                GameMode.survival,
                AppLocalizations.of(context)!.survival,
                Icons.favorite_sharp,
                AppLocalizations.of(context)!.survival_desc,
                Colors.amber
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
                GameMode.suddenDeath,
                AppLocalizations.of(context)!.sudden_death,
                Icons.local_fire_department_sharp,
                AppLocalizations.of(context)!.sudden_death_desc,
                Colors.red
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
                GameMode.marathon,
                AppLocalizations.of(context)!.marathon,
                Icons.emoji_events_sharp,
                AppLocalizations.of(context)!.marathon_desc,
                Colors.black12
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 80),
                child: selectedDescription != null ? _buildGameModeDescription() : const SizedBox.shrink(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: (selectedGameMode != null && isAvailableCards) ? _buildLaunchButton(context) : null,
    );
  }

  Widget _buildGameModeButton(GameMode mode, String title, IconData icon, String description, Color? color) {
    return ElevatedButton.icon(
        style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
            backgroundColor: MaterialStatePropertyAll(color),
            fixedSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.08)),
            maximumSize: MaterialStatePropertyAll(Size(300, 100)),
            foregroundColor: MaterialStatePropertyAll(Colors.black)
        ),
        onPressed: () => selectGameMode(mode, description),
        label: Text(title,
          style: const TextStyle(
              fontFamily: "Mulish",
              fontSize: 24
          ),
        ),
        icon: Icon(icon)
    );
  }

  Widget _buildGameModeDescription() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.25,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 1)
          ),
          child: SingleChildScrollView(
            child: Text(
              selectedDescription!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLaunchButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        DailyMetrics dailyMetrics = DailyMetrics(userId: userId, gameMode: selectedGameMode!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DailyPage(dailyMetrics: dailyMetrics),
          ),
        );
      },
      tooltip: AppLocalizations.of(context)!.launch,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.play_arrow),
    );
  }
}
