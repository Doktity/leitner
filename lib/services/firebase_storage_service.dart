import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../utils/image_handler.dart';

class FirebaseStorageService {

  Future<String> uploadImageToFirebase(CustomImageInfo? image) async {
    if (image == null) {
      throw Exception('No image selected');
    }

    String filename = 'images/${DateTime.now().millisecondsSinceEpoch}_${image.customName}';
    Reference ref = FirebaseStorage.instance.ref().child(filename);

    if(kIsWeb) {
      // Web Logic
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      TaskSnapshot snapshot = await ref.putData(image.file, metadata);
      return await snapshot.ref.getDownloadURL();
    } else {
      // Mobile Logic
      File file = File(image.path);
      // Upload image
      TaskSnapshot snapshot = await ref.putFile(file);
      return await snapshot.ref.getDownloadURL();
    }
  }
}