import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:instapost/database/databasehelper.dart';
import 'package:instapost/model/post.dart';
import 'package:instapost/services/serveroperations.dart';
import 'customcachemanager.dart';

class PostOperations {
  CustomCacheManager customCacheManager = CustomCacheManager();
  List<int> postIds = new List();

  PostOperations() {}

  Future<int> createPost(Map<String, dynamic> postDetails) async {
    final response = await ServerOperation().postDataToServer(
        'https://bismarck.sdsu.edu/api/instapost-upload/post',
        jsonEncode(postDetails));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['result'] == 'success') {
      return jsonDecode(response.body)['id'];
    }

    return -1;
  }

  Future<List<int>> getPostIdsByNickName(String nickName) async {
    var response;
    try {
      String url =
          "https://bismarck.sdsu.edu/api/instapost-query/nickname-post-ids?nickname=$nickName";
      response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200)
        customCacheManager.writeDataToCache(nickName + '.json', response.body);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["result"] == 'success')
        return List.from(jsonDecode(response.body)["ids"]);
    } on SocketException catch (_) {
      response = await customCacheManager.readDataFromCache(nickName + '.json');
      if (response != null)
        return List.from(jsonDecode(response)["ids"]);
      else
        null;
    } on Exception catch (_) {
      return null;
    }

    return null;
  }

  Future<List<int>> getPostIdsByHashTags(String hashTags) async {
    var response;
    try {
      String url =
          "https://bismarck.sdsu.edu/api/instapost-query/hashtags-post-ids?hashtag=" +
              hashTags.replaceAll("#", '%23');
      response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200)
        customCacheManager.writeDataToCache(hashTags + '.json', response.body);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["result"] == 'success')
        return List.from(jsonDecode(response.body)["ids"]);
    } on SocketException catch (_) {
      response = await customCacheManager.readDataFromCache(hashTags + '.json');
      return List.from(jsonDecode(response)["ids"]);
    } on Exception catch (_) {
      return null;
    }

    return List();
  }

  Future<Post> getPost(int postId) async {
    var response;
    Post post = null;
    try {
      String url =
          "https://bismarck.sdsu.edu/api/instapost-query/post?post-id=$postId";
      response = await ServerOperation().getDataFromServer(url);

      if (response.statusCode == 200 &&
          jsonDecode(response.body)["result"] == 'success') {
        customCacheManager.writeDataToCache(
            'post_' + postId.toString() + '.json', response.body);
        Map<String, dynamic> data = json.decode(response.body)["post"];

        post = Post.fromJson(data);
      }
    } on SocketException catch (_) {
      response = await customCacheManager
          .readDataFromCache('post_' + postId.toString() + '.json');

      if (response != null) {
        Map<String, dynamic> data = json.decode(response)['post'];
        post = Post.fromJson(data);
      } else
        return null;
    } on Exception catch (_) {
      return null;
    }

    return post;
  }

  Future<PickedFile> getFromGallery() async {
    return await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
    );
  }

  Future<String> getImage(int imageId) async {
    var response;
    try {
      String url =
          "https://bismarck.sdsu.edu/api/instapost-query/image?id=$imageId";
      response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200)
        customCacheManager.writeDataToCache(
            'image_' + imageId.toString() + '.json', response.body);

      return jsonDecode(response.body)["image"];
    } on SocketException catch (_) {
      response = await customCacheManager
          .readDataFromCache('image_' + imageId.toString() + '.json');
      return jsonDecode(response)["image"];
    } on Exception catch (_) {
      return null;
    }
  }

  Future<bool> attachImageWithAPost(Map<String, dynamic> postDetails) async {
    final response = await ServerOperation().postDataToServer(
        'https://bismarck.sdsu.edu/api/instapost-upload/image',
        jsonEncode(postDetails));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['result'] == 'success') return true;
    return false;
  }

  Future<bool> addARating(Map<String, dynamic> postDetails) async {
    final response = await ServerOperation().postDataToServer(
        'https://bismarck.sdsu.edu/api/instapost-upload/rating',
        jsonEncode(postDetails));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['result'] == 'success') return true;
    return false;
  }

  Future<bool> addAComment(Map<String, dynamic> postDetails) async {
    final response = await ServerOperation().postDataToServer(
        'https://bismarck.sdsu.edu/api/instapost-upload/rating',
        jsonEncode(postDetails));
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['result'] == 'success') return true;
    return false;
  }

  Future<int> uploadPendingPost(
      List<Map<String, dynamic>> uploads, String password) async {
    for (Map<String, dynamic> upload in uploads) {
      Map<String, dynamic> postDetails = new Map();

      postDetails['email'] = upload['email'];
      postDetails['password'] = password;
      postDetails['text'] = upload['comment'];
      postDetails['hashtags'] = jsonDecode(upload['hashtag']);

      int postId = await createPost(postDetails);
      if (postId != null && postId > 0 && upload['picture'] != '') {
        postDetails.clear();
        postDetails['email'] = upload['email'];
        postDetails['password'] = password;
        postDetails['post-id'] = postId;
        postDetails['image'] = upload['picture'];
        await attachImageWithAPost(postDetails);
      }

      await DatabaseHelper.instance.delete(upload['_id']);
    }
    return uploads.length;
  }

  Future<List<String>> getAllHashTags() async {
    if (await ServerOperation().checkConnection()) {
      String url = "https://bismarck.sdsu.edu/api/instapost-query/hashtags";
      final response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200)
        customCacheManager.writeDataToCache(
            'hashtags.json', response.body.toString());
      return List.from(jsonDecode(response.body)["hashtags"]);
    } else {
      String response =
          await customCacheManager.readDataFromCache('hashtags.json');
      return List.from(jsonDecode(response)["hashtags"]);
    }
  }
}
