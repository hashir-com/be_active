import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageUtility {

  static Future<String?> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(picked.path);
      final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
      return savedImage.path;
    }
    return null;
  }

  // Deletes a file from the provided path.
  static void deleteImage(String? imagePath) {
    if (imagePath != null && File(imagePath).existsSync()) {
      File(imagePath).deleteSync();
    }
  }
}