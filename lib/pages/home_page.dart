import 'package:flutter/material.dart';
import 'package:leitner/app_colors.dart';
import 'package:leitner/pages/card_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/pages/gamemode_page.dart';
import 'package:leitner/pages/settings_page.dart';
import 'package:leitner/utils/gradient_button.dart';
import 'package:leitner/utils/gradient_floating_action_button.dart';

import '../services/login_service.dart';
import 'dare_page.dart';
import 'login_page.dart';
import 'pack_page.dart';

class HomePage extends StatelessWidget {

  HomePage({
    super.key,
  });

  final LoginService _loginRepository = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.welcome,
                style: TextStyle(
                    fontSize: 36,
                    fontFamily: "Mulish",
                    color: AppColors.textIndigo
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              GradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GameModePage()),
                  );
                },
                child: GradientButton.buildButtonContent(Icons.calendar_month, AppLocalizations.of(context)!.daily),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              GradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CardPage()),
                  );
                },
                child: GradientButton.buildButtonContent(Icons.library_books, AppLocalizations.of(context)!.cards),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              GradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DarePage()),
                  );
                },
                child: GradientButton.buildButtonContent(Icons.local_fire_department_sharp, AppLocalizations.of(context)!.dares),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              GradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PackPage()),
                  );
                },
                child: GradientButton.buildButtonContent(Icons.collections_bookmark, AppLocalizations.of(context)!.packs),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              GradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsPage()),
                  );
                },
                child: GradientButton.buildButtonContent(Icons.settings, AppLocalizations.of(context)!.settings),
              )
            ],
          )
      ),
      floatingActionButton: GradientFloatingActionButton(
        onPressed: () async {
          await _loginRepository.signOutGoogle();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LoginPage()
              )
          );
        },
        icon: Icons.logout,
      ),
    );
  }
}