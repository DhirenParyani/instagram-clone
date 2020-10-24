import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:instapost/components/postlistcardview.dart';
import 'package:instapost/components/progressindicator.dart';
import 'package:instapost/model/post.dart';
import 'package:instapost/services/postoperations.dart';

class PostList extends StatefulWidget {
  String nickName;
  String hashTag;

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  Post post;

  @override
  Widget build(BuildContext context) {
    Map postIdsMapping = ModalRoute.of(context).settings.arguments;
    bool isNickNameMappingPresent = (postIdsMapping['nickname'] != null);

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: AppBar(
              title: (isNickNameMappingPresent)
                  ? Text(postIdsMapping['nickname'])
                  : Text(postIdsMapping['hashtag'])),
          body: Container(
            child: FutureBuilder<List<int>>(
                future: (isNickNameMappingPresent)
                    ? PostOperations()
                        .getPostIdsByNickName(postIdsMapping['nickname'])
                    : PostOperations()
                        .getPostIdsByHashTags(postIdsMapping['hashtag']),
                builder:
                    (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot == null || snapshot.data == null)
                            ? 0
                            : snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: FutureBuilder<Post>(
                                future: (snapshot.data[index] != null)
                                    ? PostOperations()
                                        .getPost(snapshot.data[index])
                                    : null,
                                builder: (BuildContext context,
                                    AsyncSnapshot<Post> innerSnapshot) {
                                  print(innerSnapshot.toString());
                                  if (snapshot.data != null &&
                                      innerSnapshot.hasData) {
                                    post = Post(
                                        postId: innerSnapshot.data.postId,
                                        text: innerSnapshot.data.text ?? '',
                                        hashTags:
                                            innerSnapshot.data.hashTags ?? null,
                                        imageId:
                                            innerSnapshot.data.imageId ?? null,
                                        averageRating:
                                            innerSnapshot.data.averageRating ??
                                                -1.0,
                                        comments: innerSnapshot.data.comments ??
                                            null);
                                    return PostListCardView().postListCardView(
                                        (isNickNameMappingPresent)
                                            ? postIdsMapping['nickname'] ?? ''
                                            : postIdsMapping['hashtag'] ?? '',
                                        post,
                                        (isNickNameMappingPresent)
                                            ? 'nicknames'
                                            : 'hashtags');
                                  } else if (snapshot.data == null ||
                                      snapshot.hasError ||
                                      innerSnapshot.hasError)
                                    return Center(
                                        child: Text(
                                            "No Posts/Cached Posts Available For:" +
                                                ((isNickNameMappingPresent)
                                                    ? postIdsMapping['nickname']
                                                    : postIdsMapping[
                                                        'hashtag'])));
                                  else
                                    return ProgressIndicatorUtility()
                                        .getCircularProgressIndicator('');
                                }),
                            onTap: () => Navigator.pushNamed(
                                context, '/ShowPost',
                                arguments: {
                                  'label': (isNickNameMappingPresent)
                                      ? postIdsMapping['nickname']
                                      : postIdsMapping['hashtag'],
                                  'postId': snapshot.data[index],
                                  'route': (isNickNameMappingPresent)
                                      ? 'nicknames'
                                      : 'hashtags'
                                }),
                          );
                        });
                  } else if (snapshot.hasError)
                    return Center(
                        child: Text("No Posts/Cached Posts Available For:" +
                            ((isNickNameMappingPresent)
                                ? postIdsMapping['nickname']
                                : postIdsMapping['hashtag'])));
                  else
                    return ProgressIndicatorUtility()
                        .getCircularProgressIndicator('');
                }),
          )),
    );
  }
}
