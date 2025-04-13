import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<File?> compressImage(File imageFile, {int quality = 80}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      final fileName = 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '$path/$fileName';

      final image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) {
        return null;
      }

      final compressedImage = img.encodeJpg(image, quality: quality);
      final newFile = File(newPath);
      await newFile.writeAsBytes(compressedImage);
      return newFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  static Future<File?> resizeImage(File imageFile, {int? width, int? height}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      final fileName = 'resized_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '$path/$fileName';

      final image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) {
        return null;
      }

      final resizedImage = img.copyResize(image, width: width, height: height);
      final newFile = File(newPath);
      await newFile.writeAsBytes(img.encodeJpg(resizedImage));
      return newFile;
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }

  // Add more image manipulation functions if needed
}