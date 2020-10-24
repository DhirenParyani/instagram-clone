import 'dart:convert';
import 'dart:io';

import 'package:instapost/database/databasehelper.dart';
import 'package:instapost/model/user.dart';
import 'package:instapost/services/customcachemanager.dart';
import 'package:instapost/services/postoperations.dart';
import 'serveroperations.dart';

class UserOperations {
  CustomCacheManager customCacheManager = CustomCacheManager();

  UserOperations() {}

  Future<String> registerUser(User user) async {
    final response = await ServerOperation().postDataToServer(
        'https://bismarck.sdsu.edu/api/instapost-upload/newuser',
        jsonEncode(user));

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['result'] == "success") {
      return "success";
    } else if (jsonDecode(response.body)['result'] == "fail")
      return jsonDecode(response.body)['errors'];
  }

  Future<bool> checkLoginCredentials(String email, String password) async {
    String url =
        "https://bismarck.sdsu.edu/api/instapost-query/authenticate?email=$email&password=$password";
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['result'] == true) {
      //https://bismarck.sdsu.edu/api/instapost-query/authenticate?email=$email&password=$password
      return true;
    }

    return false;
  }

  Future<bool> checkIfUserExists(User user) async {
    String firstName = user.firstName,
        lastName = user.lastName,
        nickName = user.nickName,
        email = user.email,
        password = user.password;

    String url =
        "https://bismarck.sdsu.edu/api/instapost-upload/newuser?firstname=$firstName&lastname=$lastName&nickname=$nickName&email=$email&password=$password";
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> checkIfNickNameIsTaken(String nickName) async {
    String url =
        " https://bismarck.sdsu.edu/api/instapost-query/nickname-exists?nickname=$nickName";
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200 &&
        jsonDecode(response.body)["result"] == true) {
      return true;
    } else
      return false;
  }

  Future<bool> checkIfEmailIsTaken(String email) async {
    String url =
        "https://bismarck.sdsu.edu/api/instapost-query/email-exists?email=$email";
    final response = await ServerOperation().getDataFromServer(url);
    if (response.statusCode == 200 &&
        jsonDecode(response.body)["result"] == true) {
      return true;
    } else
      return false;
  }

  Future<List<String>> getAllNickNames() async {
    if (await ServerOperation().checkConnection()) {
      String url = "https://bismarck.sdsu.edu/api/instapost-query/nicknames";
      final response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200)
        customCacheManager.writeDataToCache(
            'nicknames.json', response.body.toString());
      return List.from(jsonDecode(response.body)["nicknames"]);
    } else {
      String response =
          await customCacheManager.readDataFromCache('nicknames.json');
      return List.from(jsonDecode(response)["nicknames"]);
    }
  }

  Future<int> getPendingPostsForSpecificUser(
      String user, String password) async {
    if (await ServerOperation().checkConnection()) {
      List<Map<String, dynamic>> pendingUploads =
          await DatabaseHelper.instance.queryForAnEmail(user);
      if (pendingUploads.length > 0)
        return await PostOperations()
            .uploadPendingPost(pendingUploads, password);
    }
    return 0;
  }
}
