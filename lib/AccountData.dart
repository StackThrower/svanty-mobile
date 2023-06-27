import 'dart:developer';

class AccountData {
  String username;
  String name;
  String avatar;

  AccountData({required this.username, required this.name, required this.avatar});

  factory AccountData.fromJson(json) {

    return AccountData(
        username: json["username"].toString(),
        name: json["name"].toString(),
        avatar: json["avatar"].toString()
    );
  }
}
