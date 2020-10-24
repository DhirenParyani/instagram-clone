import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instapost/components/bottomnavigationbar.dart';
import 'package:instapost/database/databasehelper.dart';
import 'package:instapost/providers/session.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final globalSnackBarKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  SharedPreferences _preferences;
  int selectedIndex = 0;

  //CustomCacheManager cacheManager;
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> pendingPosts;

  @override
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        Provider.of<Session>(context, listen: false).createSession(
            value.getString("email"), value.getString("password"));
        _preferences = value;
      });
    });

    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalSnackBarKey,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
          title: Text('Insta Post'),
          actions: <Widget>[
            ButtonTheme(
              height: 10.0,
              minWidth: 30,
              child: RaisedButton(
                onPressed: () {
                  _preferences.clear();
                  Provider.of<Session>(context, listen: false).destroySession();
                  if (Navigator.canPop(context))
                    Navigator.pop(context);
                  else
                    Navigator.pushNamed(context, '/Login');
                },
                color: Colors.redAccent,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BottomNavigationModel.itemNavigation[this.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: BottomNavigationModel.bottomNavBarItem,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: onItemTapped,
        ));
  }
}
