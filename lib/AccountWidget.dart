
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:svanty_mobile/ScreenAccountArguments.dart';
import 'AccountData.dart';
import 'AccountImage.dart';
import 'AccountPortfolioCategory.dart';


class AccountWidget extends StatefulWidget {

  AccountWidget({Key? key, required this.args}) : super(key: key);

  ScreenAccountArguments args;

  List<AccountImage> images = [];
  List<AccountPortfolioCategory> portfolioCategories = [];


  AccountData accountData = AccountData(username: '.......', name: '................', avatar: 'https://svanty.com/public/uploads/avatar/default.jpg');

  @override
  State<StatefulWidget> createState() {

      return AccountWidget_State();
  }
}

class AccountWidget_State extends State<AccountWidget> {

  int _currentAccountImagesPage = 0;

  @override
  void initState() {
    _getAccountPhotosData();
    _getAccountData();

    widget.portfolioCategories.add(AccountPortfolioCategory(image: 'https://svanty.com/public/uploads/thumbnail/p0JqnuCl8wp6fqF8zWOVqCtCXtAt3AEbiZtNaGlxsNXMCdDAvGPnknsW6cA6yXTCty1lKKbDm63FEKkMDZMY8lNv91.jpg', title: 'Wedding'));
    widget.portfolioCategories.add(AccountPortfolioCategory(image: 'https://svanty.com/public/uploads/thumbnail/s2RE1eHF06PjvEvDcZTqZv6lIy4hoXiwARXT9YZPZSkG29nrc2TO9HUoYHL52UWTrjLmR3WHOs1wusQMImqMY7voXG.jpg', title: 'Love Story'));
    widget.portfolioCategories.add(AccountPortfolioCategory(image: 'https://svanty.com/public/uploads/thumbnail/k2SJhbmcpXAKnKQWfl20atIazJPn0HKS7jU9SBtFnEFISZBGqOB95e8n7LZaRqY4UnnLQgNNdZSo5lZqBtRch1AqA3.jpg', title: 'Couples'));
    widget.portfolioCategories.add(AccountPortfolioCategory(image: 'https://svanty.com/public/uploads/thumbnail/yR2hCwdmxq48T2k4nK9vplOVRqQHgXwE3cCwAl7Jhpwp4wtSulxT5ecH3iJiD8qnHKcLvPXWtOWTqfyEBQ6QnXpgMf.jpg', title: 'Kids'));
    widget.portfolioCategories.add(AccountPortfolioCategory(image: 'https://svanty.com/public/uploads/thumbnail/i4xudJZwGy0IiA0MK2nUaRbbIrZTjQGweyxjuH2H8qw2qy6oCHFV9TMmhgc8tjthDCN6dwvN3OEsU8kdQz9SZHIXLY.jpg', title: 'Pregnancy'));
    widget.portfolioCategories.add(AccountPortfolioCategory(image: 'https://svanty.com/public/uploads/thumbnail/juJ9WERcwhK4td4QQZazux08c66lbEIGJehTmDdguKgRk6iXfgW24uRcqrdmWsXvL2yZoIEkpehMdut2whpg1oubU5.jpg', title: 'Stuff'));

  }

  void _getAccountPhotosData() async {

    _currentAccountImagesPage++;
    String url = 'https://svanty.com/api/v1/account/'+ widget.args.id.toString() +'/images?page=' + _currentAccountImagesPage.toString();

    try {
      bool trustSelfSigned = true;
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
      IOClient ioClient = IOClient(httpClient);



      http.Response response = await ioClient
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      var data = json.decode(response.body) as List;

      setState(() {
        List<AccountImage> images =
        data.map<AccountImage>((json) => AccountImage.fromJson(json)).toList();

        widget.images.addAll(images);


      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());


    }
  }


  void _getAccountData() async {

    String url = 'https://svanty.com/api/v1/account/'+ widget.args.id.toString();

    try {
      bool trustSelfSigned = true;
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
      IOClient ioClient = IOClient(httpClient);



      http.Response response = await ioClient
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      var data = json.decode(response.body);

      setState(() {
        widget.accountData = AccountData.fromJson(data);
        print(widget.accountData);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());


    }
  }


  @override
  Widget build(BuildContext context) {


    return NotificationListener<ScrollEndNotification>(
        child: CustomScrollView(

          slivers: <Widget>[
            SliverToBoxAdapter(
              child:
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                    left: 0.0, top: 0.0, right: 0.0, bottom: 7),
                child: Column(children: [

                  Row(
                    children: [

                        Expanded(
                          flex: 1,
                          child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(
                                      left: 17.0, top: 17.0, right: 0.0, bottom: 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(65.0),
                                    child: Image.network(
                                      widget.accountData.avatar,
                                      height: 65.0,
                                      width: 65.0,
                                    ),
                                  )
                              ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [

                                    Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: const EdgeInsets.only(
                                            left: 17.0, top: 0.0, right: 17.0, bottom: 0),
                                        child: Column(children: const [
                                          Text("45", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text("Photos", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13)),
                                        ])

                                    ),
                                    Container(

                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.only(
                                            left: 17.0, top: 0.0, right: 17.0, bottom: 0),
                                        child: Column(children: const [
                                          Text("23", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text("Followers", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13)),
                                        ])
                                    ),
                                    Container(

                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.only(
                                            left: 17.0, top: 0.0, right: 17.0, bottom: 0),
                                        child: Column(children: const [
                                          Text("87", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text("Following", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13)),
                                        ])
                                    )
                                ])
                        )
                  ],),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 7.0, right: 0.0, bottom: 0),
                        child:  Text(widget.accountData.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 2.0, right: 0.0, bottom: 0),
                        child: Text(widget.accountData.username,
                            style: const TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 5.1, right: 3.0, bottom: 0.0),
                            child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 13.0,),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 5.1, right: 3.0, bottom: 0.0),
                            child: const Icon(Icons.account_box_outlined, color: Colors.black, size: 13.0),
                          ),
                        ],
                      ),
                    ],
                  ),



                  Container(
                    padding: const EdgeInsets.only(
                        left: 18.0, top: 7.0, right: 18.0, bottom: 0),
                    child: const Center(child: Text("No fancy salestalk; I let my portfolio speak for me... Nominated for svanty's wedding photographer of the year 2016, 2017 & 2018. Available to shoot around the world..."),)
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 0.0, top: 7.0, right: 0.0, bottom: 15),
                      child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, top: 10.0, right: 0.0, bottom: 0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Follow'),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 7.0, top: 10.0, right: 0.0, bottom: 0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Send Request'),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                            )
                                        ),
                                      ),

                                    )
                                ],)
                  ),

                ]),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 70.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.portfolioCategories.length,
                  itemBuilder: (context, index) {
                    return
                      Column(children: [

                        Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 0.0, right: 15.0, bottom: 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(42.0),
                              child: Image.network(
                                widget.portfolioCategories[index].image,
                                height: 42.0,
                                width: 42.0,
                                fit: BoxFit.cover,
                              ),
                            )
                        ),
                        Container(
                            child: Text(widget.portfolioCategories[index].title)
                        )

                      ],);
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 0.0, top: 10.0, right: 0.0, bottom: 25.0),
                    child: const Center(child:
                      Text("Wedding 100 EUR per 1, min 6h",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
                    )
              )
            ),

            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.images[index].thumbnail)),
                    ),
                  );

                },
                childCount: widget.images.length,
              ),
            ),
          ],
        ),
        onNotification: (scrollEnd) {
          //How many pixels scrolled from pervious frame
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (isTop) {
              print('At the top');
            } else {
              _getAccountPhotosData();
            }
          }

          return true;
        },
      );








  }
} // class Level_Indic