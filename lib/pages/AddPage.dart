import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

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
  String selectedType = "truc";
  DateTime selectedDateTime = DateTime.now();

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
      appBar: AppBar(
        title: Text("Ajout"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
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
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
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
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(value: 'truc', child: Text("truc")),
                      DropdownMenuItem(value: 'muche', child: Text("muche")),
                      DropdownMenuItem(value: 'troc', child: Text("troc")),
                      DropdownMenuItem(value: 'trac', child: Text("trac")),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder()
                    ),
                    value: 'truc',
                    onChanged: (value){
                      setState(() {
                        selectedType = value!;
                      });
                    }
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Informations supplémentaires",
                        hintText: "Entrez des informations, des explications ...",
                        border: OutlineInputBorder()
                    ),
                    controller: reponseTextController,
                  ),
                ),
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
                          "questionImgPath" : question,
                          "reponseImgPath" : reponseKey,
                          "dateCreation" : DateTime.now(),
                          "categorie" : selectedType,
                          "reponseText" : reponseText
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
