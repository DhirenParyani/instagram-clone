import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instapost/model/post.dart';
import 'package:instapost/services/postoperations.dart';

class PostCard {
  Widget postCardView(String label, Post post, String route) {
    dynamic userRating;
    String hashTagsStr = '';
    if (post.hashTags != null) {
      post.hashTags.every((item) {
        hashTagsStr += item + " ";
        return true;
      });
    }

    return Card(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                child: (route == 'nicknames')
                    ? Icon(Icons.account_circle, size: 20.0)
                    : Icon(Icons.tag, size: 20.0),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
              height: 250,
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
                                  height: 200,
                                  width: 200,
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
              ),
              Container(
                  child: (post.ratingCount != null && post.ratingCount > 0.0)
                      ? Text(post.ratingCount.toString(),
                          style: TextStyle(color: Colors.white))
                      : Text(''))
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
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Tags:" + " " + hashTagsStr,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 20,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
