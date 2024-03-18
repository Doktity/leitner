import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/services/pack_service.dart';

import '../app_colors.dart';
import '../business/user_repository.dart';
import '../utils/gradient_app_bar.dart';
import '../utils/gradient_button.dart';
import 'detail_pack_page.dart';
import 'home_page.dart';

class PackPage extends StatefulWidget {
  const PackPage({super.key});

  @override
  State<PackPage> createState() => _PackPageState();
}

class _PackPageState extends State<PackPage> {
  final PackService _packService = PackService();
  final UserRepository _userRepository = UserRepository();
  List<Map<String, dynamic>> packs = List.empty();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    packs = await _packService.getAllPacks();
    for(Map<String, dynamic> pack in packs) {
      pack['username'] = await _userRepository.getUserName(pack['userId']);
    }
    setState(() {}); // Trigger a rebuild after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: GradientAppBar(
        title: AppLocalizations.of(context)!.packs,
        onLeadingPressed: () {
          // Navigate to HomePage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
          );
        },
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
                  final cardsNumber = item['ids'].length;
                  final username = item['username'];

                  return Card(
                    color: AppColors.backgroundGreen,
                    child: Column(
                      children: [
                        ExpansionTile(
                          leading: const FlutterLogo(size: 56.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [
                                      for (var categorie in categories)
                                        Chip(
                                          label: Text(categorie),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  GradientButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DetailPackPage(pack: item)
                                            )
                                        );
                                      },
                                      colors: AppColors.gradientButtonSec,
                                      padding: 5,
                                      widthFactor: 0.2,
                                      heightFactor: 0.07,
                                      maxWidth: 100,
                                      child: Text(AppLocalizations.of(context)!.view, style: TextStyle(color: AppColors.textIndigo, fontSize: 16))
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
