import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instapost/components/snackbar.dart';
import 'package:instapost/database/databasehelper.dart';
import 'package:instapost/providers/session.dart';
import 'package:instapost/services/postoperations.dart';
import 'package:instapost/services/serveroperations.dart';
import 'file:///C:/Users/dparyani7723/AndroidStudioProjects/instapost/lib/screens/home.dart';

import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final dbHelper = DatabaseHelper.instance;
  int postId = -1;
  String text;
  File takenImage;
  String takenImageBase64Encoded;
  final imagePicker = ImagePicker();
  List<String> hashTags;
  bool isPostCreated = false;
  bool isPictureAvailable = false;
  int pendingPostId = -1;
  bool isDescriptionAvailable = false;
  bool isConnectionAvailable = true;

  Future<void> _takePicture() async {
    final imageFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear);
    if (imageFile == null) {
      return;
    }
    setState(() {
      imageFile.readAsBytes().then((value) {
        takenImageBase64Encoded = base64Encode(value);
        takenImage = File(imageFile.path);
      });
    });
  }

  final _formKey = GlobalKey<FormState>();

  void _insert(String email, String text, String hashtag,
      String pictureBase64Encoded) async {
    Map<String, dynamic> row = {
      DatabaseHelper.emailCol: email,
      DatabaseHelper.text: text,
      DatabaseHelper.hashTags: hashtag,
      DatabaseHelper.picture: pictureBase64Encoded
    };

    final id = await dbHelper.insert(row);
    setState(() {
      pendingPostId = id;
    });
  }

  void _update(int id, String email, String pictureBase64Encoded) async {
    Map<String, dynamic> row = {
      DatabaseHelper.id: pendingPostId,
      DatabaseHelper.emailCol: email,
      DatabaseHelper.text: text,
      DatabaseHelper.hashTags: jsonEncode(hashTags),
      DatabaseHelper.picture: pictureBase64Encoded
    };

    final id = await dbHelper.update(row);
  }

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context).getSession();
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          ListTile(
              title: HashTagTextField(
            decoratedStyle: TextStyle(
                fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
            enabled: !isPostCreated,
            maxLength: 144,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Enter Description',
            ),
            basicStyle: TextStyle(fontSize: 14, color: Colors.white),
            onChanged: (input) {
              hashTags = extractHashTags(input);
              text = input;
              if (hashTags.length > 0) {
                setState(() {
                  if (text.length > 0 && text.length < 145)
                    isDescriptionAvailable = true;
                  else
                    isDescriptionAvailable = false;
                });
              }
            },
            enableSuggestions: true,
          )),
          Visibility(
            child: ButtonTheme(
              height: 40.0,
              minWidth: 200,
              child: RaisedButton(
                onPressed: (!isDescriptionAvailable)
                    ? null
                    : () async {
                        _formKey.currentState.save();

                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> postDetails = new Map();

                          postDetails['email'] = session.email;
                          postDetails['password'] = session.password;
                          postDetails['text'] = text;
                          postDetails['hashtags'] = hashTags;
                          setState(() {
                            ServerOperation()
                                .checkConnection()
                                .then((isConnected) {
                              if (isConnected)
                                PostOperations()
                                    .createPost(postDetails)
                                    .then((value) => postId = value);
                              else {
                                _insert(session.email, text,
                                    jsonEncode(hashTags), '');
                                isConnectionAvailable = false;
                              }
                            });
                            isDescriptionAvailable = false;
                          });
                          globalSnackBarKey.currentState.hideCurrentSnackBar();

                          globalSnackBarKey.currentState.showSnackBar(
                              SnackBarUtility().getSnackBar(
                                  "Congratulations!! You just created a post."));
                          isPostCreated = true;
                        }
                      },
                color: Colors.redAccent,
                child: Text("Create Post"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            visible: !isPostCreated,
          ),
          Visibility(
            child: Center(
              child: takenImage == null
                  ? Text('No image selected.')
                  : Image.file(takenImage),
            ),
            visible: isPostCreated,
          ),
          Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  height: 40.0,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () {
                      globalSnackBarKey.currentState.hideCurrentSnackBar();
                      if (isConnectionAvailable) {
                        Map<String, dynamic> postDetails = new Map();
                        postDetails['email'] = session.email;
                        postDetails['password'] = session.password;
                        postDetails['post-id'] = postId;
                        postDetails['image'] = takenImageBase64Encoded;

                        PostOperations().attachImageWithAPost(postDetails);

                        globalSnackBarKey.currentState.showSnackBar(
                            SnackBarUtility().getSnackBar(
                                "Hurray! Your Image is Uploaded with the Post"));
                      } else {
                        _update(pendingPostId, session.email,
                            takenImageBase64Encoded);
                        globalSnackBarKey.currentState.showSnackBar(
                            SnackBarUtility().getSnackBar(
                                "Looks like your internet is off, Your Post will be live soon."));
                      }
                      setState(() {
                        isPostCreated = false;
                        _formKey.currentState.reset();
                        takenImage = null;
                        isPictureAvailable = false;
                        text = "";
                      });
                    },
                    color: Colors.redAccent,
                    child: Text("Save Image And Continue"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ],
            ),
            visible: isPostCreated && isPictureAvailable,
          ),
          Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  height: 40.0,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () {
                      // globalSnackBarKey.currentState.hideCurrentSnackBar();
                      setState(() {
                        isPostCreated = false;
                        _formKey.currentState.reset();
                        isPictureAvailable = false;
                        takenImage = null;
                        text = "";
                      });
                      if (isConnectionAvailable) {
                        globalSnackBarKey.currentState.showSnackBar(
                            SnackBarUtility().getSnackBar(
                                "Hurray! Your Post just went live"));
                      } else
                        globalSnackBarKey.currentState.showSnackBar(
                            SnackBarUtility().getSnackBar(
                                "Looks like your internet is off, Your Post will be live soon."));
                    },
                    color: Colors.redAccent,
                    child: Text("Skip and Continue"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ],
            ),
            visible: isPostCreated,
          ),
          Visibility(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FloatingActionButton(
                                onPressed: () {
                                  _takePicture();
                                  isPictureAvailable = true;
                                },
                                child: Icon(Icons.add_a_photo),
                                backgroundColor: Colors.green,
                              )))
                    ],
                  )
                ]),
            visible: isPostCreated,
          ),
        ]),
      ),
    );
  }
}
