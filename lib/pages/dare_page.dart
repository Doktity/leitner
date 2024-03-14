import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/services/dare_service.dart';
import 'package:leitner/services/pack_service.dart';
import 'package:leitner/services/user_service.dart';

import '../app_colors.dart';
import '../utils/enum_data.dart';
import '../utils/gradient_button.dart';
import 'add_dare_page.dart';
import 'home_page.dart';

class DarePage extends StatefulWidget {
  const DarePage({super.key});

  @override
  State<DarePage> createState() => _DarePageState();
}

class _DarePageState extends State<DarePage> {
  final PackService _packService = PackService();
  final DareService _dareService = DareService();
  final UserService _userService = UserService();
  List<Map<String, dynamic>> dares = List.empty();
  List<Map<String, dynamic>> filteredDares = List.empty();
  List<String> uniqueCategories = [];
  List<String> packIds = [];
  Map<String, String> mapPackNameId = {};
  String selectedCategory = 'All';
  String selectedPackId = 'All';

  DataState dataState = DataState.loading;

  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> filterCards() async {
    List<Map<String, dynamic>> categoryFiltered = selectedCategory == 'All' ? dares : dares.where((dare) => dare['categories'].contains(selectedCategory)).toList();

    if (selectedPackId == 'All') {
      filteredDares = categoryFiltered;
    } else {
      Map<String, dynamic>? pack = await _packService.getPack(selectedPackId);
      if(pack != null) {
        List<String> dareIdsInPack = List<String>.from(pack['ids']);
        filteredDares = categoryFiltered.where((dare) => dareIdsInPack.contains(dare['dareId'])).toList();
      }
    }
    setState(() {});
  }

  Future<void> _loadData() async {
    dataState = DataState.loading;
    dares = await _dareService.getUserDares(userId);
    filteredDares = dares;

    packIds = await _userService.getPackIdsByType(userId, "dare");
    for(var packId in packIds) {
      mapPackNameId[packId] = await _packService.getPackName(packId);
    }

    for (var dare in dares) {
      // Extract unique categories
      if (dare['categories'] != null) {
        for (var categorie in dare['categories']) {
          if (!uniqueCategories.contains(categorie)) {
            uniqueCategories.add(categorie);
          }
        }
      }
    }
    dataState = dares.isEmpty ? DataState.empty : DataState.loaded;

    setState(() {}); // Trigger a rebuild after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dares,
          style: TextStyle(
            fontFamily: "Mulish",
            fontSize: 24,
            color: AppColors.textIndigo
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
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredDares.length,
                  itemBuilder: (context, index) {
                  final item = filteredDares[index];
                  final name = item['name'] ?? '';
                  final description = item['description'] ?? '';
                  final categories = item['categories'];

                  return Card(
                    color: AppColors.backgroundGreen,
                    child: Column(
                      children: [
                        ExpansionTile(
                          leading: const FlutterLogo(size: 56.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text('$name'),
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
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text('$description'),
                                  const SizedBox(height: 20),
                                  if(item['creatorId'] == userId)
                                    Row(
                                      children: [
                                        GradientButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AddDarePage(dare: item)
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
                                            removeDialog(item["id"]);
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
                      builder: (_) => const AddDarePage()
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

  void removeDialog(String dareId) {
    bool isLoading = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialog) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.delete_dare, style: TextStyle(fontSize: 24, color: AppColors.textIndigo)),
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
                            child: Text(AppLocalizations.of(context)!.confirm),
                            onPressed: () async {
                              isLoading = true;
                              setStateDialog(() {});
                              await _dareService.deleteDare(dareId);
                              _loadData();
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.dare_deleted,
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
