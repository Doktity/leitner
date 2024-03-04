import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class CustomImageInfo {
  Uint8List file;
  String customName;
  String path;

  CustomImageInfo({required this.file, required this.customName, required this.path});
}

Future<CustomImageInfo?> pickImage(ImageSource source, String customName) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: source);

  if(image != null) {
    final Uint8List imageAsBytes = await image.readAsBytes();
    return CustomImageInfo(file: imageAsBytes, customName: customName, path: image.path);
  }

  return null;
}