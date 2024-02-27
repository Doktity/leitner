import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../business/PackRepository.dart';
import '../business/UserRepository.dart';
import 'DetailPackPage.dart';
import 'HomePage.dart';

class PackPage extends StatefulWidget {
  const PackPage({super.key});

  @override
  State<PackPage> createState() => _PackPageState();
}

class _PackPageState extends State<PackPage> {
  final PackRepository _packRepository = PackRepository();
  final UserRepository _userRepository = UserRepository();
  List<Map<String, dynamic>> packs = List.empty();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    packs = await _packRepository.getAllPacks();
    for(Map<String, dynamic> pack in packs) {
      pack['username'] = await _userRepository.getUserName(pack['userId']);
    }
    setState(() {}); // Trigger a rebuild after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.packs,
          style: const TextStyle(
            fontFamily: "Mulish",
          ),
        ),
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
      body: Column(
        children: [
          Expanded(
            child: (packs.isEmpty) ?
            const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: packs.length,
                  itemBuilder: (context, index) {
                  final item = packs[index];
                  final name = item['name'] ?? '';
                  final description = item['description'] ?? '';
                  final categories = item['categories'];
                  final cardsNumber = item['cards'].length;
                  final username = item['username'];

                  return Card(
                    child: Column(
                      children: [
                        ExpansionTile(
                          leading: const FlutterLogo(size: 56.0),
                          title: Text('$name'),
                          subtitle: Text('$description'),
                          trailing: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.cards_number(cardsNumber)),
                              Text(username)
                            ],
                          ),
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      for (var categorie in categories)
                                        Chip(
                                          label: Text(categorie),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DetailPackPage(pack: item)
                                            )
                                        );
                                      },
                                      child: Text(AppLocalizations.of(context)!.view)
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
