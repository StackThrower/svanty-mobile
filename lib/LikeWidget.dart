
import 'package:flutter/material.dart';

class LikeWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
      return LikeWidget_State();
  }
}

class LikeWidget_State extends State<LikeWidget> {
  LikeWidget_State();

  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_checked ? Icons.favorite : Icons.favorite_border_outlined, color: _checked ? Colors.red : Colors.black),
      onPressed: () {
         setState(() {
           _checked = !_checked;
         });
      },
    );
  }
} // class Level_Indic