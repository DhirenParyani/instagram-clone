import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ServerOperation {
  Future<http.Response> getDataFromServer(String url,
      {Map<String, String> headers}) async {
    return await http.get(url);
  }

  Future<http.Response> postDataToServer(String url, var json) async {
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }

  Future<bool> checkConnection() async {
    try {
      String url = "https://bismarck.sdsu.edu/api/ping";
      final response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['message'] == 'pong') {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
