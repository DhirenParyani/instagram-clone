import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  Future<void> saveToDisk<T>(String key, T content) async {
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  dynamic readFromDisk<T>(String key, T content) async {
    if (_preferences.containsKey(key)) {
      if (content is String) {
        return _preferences.getString(key);
      } else if (content is bool) {
        return _preferences.getBool(key);
      } else if (content is int) {
        return _preferences.getInt(key);
      } else if (content is double) {
        return _preferences.getDouble(key);
      } else if (content is List<String>) {
        return _preferences.getStringList(key);
      }
    }
    return '';
  }

  bool clearStorage() {
    _preferences.clear();
    return true;
  }

  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  bool isSessionActive() {
    return (_preferences.containsKey("email") &&
            _preferences.containsKey("password"))
        ? true
        : false;
  }
}
