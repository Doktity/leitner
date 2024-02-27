import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../business/DareRepository.dart';
import '../business/UserRepository.dart';
import 'HomePage.dart';

class DarePage extends StatefulWidget {
  const DarePage({super.key});

  @override
  State<DarePage> createState() => _DarePageState();
}

class _DarePageState extends State<DarePage> {
  final DareRepository _dareRepository = DareRepository();
  final UserRepository _userRepository = UserRepository();
  List<Map<String, dynamic>> dares = List.empty();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    dares = await _dareRepository.getAllDares();
    setState(() {}); // Trigger a rebuild after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dares,
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
            child: (dares.isEmpty) ?
            const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: dares.length,
                  itemBuilder: (context, index) {
                  final item = dares[index];
                  final name = item['name'] ?? '';
                  final description = item['description'] ?? '';
                  final categories = item['categories'];

                  return Card(
                    child: Column(
                      children: [
                        ExpansionTile(
                          leading: const FlutterLogo(size: 56.0),
                          title: Text('$name'),
                          subtitle: Text('$description'),
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  for (var categorie in categories)
                                    Chip(
                                      label: Text(categorie),
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
