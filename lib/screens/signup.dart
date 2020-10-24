import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instapost/components/snackbar.dart';
import 'package:instapost/model/user.dart';
import 'login.dart';
import 'package:instapost/services/useroperations.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String firstName;
  String lastName;
  String nickName;
  String email;
  String password;
  bool isEmailValid = true;
  bool isNickNameValid = true;
  final _formKey = GlobalKey<FormState>();
  final signUpScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: signUpScaffoldKey,
      backgroundColor: Colors.orange,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
        title: Text('Insta Post: Sign Up'),
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
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Enter First Name";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                    onSaved: (input) => firstName = input,
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    // ignore: missing_return
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Enter Last Name";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                    onSaved: (input) => this.lastName = input,
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Enter NickName";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Nickname',
                    ),
                    onSaved: (input) => this.nickName = input,
                  ),
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
                    onSaved: (input) => this.email = input,
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
                    onSaved: (input) => this.password = input,
                  ),
                ),
                ButtonTheme(
                  height: 40.0,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        User user = new User(
                            firstName: this.firstName,
                            lastName: this.firstName,
                            nickName: this.nickName,
                            email: this.email,
                            password: this.password);

                        UserOperations().registerUser(user).then((value) {
                          if (value == 'success') {
                            signUpScaffoldKey.currentState.showSnackBar(
                                SnackBarUtility().getSnackBar(
                                    "Yaay! you're registered now"));
                            _formKey.currentState.reset();
                          } else
                            signUpScaffoldKey.currentState.showSnackBar(
                                SnackBarUtility()
                                    .getSnackBar("Sorry," + " " + value));
                        });
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      'Sign up',
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
                    onPressed: () => Navigator.pop(context),
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
              ])),
        ),
      ),
    );
  }
}
