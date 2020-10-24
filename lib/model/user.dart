import 'package:instapost/model/post.dart';

class User {
  String firstName;
  String lastName;
  String nickName;
  String email;
  String password;
  List<Post> posts = new List();

  User(
      {this.firstName,
      this.lastName,
      this.nickName,
      this.email,
      this.password});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        firstName: parsedJson['firstName'].toString(),
        lastName: parsedJson['lastName'].toString(),
        nickName: parsedJson['nickName'].toString(),
        email: parsedJson['email'].toString(),
        password: parsedJson['password'].toString());
  }

  Map<String, dynamic> toJson() => {
        'firstname': firstName,
        'lastname': lastName,
        'nickname': nickName,
        'email': email,
        'password': password
      };
}
