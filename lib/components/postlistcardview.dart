import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instapost/model/post.dart';
import 'package:instapost/services/postoperations.dart';

class PostListCardView {
  Widget postListCardView(String label, Post post, String route) {
    //if(base64Image.length!=0) {
    //final _byteImage=Base64Decoder().convert(base64Image);
    return Card(
      color: Colors.black,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              child: (route == 'nicknames')
                                  ? Icon(Icons.account_circle, size: 20.0)
                                  : Icon(Icons.tag, size: 20.0),
                            ),
                          ),
                          (route == 'nicknames')
                              ? Text(label,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))
                              : Text(''),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
                constraints: BoxConstraints(maxHeight: 250),
                child: (post.imageId == -1)
                    ? FlutterLogo()
                    : FutureBuilder<String>(
                        future: PostOperations().getImage(post.postId),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            post.base64encodedImage = snapshot.data.trim();
                            try {
                              return Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                      child: Image.memory(
                                    Base64Decoder()
                                        .convert(post.base64encodedImage),
                                    height: 80,
                                    width: 100,
                                  ))
                                ],
                              );
                            } catch (e) {
                              return FlutterLogo();
                            }
                          } else if (snapshot.hasError)
                            return FlutterLogo();
                          else
                            return CircularProgressIndicator();
                        })),
            //Padding(padding: EdgeInsets.only(top: 5.0)),
            Row(
              children: <Widget>[
                RatingBar(
                  itemSize: 20.0,
                  initialRating: double.parse(post.averageRating.toString()),
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: null,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(maxHeight: 200.0),
                    child: Icon(Icons.description)),
                Expanded(
                  child: Text(
                    post.text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 20,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
