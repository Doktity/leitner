import 'package:flutter/material.dart';
import 'package:leitner/pages/ListPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/pages/SettingsPage.dart';

import '../business/LoginRepository.dart';
import 'AddPage.dart';
import 'DailyPage.dart';
import 'LoginPage.dart';
import 'PackPage.dart';

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
                            builder: (_) => const DailyPage()
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
                            builder: (_) => const AddPage()
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.add,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.add)
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
                            builder: (_) => const ListPage()
                        )
                    );
                  },
                  label: Text(AppLocalizations.of(context)!.list,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.list_sharp)
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
                  label: Text("Pack",
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.list_sharp)
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
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(300, 100)),
                      foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
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
                  label: Text(AppLocalizations.of(context)!.logout,
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.logout)
              )
            ],
          )
      ),
    );
  }
}