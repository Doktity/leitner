import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/services/card_service.dart';
import 'package:leitner/services/pack_service.dart';
import 'package:leitner/utils/enum_data.dart';

import '../business/user_repository.dart';

class DetailPackPage extends StatefulWidget {
  final Map<String, dynamic> pack;

  const DetailPackPage({Key? key, required this.pack}) : super(key : key);

  @override
  State<DetailPackPage> createState() => _DetailPackPageState();
}

class _DetailPackPageState extends State<DetailPackPage> {
  bool isSubscribed = false;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final CardService _cardService = CardService();
  final PackService _packService = PackService();
  final UserRepository _userRepository = UserRepository();
  List<Map<String, dynamic>> cards = [];
  String username = "";
  DataState dataState = DataState.loading;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try{
      username = await _userRepository.getUserName(userId);
      List<String> cardIds = widget.pack['ids'].cast<String>();
      cards = await _cardService.getListCards(cardIds);
      isSubscribed = await _packService.isUserSubscribed(userId, widget.pack['id']);
    } catch(e) {
      dataState = DataState.empty;
    }
    if(dataState == DataState.loading) {
      dataState = DataState.loaded;
    }
    setState(() {});
  }

  Future<void> toggleSubscription() async {
    if(isSubscribed) {
      await _packService.removeLienCard(userId, widget.pack['id']);
    } else {
      await _packService.addLienCard(userId, widget.pack['id']);
    }
    setState(() {
      isSubscribed = !isSubscribed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.pack['name'] ?? '';
    final description = widget.pack['description'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                (dataState == DataState.loaded)
                  ? Card(
                    margin: const EdgeInsets.all(20),
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(description),
                      trailing: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.cards_number(cards.length)),
                          Text(username)
                        ],
                      ),
                    )
                  )
                  : Card(
                    margin: const EdgeInsets.all(20),
                    child: ListTile(),
                  ),
                (dataState == DataState.loaded)
                  ? Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.cards_list,
                            style: TextStyle(
                              fontSize: 24
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cards.length,
                            itemBuilder: (context, index) {
                              var card = cards[index];
                              return ListTile(
                                title: Text(card['question']),
                                subtitle: Text(card['reponseKey']),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  )
                  : const Card(
                    margin: EdgeInsets.all(20),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()
                        ),
                      ),
                    )
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            height: 50,
            child: (dataState == DataState.loaded) 
                ? ElevatedButton(
                  onPressed: () {
                    _showDialog();
                  },
                  child: Text(
                      isSubscribed ? AppLocalizations.of(context)!.unsubscribe : AppLocalizations.of(context)!.subscribe,
                      style: TextStyle(
                        fontSize: 24
                      ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(isSubscribed ? Colors.red : Colors.green),
                    foregroundColor: const MaterialStatePropertyAll(Colors.black)
                  ),
                )
                : ElevatedButton(onPressed: (){}, child: null,),
          )
        ],
      )
    );
  }

  void _showDialog() {
    bool isLoading = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.sure_question),
              content: isLoading
                ? Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20,),
                      Text(AppLocalizations.of(context)!.wait),
                    ],
                  )
                : null,
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
                    setStateDialog(() => isLoading = true);
                    await toggleSubscription();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
