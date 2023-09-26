import 'dart:ffi';

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
  final reponseController = TextEditingController();
  String selectedType = "truc";
  DateTime selectedDateTime = DateTime.now();

  @override
  void dispose() {
    super.dispose();

    questionController.dispose();
    reponseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
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
                  controller: reponseController,
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
                child: DateTimeFormField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: "Temps"
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) => (e?.day ?? 0) == 1 ? "Please not the first day" : null,
                  onDateSelected: (DateTime value){
                    setState(() {
                      selectedDateTime = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()){
                      final question = questionController.text;
                      final reponse = reponseController.text;
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours"))
                      );
                      FocusScope.of(context).requestFocus(FocusNode());

                      // ajout dans la base de données
                      CollectionReference cards = FirebaseFirestore.instance.collection("Cards");
                      cards.add({
                        "question" : question,
                        "reponse" : reponse,
                        "questionImgPath" : question,
                        "reponseImgPath" : reponse,
                        "date" : selectedDateTime
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
    );
  }
}
