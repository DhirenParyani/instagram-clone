import 'package:flutter/material.dart';
import 'package:instapost/components/snackbar.dart';

import 'package:instapost/services/useroperations.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  SharedPreferences preferences;
  final loginScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        preferences = value;
      });
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: loginScaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
        title: Text('Insta Post'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Enter Email";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (input) => email = input,
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Enter Password";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (input) => password = input,
                  ),
                ),
                ButtonTheme(
                  height: 40.0,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        bool checkCredentialsValidity = await UserOperations()
                            .checkLoginCredentials(email, password);
                        if (checkCredentialsValidity) {
                          saveUserLoginActivityInDisk(email, password).then(
                              (isSaved) => (isSaved)
                                  ? Navigator.pushNamed(context, '/Home')
                                  : loginScaffoldKey.currentState.showSnackBar(
                                      SnackBarUtility()
                                          .getSnackBar("Try Again!")));
                        } else
                          loginScaffoldKey.currentState.showSnackBar(
                              SnackBarUtility()
                                  .getSnackBar("Wrong Credentials!"));
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                ButtonTheme(
                  height: 40.0,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () => Navigator.pushNamed(context, '/SignUp'),
                    color: Colors.redAccent,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
              ])),
        ),
      ),
    );
  }

  Future<bool> saveUserLoginActivityInDisk(
      String email, String password) async {
    preferences.setString("email", email);
    preferences.setString("password", password);
    return true;
  }
}
