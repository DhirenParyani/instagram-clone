import 'package:flutter/material.dart';
import 'package:instapost/model/post.dart';
import 'package:instapost/providers/session.dart';
import 'package:instapost/services/postoperations.dart';
import 'package:provider/provider.dart';

class ShowComments extends StatefulWidget {
  @override
  _ShowCommentsState createState() => _ShowCommentsState();
}

class _ShowCommentsState extends State<ShowComments> {
  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context).getSession();
    Post post;
    final _formKey = GlobalKey<FormState>();
    Map postDetails = ModalRoute.of(context).settings.arguments;
    post = postDetails['post'] as Post;
    List<String> comments = post.comments;
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Comments:' + " " + comments.length.toString()),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(child: buildCommentList(comments)),
                  TextField(
                    onSubmitted: (submittedComment) {
                      Map<String, dynamic> postDetails = new Map();
                      postDetails['email'] = session.email;
                      postDetails['password'] = session.password;
                      postDetails['comment'] = submittedComment;
                      postDetails['post-id'] = post.postId;
                      PostOperations().addAComment(postDetails);
                      setState(() {
                        comments.add(submittedComment);
                      });
                      _formKey.currentState.reset();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        hintText: 'Add Comment'),
                  )
                ],
              ),
            )));
  }

  Widget buildCommentList(List<String> comments) {
    return ListView.builder(
        itemCount:
            (comments == null || comments.length == 0) ? 0 : comments.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.comment),
            title: Text("'" + comments[index] + "'"),
          );
        });
  }
}
