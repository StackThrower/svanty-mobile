import 'dart:developer';

class AccountImage {
  String preview;
  String thumbnail;
  String title;
  double height;
  List<String> colors;
  double price;

  AccountImage({required this.preview, required this.thumbnail, required this.title, required this.height,
     required this.colors, required this.price});

  factory AccountImage.fromJson(Map<String, dynamic> json) {
    // log(json["preview"].toString());

    return AccountImage(
        preview: json["preview"].toString(),
        thumbnail: json["thumbnail"].toString(),
        title: json["title"].toString(),
        height: double.parse(json["height"].toString()),
        colors: json["colors"].toString().split(","),
        price: double.parse(json["price"].toString())
    );
  }
}
