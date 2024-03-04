import 'package:flutter/material.dart';
import 'package:leitner/pages/card_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/pages/gamemode_page.dart';
import 'package:leitner/pages/settings_page.dart';

import '../business/login_repository.dart';
import 'dare_page.dart';
import 'login_page.dart';
import 'pack_page.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final LoginRepository _loginRepository = LoginRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.welcome,
                style: TextStyle(
                    fontSize: 36,
                    fontFamily: "Mulish"
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GameModePage()
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.daily,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month)
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CardPage()
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.cards,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.library_books)
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PackPage()
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.packs,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.collections_bookmark)
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DarePage()
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.dares,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.local_fire_department_sharp)
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SettingsPage(Localizations.localeOf(context).languageCode)
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.settings)
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String deco = await _loginRepository.signOutGoogle();
          print(deco);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => LoginPage()
              )
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.logout)
      ),
    );
  }
}