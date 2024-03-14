import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/app_colors.dart';
import 'package:leitner/services/user_service.dart';
import 'package:leitner/utils/daily_metrics.dart';
import 'package:leitner/utils/gradient_button.dart';
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
        title: Text(AppLocalizations.of(context)!.gamemode, style: TextStyle(color: AppColors.textIndigo, fontSize: 24)),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.gradientButton,
                begin: Alignment(-0.8, -1),
                end: Alignment(0.8, 1),
              )
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundGreen,
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
              [AppColors.pastelGreenLight, AppColors.pastelGreen]
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
                GameMode.survival,
                AppLocalizations.of(context)!.survival,
                Icons.favorite_sharp,
                AppLocalizations.of(context)!.survival_desc,
                [AppColors.pastelYellowLight, AppColors.pastelYellow]
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
                GameMode.suddenDeath,
                AppLocalizations.of(context)!.sudden_death,
                Icons.local_fire_department_sharp,
                AppLocalizations.of(context)!.sudden_death_desc,
                [AppColors.pastelPinkLight, AppColors.pastelPink]
            ),
            const Padding(padding: EdgeInsets.all(20)),
            _buildGameModeButton(
                GameMode.marathon,
                AppLocalizations.of(context)!.marathon,
                Icons.emoji_events_sharp,
                AppLocalizations.of(context)!.marathon_desc,
                [AppColors.pastelPurpleLight, AppColors.pastelPurple]
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

  Widget _buildGameModeButton(GameMode mode, String title, IconData icon, String description, List<Color> colors) {
    return GradientButton(
        onPressed: () => selectGameMode(mode, description),
        colors: colors,
        child: GradientButton.buildButtonContent(icon, title),
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
            border: Border.all(color: AppColors.pastelGreenDark, width: 1)
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientButton, // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
        child: FloatingActionButton(
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
