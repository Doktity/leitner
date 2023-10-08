import 'package:flutter/material.dart';
import 'package:leitner/pages/ListPage.dart';

import 'AddPage.dart';
import 'DailyPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bienvenue dans Leitner",
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
                      fixedSize: MaterialStatePropertyAll(Size(300, 100))
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DailyPage()
                        )
                    );
                  },
                  label: const Text("Daily",
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
                      fixedSize: MaterialStatePropertyAll(Size(300, 100))
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddPage()
                        )
                    );
                  },
                  label: const Text("Add",
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
                      fixedSize: MaterialStatePropertyAll(Size(300, 100))
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ListPage()
                        )
                    );
                  },
                  label: const Text("List",
                    style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 24
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month)
              )
            ],
          )
      ),
    );
  }
}