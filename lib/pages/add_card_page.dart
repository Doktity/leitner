import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leitner/services/card_service.dart';

import '../services/firebase_storage_service.dart';
import '../utils/image_handler.dart';
import 'card_page.dart';

class AddCardPage extends StatefulWidget {
  final Map<String, dynamic>? card;

  const AddCardPage({Key? key, this.card}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {

  final _formKey = GlobalKey<FormState>();
  final CardService _cardService = CardService();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  bool isCreation = true;

  final questionController = TextEditingController();
  final reponseKeyController = TextEditingController();
  final reponseTextController = TextEditingController();
  final categorieController = TextEditingController();
  final imageNameController = TextEditingController();
  String selectedType = "truc";
  DateTime selectedDateTime = DateTime.now();
  String selectedCategorie = '';
  List<String> categories = [];
  List<String> predefinedCategories = [];
  String questionPath = "";
  String reponsePath = "";
  CustomImageInfo? questionImageInfo;
  CustomImageInfo? reponseImageInfo;

  @override
  void initState() {
    super.initState();
    if(widget.card != null) {
      isCreation = false;
      questionController.text = widget.card!['question'];
      reponseKeyController.text = widget.card!['reponseKey'];
      reponseTextController.text = widget.card!['reponseText'];
      questionPath = widget.card!['questionImgPath'];
      reponsePath = widget.card!['reponseImgPath'];
      for(String cat in widget.card!['categorie']) {
        categories.add(cat);
      }
      setState(() {});
    }
    fetchCategories();
  }

  fetchCategories() async {
    predefinedCategories = await _cardService.getCategories();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    questionController.dispose();
    reponseKeyController.dispose();
    reponseTextController.dispose();
    categorieController.dispose();
    imageNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: isCreation ? Text(AppLocalizations.of(context)!.add) : Text("Update"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to HomePage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const CardPage()),
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
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: AppLocalizations.of(context)!.question,
                      hintText: AppLocalizations.of(context)!.enter_question,
                      border: const OutlineInputBorder()
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return AppLocalizations.of(context)!.error_required_fields;
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
                        labelText: AppLocalizations.of(context)!.answer,
                        hintText: AppLocalizations.of(context)!.enter_answer,
                        border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return AppLocalizations.of(context)!.error_required_fields;
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
                        labelText: AppLocalizations.of(context)!.further_details,
                        hintText: AppLocalizations.of(context)!.enter_further_details,
                        border: OutlineInputBorder()
                    ),
                    controller: reponseTextController,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.red.shade50,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if(textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      } else {
                        return predefinedCategories.where((String option) {
                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        });
                      }
                    },
                    fieldViewBuilder: (BuildContext context, categorieController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: categorieController,
                        focusNode: fieldFocusNode,
                        validator: (value) {
                          if (categories.isEmpty) {
                            return AppLocalizations.of(context)!.error_label_missing;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: AppLocalizations.of(context)!.add_label,
                          hintText: AppLocalizations.of(context)!.enter_label,
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if(categorieController.text.isNotEmpty && !categories.contains(categorieController.text)) {
                                setState(() {
                                  categories.add(categorieController.text);
                                  categorieController.clear();
                                });
                              };

                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      );
                    },
                    onSelected: (String selection) {
                      setState(() {
                        if (!categories.contains(selection)) {
                          categories.add(selection);
                        }
                        categorieController.text = selection;
                        categorieController.clear();
                      });
                    },
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
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Open dialog for selecting question image
                            _showDialog('question');
                          },
                          child: Text(AppLocalizations.of(context)!.add_question_image),
                        ),
                      ),
                      const SizedBox(height: 10), // Spacing
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Open dialog for selecting response image
                            _showDialog('response');
                          },
                          child: Text(AppLocalizations.of(context)!.add_reponse_image),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        final question = questionController.text;
                        final reponseKey = reponseKeyController.text;
                        final reponseText = reponseTextController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppLocalizations.of(context)!.sending)
                            )
                        );
                        FocusScope.of(context).requestFocus(FocusNode());

                        // Id de l'utilisateur connecté
                        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                        if(questionImageInfo != null){
                          questionPath = await _storageService.uploadImageToFirebase(questionImageInfo);
                        }
                        if(reponseImageInfo != null){
                          reponsePath = await _storageService.uploadImageToFirebase(reponseImageInfo);
                        }

                        // Data model pour Card
                        Map<String, dynamic> cardData = {
                          "question" : question,
                          "reponseKey" : reponseKey,
                          "reponseText" : reponseText,
                          "questionImgPath" : questionPath,
                          "reponseImgPath" : reponsePath,
                          "dateCreation" : DateTime.now(),
                          "categorie" : categories
                        };

                        if(isCreation) {
                          // ajout dans la base de données
                          _cardService.addCard(userId, cardData);
                        } else {
                          // update dans la base de données
                          _cardService.updateCard(widget.card!['cardId'], cardData);
                        }


                        // Override the Snackbar
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.card_sent,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Redirect to ListPage after a delay
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CardPage()),
                        );

                      }
                    },
                    child: Text(AppLocalizations.of(context)!.send)
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
  void _showDialog(String imagePathType) {
    CustomImageInfo? selectedImage = null;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder (
            builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.add_image),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: imageNameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: AppLocalizations.of(context)!.image_name,
                          border: OutlineInputBorder()
                      )
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      String customImageName = imageNameController.text
                          .isNotEmpty
                          ? imageNameController.text
                          : imagePathType;
                      selectedImage =
                      await pickImage(ImageSource.camera, customImageName);
                      setStateDialog(() {});
                    },
                    child: Text(AppLocalizations.of(context)!.take_photo),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      String customImageName = imageNameController.text
                          .isNotEmpty
                          ? imageNameController.text
                          : imagePathType;
                      selectedImage =
                      await pickImage(ImageSource.gallery, customImageName);
                      setStateDialog(() {});
                    },
                    child: Text(AppLocalizations.of(context)!.choose_gallery),
                  ),
                  const SizedBox(height: 20,),
                  if(selectedImage != null)
                    Image.memory(
                      selectedImage!.file,
                      fit: BoxFit.contain,
                      height: 200,
                      width: 200,
                      frameBuilder: ((context, child, frame,
                          wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: frame != null
                              ? child
                              : const CircularProgressIndicator(),
                        );
                      }),
                    )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.confirm),
                  onPressed: () {
                    if (selectedImage != null) {
                      if (imageNameController.text.isNotEmpty &&
                          imageNameController.text !=
                              selectedImage!.customName) {
                        selectedImage!.customName = imageNameController.text;
                      }
                      if (imagePathType == "question") {
                        questionImageInfo = selectedImage;
                      } else {
                        reponseImageInfo = selectedImage;
                      }
                      setState(() {}); // Update the main page state
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        }
    );
  }
}
