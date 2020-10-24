import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CustomCacheManager {
  static final CustomCacheManager _instance =
      new CustomCacheManager._internal();

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._internal();

  Future<File> getFileFromCache(String fileName) async {
    var cacheDir = await getTemporaryDirectory();
    if (await File(cacheDir.path + "/" + fileName).exists()) {
      return File(cacheDir.path + "/" + fileName);
    } else
      return new File(cacheDir.path + "/" + fileName);
  }

  Future<void> writeDataToCache(String fileName, var jsonResponse) async {
    File file = await getFileFromCache(fileName);

    if (file != null)
      await file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);
  }

  Future<String> readDataFromCache(String fileName) async {
    try {
      File file = await getFileFromCache(fileName);
      if (file != null || await file.length() != 0) {
        var jsonData = await file.readAsString();

        return jsonData;
      }
    } on Exception catch (_) {
      return null;
    }
    return null;
  }
}
