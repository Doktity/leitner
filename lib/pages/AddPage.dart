import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'HomePage.dart';
import 'ListPage.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final _formKey = GlobalKey<FormState>();

  final questionController = TextEditingController();
  final reponseKeyController = TextEditingController();
  final reponseTextController = TextEditingController();
  final categorieController = TextEditingController();
  String selectedType = "truc";
  DateTime selectedDateTime = DateTime.now();
  List<String> categories = [];

  @override
  void dispose() {
    super.dispose();

    questionController.dispose();
    reponseKeyController.dispose();
    reponseTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to HomePage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  color: Colors.red.shade50,
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Question",
                      hintText: "Entrez la question",
                      border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return "Champs obligatoire";
                      }
                      return null;
                    },
                    controller: questionController,
                  ),
                ),
                Container(
                  color: Colors.red.shade50,
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Réponse",
                        hintText: "Entrez la réponse",
                        border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return "Champs obligatoire";
                      }
                      return null;
                    },
                    controller: reponseKeyController,
                  ),
                ),
                Container(
                  color: Colors.red.shade50,
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Informations supplémentaires",
                        hintText: "Entrez des informations, des explications ...",
                        border: OutlineInputBorder()
                    ),
                    controller: reponseTextController,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.red.shade50,
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Ajouter une catégorie",
                      hintText: "Entrez une catégorie pour la question",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            categories.add(categorieController.text);
                            categorieController.clear();
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    validator: (value) {
                      if (categories.isEmpty) {
                        return "Ajoutez au moins une catégorie";
                      }
                      return null;
                    },
                    controller: categorieController,
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: categories.map((categorie) {
                    return Chip(
                      label: Text(categorie),
                      onDeleted: () {
                        setState(() {
                          categories.remove(categorie);
                        });
                      },
                    );
                  }).toList(),
                ),
/*
@todo AJOUTER IMAGE WIP

                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.of(context).restorablePush(_dialogBuilder);
                      },
                      child: Text("Ajouter une image"),
                    ),
                  ),
                ),
*/
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        final question = questionController.text;
                        final reponseKey = reponseKeyController.text;
                        final reponseText = reponseTextController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Envoi en cours"))
                        );
                        FocusScope.of(context).requestFocus(FocusNode());

                        // ajout dans la base de données
                        CollectionReference cards = FirebaseFirestore.instance.collection("Cards");
                        cards.add({
                          "question" : question,
                          "reponseKey" : reponseKey,
                          "reponseText" : reponseText,
                          "questionImgPath" : question,
                          "reponseImgPath" : reponseKey,
                          "dateCreation" : DateTime.now(),
                          "categorie" : categories,
                          "periode" : 1,
                        }).then((_) {
                          Future.delayed(Duration(seconds: 1), () {

                            // Override the Snackbar
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Carte envoyé",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Redirect to ListPage after a delay
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ListPage()),
                            );
                          });
                        });

                      }
                    },
                    child: Text("Envoyer")
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }


  /* MODAL POUR L'AJOUT DE L'IMAGE */
  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une image'),
          content: Column(
            children: [
              DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(value: 'question', child: Text("question")),
                    DropdownMenuItem(value: 'reponse', child: Text("reponse")),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: 'question',
                  onChanged: (value){
                  }
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Lien de l'image",
                    hintText: "Entrez le lien",
                    border: OutlineInputBorder()
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
              ),
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
