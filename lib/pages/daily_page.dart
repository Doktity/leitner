import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/services/card_service.dart';
import 'package:leitner/utils/enum_data.dart';
import 'package:leitner/utils/daily_metrics.dart';
import 'package:leitner/utils/gradient_app_bar.dart';
import 'package:leitner/utils/life_points.dart';

import '../app_colors.dart';
import '../utils/gradient_button.dart';
import 'answer_page.dart';
import 'home_page.dart';
import 'card_page.dart';

class DailyPage extends StatefulWidget {
  final DailyMetrics dailyMetrics;
  const DailyPage({super.key, required this.dailyMetrics});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final _formKey = GlobalKey<FormState>();
  final reponseController = TextEditingController();
  final CardService _cardService = CardService();
  dynamic card = {};
  int periode = 1;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  DataState dataState = DataState.loading;
  Color borderColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    switch(widget.dailyMetrics.gameMode) {
      case GameMode.classic :
        borderColor = AppColors.pastelGreenDark;
        break;
      case GameMode.survival :
        borderColor = AppColors.pastelYellowDark;
        break;
      case GameMode.suddenDeath :
        borderColor = AppColors.pastelPinkDark;
        break;
      case GameMode.marathon :
        borderColor = AppColors.pastelPurpleDark;
        break;
    }
    try {
      card = await _cardService.getRandomCard(userId);
      periode = await _cardService.getUserCardPeriode(userId, card['id']);
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGreen,
        appBar: GradientAppBar(
          title: "${AppLocalizations.of(context)!.daily} - ${widget.dailyMetrics.getGameMode(context)}",
          onLeadingPressed: () {
            // Navigate to HomePage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        body: Stack(
          children: [
            Column(
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
            if(widget.dailyMetrics.gameMode == GameMode.survival)
            LifePoints(totalLifePoints: widget.dailyMetrics.totalLifePoint, currentLifePoints: widget.dailyMetrics.currentLifePoint)
          ],
        ),
      ),
    );
  }

  buildLoadingWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        height: 500,
        width: double.infinity,
        child: Card(
          color: AppColors.lightGrey,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: const Center(
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
          color: AppColors.lightGrey,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          color: AppColors.lightGrey,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                child: GradientButton(
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
                  child: Text(AppLocalizations.of(context)!.send, style: TextStyle(fontSize: 20, color: AppColors.textIndigo)),
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