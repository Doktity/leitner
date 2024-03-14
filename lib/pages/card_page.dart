import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/app_colors.dart';
import 'package:leitner/services/card_service.dart';
import 'package:leitner/services/pack_service.dart';
import 'package:leitner/services/user_service.dart';
import 'package:leitner/utils/enum_data.dart';
import 'package:leitner/utils/gradient_button.dart';

import '../utils/spoiler_text.dart';
import 'add_card_page.dart';
import 'home_page.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  Map<String, bool> expandedStates = {}; // Map to store expanded states
  List<String> uniqueCategories = [];
  List<String> packIds = [];
  Map<String, String> mapPackNameId = {};
  String selectedCategory = 'All';
  String selectedPackId = 'All';
  final CardService _cardService = CardService();
  final PackService _packService = PackService();
  final UserService _userService = UserService();
  List<Map<String, dynamic>> cards = List.empty();
  List<Map<String, dynamic>> filteredCards = List.empty();
  DataState dataState = DataState.loading;
  Map<String, List<Map<String, dynamic>>> groupedCards = {};
  List<String> sortedPackIds = [];
  List<String> sortedPackNames = [];
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> filterCards() async {
    List<Map<String, dynamic>> categoryFiltered = selectedCategory == 'All' ? cards : cards.where((card) => card['categorie'].contains(selectedCategory)).toList();

    if (selectedPackId == 'All') {
      filteredCards = categoryFiltered;
    } else {
      Map<String, dynamic>? pack = await _packService.getPack(selectedPackId);
      if(pack != null) {
        List<String> cardIdsInPack = List<String>.from(pack['ids']);
        filteredCards = categoryFiltered.where((card) => cardIdsInPack.contains(card['cardId'])).toList();
      }
    }
    setState(() {});
  }

  Future<void> _loadData() async {
    dataState = DataState.loading;
    cards = await _cardService.getUserCards(userId);
    filteredCards = cards;

    packIds = await _userService.getPackIdsByType(userId, "card");
    for(var packId in packIds) {
      mapPackNameId[packId] = await _packService.getPackName(packId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cards,
          style: TextStyle(
            color: AppColors.textIndigo,
            fontFamily: "Mulish",
            fontSize: 24
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
      body: Column(
        children: [
          if(dataState == DataState.loaded)  _buildFilters(),
          Expanded(
            child: (dataState == DataState.loading) ?
            const Center(child: CircularProgressIndicator())
            : (dataState == DataState.empty)
              ? Center(child: Text(AppLocalizations.of(context)!.no_cards, style: TextStyle(fontSize: 28, color: AppColors.textIndigo),))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredCards.length,
                  itemBuilder: (context, index) {
                    final item = filteredCards[index];
                    final question = item['question'] ?? '';
                    final reponseKey = item['reponseKey'] ?? '';
                    final reponseText = item['reponseText'] ?? '';
                    final categories = item['categorie'];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 4,
                      color: AppColors.backgroundGreen,
                      child: Column(
                        children: [
                          ExpansionTile(
                            leading: const FlutterLogo(size: 56.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            title: Text('$question'),
                            subtitle: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                for (var categorie in categories)
                                  Chip(
                                    label: Text(categorie),
                                  ),
                              ],
                            ),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text("${AppLocalizations.of(context)!.answer} : "),
                                        Expanded(child: SpoilerText(text: reponseKey)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text("${AppLocalizations.of(context)!.description} : "),
                                        Expanded(child: SpoilerText(text: reponseText)),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    if(item['creatorId'] == userId)
                                      Row(
                                        children: [
                                          GradientButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AddCardPage(card: item)
                                                  ),
                                                );
                                              },
                                              colors: AppColors.gradientButtonSec,
                                              widthFactor: 0.1,
                                              heightFactor: 0.05,
                                              maxWidth: 100,
                                              padding: 10,
                                              child: const Icon(Icons.mode)
                                          ),
                                          const SizedBox(width: 10),
                                          GradientButton(
                                              onPressed: () {
                                                removeDialog(item["cardId"]);
                                              },
                                              colors: AppColors.gradientButtonSec,
                                              widthFactor: 0.1,
                                              heightFactor: 0.05,
                                              maxWidth: 100,
                                              padding: 10,
                                              child: const Icon(Icons.delete_forever),
                                          )
                                        ],
                                      )
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
      floatingActionButton: ClipRRect(
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddCardPage()
                  )
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void removeDialog(String cardId) {
    bool isLoading = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialog) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.delete_card, style: TextStyle(fontSize: 24, color: AppColors.textIndigo)),
                  content: isLoading
                    ? Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20,),
                        Text(AppLocalizations.of(context)!.wait),
                      ],
                    )
                    : Text(AppLocalizations.of(context)!.sure_question, style: TextStyle(fontSize: 20, color: AppColors.textIndigo)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppColors.pastelPink)
                      ),
                      child: Text(AppLocalizations.of(context)!.confirm, style: TextStyle(color: AppColors.textIndigo)),
                      onPressed: () async {
                        isLoading = true;
                        setStateDialog(() {});
                        await _cardService.deleteCard(cardId);
                        _loadData();
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.card_deleted,
                              style: TextStyle(color: AppColors.textIndigo, fontSize: 20),
                            ),
                            backgroundColor: AppColors.pastelPink,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${AppLocalizations.of(context)!.label} : ", style: TextStyle(fontSize: 20, color: AppColors.textIndigo)),
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
                    setState(() {
                      selectedCategory = newValue ?? 'All';
                      filterCards();
                    });
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
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${AppLocalizations.of(context)!.pack} : ", style: TextStyle(fontSize: 20, color: AppColors.textIndigo)),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)
                ),
                child: DropdownButton<String>(
                  value: selectedPackId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPackId = newValue ?? 'All';
                      filterCards();
                    });
                  },
                  items: [
                    'All',
                    ...packIds,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'All' ? AppLocalizations.of(context)!.all : mapPackNameId[value]!,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          GradientButton(
            onPressed: () {
              selectedCategory = 'All';
              selectedPackId = 'All';
              filterCards();
            },
            colors: AppColors.gradientButtonSec,
            widthFactor: 0.4,
            heightFactor: 0.07,
            maxWidth: 150,
            padding: 10,
            child: Text(AppLocalizations.of(context)!.clear_filter, style: TextStyle(fontSize: 16, color: AppColors.textIndigo)),
          ),
        ],
      ),
    );
  }
}