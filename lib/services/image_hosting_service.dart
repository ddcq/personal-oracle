import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageHostingService {
  // IMPORTANT: Replace with your actual Firebase Hosting domain
  static const String _firebaseHostingBaseUrl = 'https://YOUR_FIREBASE_HOSTING_DOMAIN.web.app';

  Future<File> downloadImage(String imagePath) async {
    // imagePath should be the path relative to your Firebase Hosting public directory
    // e.g., 'images/my_image.jpg' if your image is in public/images/my_image.jpg

    final localFile = await _getLocalFile(imagePath);

    if (await localFile.exists()) {
      return localFile;
    } else {
      try {
        final imageUrl = '$_firebaseHostingBaseUrl/\$imagePath';
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          await localFile.writeAsBytes(response.bodyBytes);
          return localFile;
        } else {
          throw Exception('widgets_custom_video_player_failed_download'.tr(namedArgs: {'url': imageUrl, 'statusCode': '${response.statusCode}'}));
        }
      } catch (e) {
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