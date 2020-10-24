import 'package:flutter/material.dart';

class Session with ChangeNotifier {
  String email;
  String password;

  Session({this.email, this.password});

  void createSession(String email, String password) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  Session getSession() {
    return this;
  }

  void destroySession() {
    this.email = null;
    this.password = null;
    notifyListeners();
  }
}
