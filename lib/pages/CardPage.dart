import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/business/CardRepository.dart';
import 'package:leitner/business/PackRepository.dart';
import 'package:leitner/utils/EnumData.dart';
import 'package:collection/collection.dart';

import 'AddCardPage.dart';
import 'HomePage.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  Map<String, bool> expandedStates = {}; // Map to store expanded states
  List<String> uniqueCategories = [];
  String selectedCategory = 'All';
  final CardRepository _cardRepository = CardRepository();
  final PackRepository _packRepository = PackRepository();
  List<Map<String, dynamic>> cards = List.empty();
  DataState dataState = DataState.loading;
  Map<String, List<Map<String, dynamic>>> groupedCards = {};
  List<String> sortedPackIds = [];
  List<String> sortedPackNames = [];

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

    groupedCards = groupItemsByPackId(cards);
    sortedPackIds = groupedCards.keys.toList()..sort((a, b) => a.length.compareTo(b.length));
    for(String id in sortedPackIds) {
      if(id.isNotEmpty) {
        String name = await _packRepository.getPackName(id);
        sortedPackNames.add(name);
      } else {
        sortedPackNames.add('No packs');
      }
    }

    for (var card in cards) {
      // Extract unique categories
      if (card['categorie'] != null) {
        for (var categorie in card['categorie']) {
          if (!uniqueCategories.contains(categorie)) {
            uniqueCategories.add(categorie);
          }
        }
      }
    }
    dataState = cards.isEmpty ? DataState.empty : DataState.loaded;
    setState(() {}); // Trigger a rebuild after data is loaded
  }

  Map<String, List<Map<String, dynamic>>> groupItemsByPackId(List<Map<String, dynamic>> items) {
    return groupBy(items, (item) => item['packId']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cards,
          style: TextStyle(
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
          if(dataState == DataState.loaded)  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: DropdownButton<String>(
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
                ),
                ElevatedButton(
                  onPressed: () {
                    filterCards('All');
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    foregroundColor: MaterialStatePropertyAll(Colors.black)
                  ),
                  child: Text(AppLocalizations.of(context)!.clear_filter),
                ),
              ],
            ),
          ),
          Expanded(
            child: (dataState == DataState.loading) ?
            const Center(child: CircularProgressIndicator())
            : (dataState == DataState.empty) ? Text(AppLocalizations.of(context)!.no_cards) : ListView.builder(
              itemCount: sortedPackIds.length,
              itemBuilder: (context, index) {
                String packId = sortedPackIds[index];
                String packName = sortedPackNames[index];
                List itemsInPackId = groupedCards[packId]!
                  .where((card) => selectedCategory == 'All' || card['categorie']?.contains(selectedCategory) ?? false)
                  .toList();
                if(itemsInPackId.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(packName),
                    initiallyExpanded: true,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: itemsInPackId.length,
                        itemBuilder: (context, index) {
                          final item = itemsInPackId[index];
                          final questionImgPath = item['questionImgPath'] ?? '';
                          final question = item['question'] ?? '';
                          final reponseKey = item['reponseKey'] ?? '';
                          final reponseText = item['reponseText'] ?? '';
                          final categories = item['categorie'];
                  
                          // Apply filter
                          if (selectedCategory != 'All' && !categories.contains(
                              selectedCategory)) {
                            return Container();
                          }
                  
                          return Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 4,
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
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
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddCardPage()
              )
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}