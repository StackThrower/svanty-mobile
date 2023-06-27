import 'dart:developer';

class MyImage {
  int id;
  String preview;
  String thumbnail;
  String title;
  double height;
  User user;
  List<String> colors;
  double price;

  MyImage({required this.id, required this.preview, required this.thumbnail, required this.title, required this.height,
    required this.user, required this.colors, required this.price});

  factory MyImage.fromJson(Map<String, dynamic> json) {
    // log(json["preview"].toString());

    return MyImage(
        id: int.parse(json["id"].toString()),
        preview: json["preview"].toString(),
        thumbnail: json["thumbnail"].toString(),
        title: json["title"].toString(),
        height: double.parse(json["height"].toString()),
        user: User.fromJson(json["user"]),
        colors: json["colors"].toString().split(","),
        price: double.parse(json["price"].toString())

    );
  }
}


class User {
  int id = 0;
  String username = '';
  String avatar = '';

  User({required this.id,required this.username, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: int.parse(json["id"].toString()),
        username: json["username"].toString(),
        avatar: json["avatar"].toString()
    );
  }
}
