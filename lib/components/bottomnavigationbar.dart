import 'dart:core';

import 'package:flutter/material.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/addpost.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/hashtaglist.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/userlist.dart';

class BottomNavigationModel extends ChangeNotifier {
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> itemNavigation = [
    UserList(),
    AddPost(),
    HashtagList(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  static const List<BottomNavigationBarItem> bottomNavBarItem =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.person_search),
      label: 'Search by Nickname',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_box),
      label: 'Add Post',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.tag),
      label: 'Search by Tag',
    ),
  ];
}
