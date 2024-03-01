import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/utils/EnumData.dart';
import 'package:leitner/utils/DailyMetrics.dart';

import '../business/CardRepository.dart';
import 'AnswerPage.dart';
import 'HomePage.dart';
import 'CardPage.dart';

class DailyPage extends StatefulWidget {
  final DailyMetrics dailyMetrics;
  const DailyPage({super.key, required this.dailyMetrics});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final _formKey = GlobalKey<FormState>();
  final reponseController = TextEditingController();
  final CardRepository _cardRepository = CardRepository();
  dynamic card = {};
  int periode = 1;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  DataState dataState = DataState.loading;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      card = await _cardRepository.getRandomCard(userId);
      periode = await _cardRepository.getUserCardPeriode(userId, card['id']);
    } catch (e) {
      dataState = DataState.empty;
    }
    if(dataState == DataState.loading) {
      dataState = DataState.loaded;
    }
    setState(() {}); // Trigger a rebuild after data is loaded
  }

  @override
  void dispose() {
    super.dispose();
    reponseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.daily),
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
            child: SingleChildScrollView(
              child: (dataState == DataState.loading)
              ? buildLoadingWidget()
              : (dataState == DataState.empty)
                ? buildEmptyWidget(context)
                : buildContentWidget(context)
            ),
          ),
          buildBottomButtons(context)
        ],
      ),
    );
  }

  buildLoadingWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const SizedBox(
        height: 500,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  buildEmptyWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        height: 500,
        width: double.infinity,
        child: Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.no_cards,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "Mulish",
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                AppLocalizations.of(context)!.come_back,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "Mulish",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildContentWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        height: 500,
        width: double.infinity,
        child: Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  card['question'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "Mulish",
                  ),
                ),
              ),
              if(card['questionImgPath'] != null && card['questionImgPath'].isNotEmpty)
                Image.network(
                  card['questionImgPath'],
                  fit: BoxFit.contain,
                  height: 300,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  buildBottomButtons(BuildContext context) {
    switch(dataState) {
      case DataState.empty :
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(AppLocalizations.of(context)!.home),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(AppLocalizations.of(context)!.list),
                ),
              ),
            ),
          ],
        );

      case DataState.loaded :
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: AppLocalizations.of(context)!.answer,
                    hintText: AppLocalizations.of(context)!.enter_answer,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.error_required_fields;
                    }
                    return null;
                  },
                  controller: reponseController,
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final reponseInput = reponseController.text;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnswerPage(
                            widget.dailyMetrics,
                            reponseInput,
                            card['reponseKey'] ?? '',
                            card['reponseText'] ?? '',
                            card['reponseImgPath'] ?? '',
                            card['id'],
                            userId,
                            periode,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.send),
                ),
              ),
            ],
          ),
        );

      default :
        return Container();
    }
  }
}