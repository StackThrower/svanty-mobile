import 'dart:developer';

class AccountPortfolioCategory {
  String image;
  String title;

  AccountPortfolioCategory({required this.image, required this.title});

  factory AccountPortfolioCategory.fromJson(Map<String, dynamic> json) {
    return AccountPortfolioCategory(
        image: json["image"].toString(),
        title: json["title"].toString()
    );
  }
}
