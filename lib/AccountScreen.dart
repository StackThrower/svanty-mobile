


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:svanty_mobile/ScreenAccountArguments.dart';
import 'package:svanty_mobile/AccountWidget.dart';


class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key, required this.agrs}) : super(key: key);

  ScreenAccountArguments agrs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: AccountWidget(args: agrs)
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shadowColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 5.0),
            child: GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                    msg: 'The finder will be implemented later');
              },
              child: const Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 5.0),
            child: GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                    msg: 'The messenger will be implemented later');
              },
              child: const Icon(
                Icons.messenger_outline,
                color: Colors.black,
              ),
            )),
      ],
    );
  }
}