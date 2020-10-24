import 'package:flutter/material.dart';

class ProgressIndicatorUtility {
  Widget getCircularProgressIndicator(String label) {
    return Center(
        child: Padding(
            child: Column(children: <Widget>[
              Container(
                  child: CircularProgressIndicator(strokeWidth: 3),
                  width: 32,
                  height: 32),
              Center(child: Text(label))
            ]),
            padding: EdgeInsets.only(bottom: 16)));
  }
}
