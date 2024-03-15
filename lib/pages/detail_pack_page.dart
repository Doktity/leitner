import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/pages/pack_page.dart';
import 'package:leitner/services/card_service.dart';
import 'package:leitner/services/dare_service.dart';
import 'package:leitner/services/pack_service.dart';
import 'package:leitner/services/user_service.dart';
import 'package:leitner/utils/enum_data.dart';
import 'package:leitner/utils/spoiler_text.dart';

import '../app_colors.dart';
import '../utils/gradient_app_bar.dart';
import '../utils/gradient_button.dart';

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
  final UserService _userService = UserService();
  final DareService _dareService = DareService();
  List<Map<String, dynamic>> items = [];
  String username = "";
  String creatorName = "";
  DataState dataState = DataState.loading;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try{
      username = await _userService.getUserName(userId);
      creatorName = await _userService.getUserName(widget.pack['userId']);
      List<String> ids = widget.pack['ids'].cast<String>();
      if(widget.pack['type'] == 'card') {
        items = await _cardService.getListCards(ids);
      } else {
        items = await _dareService.getListDares(ids);
      }
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
      await _packService.removePackId(userId, widget.pack['id']);
    } else {
      await _packService.addLienCard(userId, widget.pack['id']);
      await _packService.addPackId(userId, widget.pack['id']);
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
      backgroundColor: AppColors.backgroundGreen,
      appBar: GradientAppBar(
        title: name,
        onLeadingPressed: () {
          // Navigate to PackPage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PackPage()),
                (Route<dynamic> route) => false,
          );
        },
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
                          Text(AppLocalizations.of(context)!.cards_number(items.length)),
                          Text(creatorName)
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
                              fontSize: 24,
                              color: AppColors.textIndigo
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              var item = items[index];
                              if(widget.pack['type'] == 'card') {
                                return ListTile(
                                  title: Text(item['question']),
                                  subtitle: SpoilerText(text: item['reponseKey']),
                                );
                              } else {
                                return ListTile(
                                  title: Text(item['name']),
                                  subtitle: Text(item['description']),
                                );
                              }

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
                ? GradientButton(
                  onPressed: () {
                    _showDialog();
                  },
                  colors: isSubscribed ? [AppColors.pastelPinkLight, AppColors.pastelPink] : [AppColors.pastelGreenLight, AppColors.pastelGreen],
                  padding: 10,
                  child: Text(
                      isSubscribed ? AppLocalizations.of(context)!.unsubscribe : AppLocalizations.of(context)!.subscribe,
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.textIndigo
                      ),
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
