import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/services/dare_service.dart';

import '../business/user_repository.dart';
import 'add_dare_page.dart';
import 'home_page.dart';

class DarePage extends StatefulWidget {
  const DarePage({super.key});

  @override
  State<DarePage> createState() => _DarePageState();
}

class _DarePageState extends State<DarePage> {
  final DareService _dareService = DareService();
  final UserRepository _userRepository = UserRepository();
  List<Map<String, dynamic>> dares = List.empty();

  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    dares = await _dareService.getUserDares(userId);
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
                          subtitle: Row(
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
                                  SizedBox(height: 20),
                                  if(item['creatorId'] == userId)
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AddDarePage(dare: item)
                                                ),
                                              );
                                            },
                                            child: Icon(Icons.mode),
                                            style: const ButtonStyle(
                                                backgroundColor: MaterialStatePropertyAll(Colors.cyan),
                                                foregroundColor: MaterialStatePropertyAll(Colors.black)
                                            )
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            removeDialog(item["id"]);
                                          },
                                          child: Icon(Icons.delete_forever),
                                          style: const ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                                              foregroundColor: MaterialStatePropertyAll(Colors.black)
                                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddDarePage()
              )
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
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
                  title: Text(AppLocalizations.of(context)!.delete_dare),
                  content: isLoading
                      ? Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20,),
                        Text(AppLocalizations.of(context)!.wait),
                        ],
                      )
                      : Text(AppLocalizations.of(context)!.sure_question),
                        actions: <Widget>[
                          TextButton(
                            child: Text(AppLocalizations.of(context)!.cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
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
}
