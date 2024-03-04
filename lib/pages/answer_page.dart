import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leitner/pages/stat_page.dart';
import 'package:leitner/services/dare_service.dart';
import 'package:leitner/utils/daily_metrics.dart';

import '../services/card_service.dart';
import 'daily_page.dart';

class AnswerPage extends StatefulWidget {
  final DailyMetrics dailyMetrics;
  final String userInput;
  final String reponseKey;
  final String reponseText;
  final String reponseImgPath;
  final String cardId;
  final String userId;
  final int periode;

  AnswerPage(this.dailyMetrics, this.userInput, this.reponseKey, this.reponseText, this.reponseImgPath, this.cardId, this.userId, this.periode);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final CardService _cardService = CardService();
  final DareService _dareService = DareService();

  Map<String, dynamic> dare = {};
  bool showDareButton = false;
  late bool isCorrect;

  bool _isCorrect(String input, String reponse){
    if(input.toLowerCase() == reponse.toLowerCase()){
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    isCorrect = _isCorrect(widget.userInput, widget.reponseKey);
    showDareButton = widget.dailyMetrics.handleGamemodeLogic(isCorrect);
    _manageMetrics();
    _loadData();
  }

  void _loadData() async {
    var fetchedDare = await _dareService.getRandomDare(widget.userId);
    if(mounted) {
      setState(() {
        dare = fetchedDare;
      });
    }
  }

  void _manageMetrics() {
    widget.dailyMetrics.cardAnswered(isCorrect);
    widget.dailyMetrics.addCardId(widget.cardId);
    if(showDareButton) widget.dailyMetrics.addDareId(dare["id"]);
  }

  @override
  Widget build(BuildContext context) {
    _cardService.updatePeriode(isCorrect, widget.periode, widget.userId, widget.cardId);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.answer),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: isCorrect ? Colors.green : Colors.red,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Center(
                        child: Text(
                          isCorrect ? AppLocalizations.of(context)!.good_job : AppLocalizations.of(context)!.too_bad,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.answer_is("answer", widget.reponseKey)),
                            Text(widget.reponseText),
                            if(widget.reponseImgPath.isNotEmpty)
                              Image.network(
                                widget.reponseImgPath,
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context).size.height * 0.3,
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
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: showDareButton ? _buildDareButton() : _buildBottomNavigationBar(),
      ),
    );
  }

  Future<void> _showDareDialog(BuildContext context, Map<String, dynamic> dare) async {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(dare['name']),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(dare['description']),
                  if(dare['imgPath'].isNotEmpty)
                    Image.network(dare['imgPath']),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.confirm),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  Widget _buildDareButton() {
    return FloatingActionButton(
      child: Icon(Icons.local_fire_department_sharp),
      tooltip: AppLocalizations.of(context)!.dares,
      onPressed: () async {
        await _showDareDialog(context, dare);
        setState(() {
          showDareButton = false;
        });
      },
    );
  }
  
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.replay_outlined),
          label: AppLocalizations.of(context)!.replay,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
      ],
      onTap: (index) async {
        
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailyPage(dailyMetrics: widget.dailyMetrics)),
          );
        } else if (index == 1) {
          widget.dailyMetrics.endSession();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StatPage(dailyMetrics: widget.dailyMetrics)),
          );
        }
      },
    );
  }
}