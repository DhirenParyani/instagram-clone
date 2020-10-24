import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instapost/model/post.dart';
import 'package:instapost/providers/session.dart';
import 'package:instapost/services/localstorageoperations.dart';
import 'package:instapost/services/useroperations.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/home.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/login.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/postlist.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/showcomments.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/showpost.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/signup.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();

  final client = http.Client();

  runApp(
    MultiProvider(providers: [
      //ChangeNotifierProvider<Post>(create: (_) => Post()),
      ChangeNotifierProvider<Session>(create: (_) => Session())
    ], child: MyApp()),
  );
  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalStorageService instance;

  @override
  Widget build(BuildContext context) {
    Widget _defaultHome = new Login();

    return FutureBuilder<bool>(
        future: _getPrefInstance(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return (snapshot.hasData)
              ? MaterialApp(
                  title: 'InstaPost',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData.dark(),
                  // ignore: unrelated_type_equality_checks
                  initialRoute:
                      (instance.isSessionActive()) ? '/Home' : '/Login',
                  routes: {
                    // When navigating to the "/" route, build the FirstScreen widget.
                    //'/': (context) => SignUp(),
                    // When navigating to the "/second" route, build the SecondScreen widget.
                    '/Login': (context) => Login(),
                    '/Home': (context) => Home(),
                    '/PostList': (context) => PostList(),
                    '/ShowPost': (context) => ShowPost(),
                    '/ShowComments': (context) => ShowComments(),
                    '/SignUp': (context) => SignUp(),
                    //ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen()
                  },
                )
              : CircularProgressIndicator();
        });
  }

  Future<bool> _getPrefInstance() async {
    instance = await LocalStorageService.getInstance();
    /*if(instance.isSessionActive())
       {
         Provider.of<Session>(context, listen: true).createSession(instance.readFromDisk("email", String),instance.readFromDisk("password", String));

       }*/
    return true;
  }
}
