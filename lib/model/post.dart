class Post {
  int postId;
  int imageId;
  String base64encodedImage;
  String text;

  dynamic averageRating;
  dynamic ratingCount;

  List<String> hashTags = new List();
  List<String> comments = new List();

  Post(
      {this.postId,
      this.imageId,
      this.base64encodedImage,
      this.text,
      this.averageRating,
      this.ratingCount,
      this.hashTags,
      this.comments});

  Post.fromJson(Map<String, dynamic> json)
      : postId = json['id'],
        imageId = json['image'],
        text = json['text'],
        averageRating = json['ratings-average'],
        ratingCount = json['ratings-count'],
        hashTags = List.from(json['hashtags']),
        comments = List.from(json['comments']);

  Map<String, dynamic> toJson() => {
        'id': postId,
        'image': imageId,
        'text': text,
        'ratings-count': ratingCount,
        'ratings-average': averageRating,
        'hashtags': hashTags,
        'comments': comments
      };
}
