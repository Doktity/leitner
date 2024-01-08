import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/business/CardRepository.dart';

import 'HomePage.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Map<String, bool> expandedStates = {}; // Map to store expanded states
  List<String> uniqueCategories = [];
  String selectedCategory = 'All';
  final CardRepository _cardRepository = CardRepository();
  List<Map<String, dynamic>> cards = List.empty();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void filterCards(String categorie) {
    setState(() {
      selectedCategory = categorie;
    });
  }

  Future<void> _loadData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    cards = await _cardRepository.getUserCards(userId);

    // Extract unique categories
    for (var card in cards) {
      if (card['categorie'] != null) {
        for (var categorie in card['categorie']) {
          if (!uniqueCategories.contains(categorie)) {
            uniqueCategories.add(categorie);
          }
        }
      }
    }
    setState(() {}); // Trigger a rebuild after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.list),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    filterCards(newValue!);
                  },
                  items: [
                    'All',
                    ...uniqueCategories,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'All' ? AppLocalizations.of(context)!.all : value,
                      ),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    filterCards('All');
                  },
                  child: Text(AppLocalizations.of(context)!.clear_filter),
                ),
              ],
            ),
          ),
          Expanded(
            child: (cards.isEmpty) ?
            const Center(child: CircularProgressIndicator())
            : ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final item = cards[index];
                final questionImgPath = item['questionImgPath'] ?? '';
                final question = item['question'] ?? '';
                final reponseKey = item['reponseKey'] ?? '';
                final reponseText = item['reponseText'] ?? '';
                final categories = item['categorie'];

                // Apply filter
                if (selectedCategory != 'All' && !categories.contains(selectedCategory)) {
                  return Container();
                }

                return Card(
                  child: Column(
                    children: [
                      ExpansionTile(
                        leading: const FlutterLogo(size: 56.0),
                        title: Text('$question'),
                        subtitle: Text('$reponseKey'),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    for (var categorie in categories)
                                      Chip(
                                        label: Text(categorie),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(reponseText),
                              ],
                            ),
                          ),
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