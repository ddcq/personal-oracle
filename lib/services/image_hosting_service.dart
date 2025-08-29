
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class ImageHostingService {
  // IMPORTANT: Replace with your actual Firebase Hosting domain
  static const String _firebaseHostingBaseUrl = 'https://YOUR_FIREBASE_HOSTING_DOMAIN.web.app';

  Future<File> downloadImage(String imagePath) async {
    // imagePath should be the path relative to your Firebase Hosting public directory
    // e.g., 'images/my_image.jpg' if your image is in public/images/my_image.jpg

    final localFile = await _getLocalFile(imagePath);

    if (await localFile.exists()) {
      print('Image found in cache: \${localFile.path}');
      return localFile;
    } else {
      print('Image not found in cache, downloading from Firebase Hosting: \$imagePath');
      try {
        final imageUrl = '$_firebaseHostingBaseUrl/\$imagePath';
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          await localFile.writeAsBytes(response.bodyBytes);
          print('Image downloaded and cached: \${localFile.path}');
          return localFile;
        } else {
          throw Exception('Failed to download image from \$imageUrl: \${response.statusCode}');
        }
      } catch (e) {
        print('Error downloading image \$imagePath: \$e');
        rethrow;
      }
    }
  }

  Future<File> _getLocalFile(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    // Sanitize imagePath to create a valid file path, replacing slashes with underscores
    final sanitizedImagePath = imagePath.replaceAll('/', '_');
    final localPath = p.join(directory.path, 'hosting_image_cache', sanitizedImagePath);
    final file = File(localPath);
    await file.parent.create(recursive: true); // Ensure directory exists
    return file;
  }
}
