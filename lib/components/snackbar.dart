import 'package:flutter/material.dart';

class SnackBarUtility {
  Widget getSnackBar(String content) {
    return SnackBar(content: Text(content));
  }
}
