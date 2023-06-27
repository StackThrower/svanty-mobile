import 'dart:developer';

class MyMembers {
  String username;
  String name;
  String email;
  String formattedDate;
  String avatar;
  String website;
  String twitter;
  String facebook;
  int photosCount;

  MyMembers({required this.username, required this.name, required this.email, required this.formattedDate,
     required this.avatar, required this.website, required this.twitter, required this.facebook, required this.photosCount});

  factory MyMembers.fromJson(Map<String, dynamic> json) {
    // log(json["preview"].toString());

    return MyMembers(
        username: json["username"].toString(),
        name: json["name"].toString(),
        email: json["email"].toString(),
        formattedDate: json["formattedDate"].toString(),
        avatar: json["avatar"].toString(),
        website: json["website"].toString(),
        twitter: json["twitter"].toString(),
        facebook: json["facebook"].toString(),
        photosCount: int.parse(json["photosCount"].toString())

    );
  }
}


