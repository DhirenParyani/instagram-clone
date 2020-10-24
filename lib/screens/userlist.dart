import 'package:flutter/material.dart';
import 'package:instapost/components/progressindicator.dart';
import 'package:instapost/components/snackbar.dart';
import 'package:instapost/services/useroperations.dart';
import 'package:provider/provider.dart';
import 'package:instapost/providers/session.dart';

import 'home.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isPendingPictures = false;

  @override
  Widget build(BuildContext context) {
    Session session = Provider.of<Session>(context).getSession();
    //handlePendingPosts(session.email, session.password);
    return Container(
      child: FutureBuilder<int>(
          future: UserOperations()
              .getPendingPostsForSpecificUser(session.email, session.password),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return (!snapshot.hasData)
                ? Center(
                    child: Column(
                      children: <Widget>[
                        ProgressIndicatorUtility()
                            .getCircularProgressIndicator(''),
                        Text("Loading Pending Posts..")
                      ],
                    ),
                  )
                : Center(
                    child: FutureBuilder<List<String>>(
                        future: UserOperations().getAllNickNames(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          return (!snapshot.hasData)
                              ? CircularProgressIndicator()
                              : ListView.builder(
                                  itemCount: snapshot.data == null
                                      ? 0
                                      : snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text(
                                              snapshot.data[index],
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            onTap: () => Navigator.pushNamed(
                                                context, '/PostList',
                                                arguments: {
                                                  'nickname':
                                                      snapshot.data[index]
                                                }),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                        }),
                  );
          }),
    );
  }
}
