import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../business/DareRepository.dart';
import '../utils/FirebaseStorageService.dart';
import '../utils/ImageHandler.dart';
import 'DarePage.dart';

class AddDarePage extends StatefulWidget {
  final Map<String, dynamic>? dare;

  const AddDarePage({Key? key, this.dare}) : super(key: key);

  @override
  State<AddDarePage> createState() => _AddDarePageState();
}

class _AddDarePageState extends State<AddDarePage> {

  bool isCreation = true;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imgPathController = TextEditingController();
  final categorieController = TextEditingController();
  List<String> categories = [];
  List<String> predefinedCategories = [];
  CustomImageInfo? imageInfo;
  String imgPath = "";

  final DareRepository _dareRepository = DareRepository();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  @override
  void initState() {
    super.initState();
    if(widget.dare != null) {
      isCreation = false;
      nameController.text = widget.dare!['name'];
      descriptionController.text = widget.dare!['description'];
      imgPath = widget.dare!['imgPath'];
      for(String cat in widget.dare!['categories']) {
        categories.add(cat);
      }
      setState(() {});
    }
    fetchCategories();
  }

  fetchCategories() async {
    predefinedCategories = await _dareRepository.getCategories();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    descriptionController.dispose();
    imgPathController.dispose();
    categorieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isCreation ? Text(AppLocalizations.of(context)!.add) : Text("Update"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to HomePage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const DarePage()),
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
                          labelText: "Nom",
                          hintText: "Entrez nom",
                          border: const OutlineInputBorder()
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return AppLocalizations.of(context)!.error_required_fields;
                        }
                        return null;
                      },
                      controller: nameController,
                    ),
                  ),
                  Container(
                    color: Colors.red.shade50,
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Description",
                          hintText: "Entrez une description",
                          border: OutlineInputBorder()
                      ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return AppLocalizations.of(context)!.error_required_fields;
                        }
                        return null;
                      },
                      controller: descriptionController,
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Open dialog for selecting question image
                          _showDialog();
                        },
                        child: Text("Ajouter une image"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()){
                            final name = nameController.text;
                            final description = descriptionController.text;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppLocalizations.of(context)!.sending)
                                )
                            );
                            FocusScope.of(context).requestFocus(FocusNode());

                            // Id de l'utilisateur connecté
                            String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                            if(imageInfo != null){
                              imgPath = await _storageService.uploadImageToFirebase(imageInfo);
                            }

                            // Data model pour Card
                            Map<String, dynamic> dareData = {
                              "name" : name,
                              "description" : description,
                              "imgPath" : imgPath,
                              "creatorId" : userId,
                              "dateCreation" : DateTime.now(),
                              "categories" : categories
                            };

                            if(isCreation) {
                              // ajout dans la base de données
                              _dareRepository.addDare(userId, dareData);
                            } else {
                              // update dans la base de données
                              _dareRepository.updateDare(widget.dare!['id'], dareData);
                            }


                            // Override the Snackbar
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Dare envoyé",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Redirect to ListPage after a delay
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DarePage()),
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
  void _showDialog() {
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
                          controller: imgPathController,
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
                          String customImageName = imgPathController.text
                              .isNotEmpty
                              ? imgPathController.text
                              : "image";
                          selectedImage =
                          await pickImage(ImageSource.camera, customImageName);
                          setStateDialog(() {});
                        },
                        child: Text(AppLocalizations.of(context)!.take_photo),
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          String customImageName = imgPathController.text
                              .isNotEmpty
                              ? imgPathController.text
                              : "image";
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
                          if (imgPathController.text.isNotEmpty &&
                              imgPathController.text !=
                                  selectedImage!.customName) {
                            selectedImage!.customName = imgPathController.text;
                          }
                          imageInfo = selectedImage;
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
