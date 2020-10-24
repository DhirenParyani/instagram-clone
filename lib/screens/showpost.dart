import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instapost/components/postcardview.dart';
import 'package:instapost/components/progressindicator.dart';
import 'package:instapost/providers/session.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:instapost/model/post.dart';
import 'package:instapost/services/postoperations.dart';
import 'package:rating_dialog/rating_dialog.dart';

class ShowPost extends StatefulWidget {
  @override
  _ShowPostState createState() => _ShowPostState();
}

class _ShowPostState extends State<ShowPost> {
  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context).getSession();
    Post post;
    Map postDetails = ModalRoute.of(context).settings.arguments;
    String label = postDetails['label'];
    dynamic userRating = 0.0;
    int postId = postDetails['postId'];
    String route = postDetails['route'];
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Insta Post'),
        ),
        body: Column(children: <Widget>[
          FutureBuilder<Post>(
              future:
                  (postId != null) ? PostOperations().getPost(postId) : null,
              builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
                if (snapshot.hasData) {
                  post = Post(
                      postId: snapshot.data.postId,
                      text: snapshot.data.text ?? '',
                      hashTags: snapshot.data.hashTags ?? null,
                      imageId: snapshot.data.imageId ?? null,
                      comments: snapshot.data.comments ?? null,
                      ratingCount: snapshot.data.ratingCount ?? null,
                      averageRating: snapshot.data.averageRating ?? -1.0);
                  return Card(
                    child: Column(children: <Widget>[
                      PostCard().postCardView(label ?? '', post, route),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.star_rate_rounded,
                            ),
                            tooltip: 'Rate the post',
                            color: Colors.orange,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  // set to false if you want to force a rating
                                  builder: (context) {
                                    return RatingDialog(
                                      title: "Rate the post",
                                      description:
                                          "Tap a star to set your rating.",
                                      submitButton: "SUBMIT",
                                      //alternativeButton: "Contact us instead?", // optional

                                      accentColor: Colors.orange,
                                      // optional
                                      onSubmitPressed: (int rating) {
                                        Map<String, dynamic> postDetails =
                                            new Map();
                                        postDetails['email'] = session.email;
                                        postDetails['password'] =
                                            session.password;
                                        postDetails['rating'] = rating;
                                        postDetails['post-id'] = post.postId;
                                        PostOperations()
                                            .addARating(postDetails);
                                      },
                                      icon: Icon(Icons.rate_review),
                                    );
                                  });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () => Navigator.pushNamed(
                                context, '/ShowComments',
                                arguments: {
                                  'post': post,
                                }),
                            color: Colors.orange,
                          )
                        ],
                      ),
                    ]),
                  );
                } else if (snapshot.hasError)
                  throw new Exception(snapshot.hasError);
                else
                  return ProgressIndicatorUtility()
                      .getCircularProgressIndicator('');
              }),
        ]),
      ),
    );
  }

  Widget buildCommentList(List<String> comments) {
    return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.comment),
            title: Text(comments[index]),
          );
        });
  }
}
