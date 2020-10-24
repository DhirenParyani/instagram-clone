import 'package:flutter/material.dart';
import 'package:instapost/services/postoperations.dart';

class HashtagList extends StatefulWidget {
  @override
  _HashtagListState createState() => _HashtagListState();
}

class _HashtagListState extends State<HashtagList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List<String>>(
            future: PostOperations().getAllHashTags(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return (!snapshot.hasData)
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount:
                          snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.tag),
                                title: Text(
                                  snapshot.data[index].replaceAll("#", ''),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, '/PostList', arguments: {
                                  'hashtag': snapshot.data[index]
                                }),
                              )
                            ],
                          ),
                        );
                      });
            }),
      ),
    );
  }
}
