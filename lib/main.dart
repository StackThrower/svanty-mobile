import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:svanty_mobile/AccountScreen.dart';
import 'dart:developer';
import 'dart:convert';
import 'ScreenAccountArguments.dart';
import 'AccountWidget.dart';
import 'LikeWidget.dart';
import 'MyImage.dart';
import 'MyMembers.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const routeHome = '/';
const routeAccount = '/account';
const routeDeviceSetupStart = '/account';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Svanty',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Svanty - Free Stock Images 4'),

      onGenerateRoute: (settings) {
        late Widget page;
        if (settings.name == routeHome) {
          page = const MyHomePage(title: 'Svanty - Free Stock Images 4');
        } else if (settings.name == routeAccount) {

          final args = settings.arguments as ScreenAccountArguments;
          page = AccountScreen(agrs: args);
        } else {
          throw Exception('Unknown route: ${settings.name}');
        }

        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      }
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedTabIndex = 0;
  final List<MyImage> _images = [];
  final List<MyMembers> _members = [];
  int _currentMembersPage = 0;

  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller1 = ScrollController();
    _controller1.addListener(_scrollRandomPhotosListener);
    _controller2 = ScrollController();
    _controller2.addListener(_scrollMembersListener);
    _getRandomPhotosData();
    _getMembersData();
  }




  _scrollRandomPhotosListener() {
    if (_controller1.offset >= _controller1.position.maxScrollExtent &&
        !_controller1.position.outOfRange) {
          _getRandomPhotosData();
    }
  }

  _scrollMembersListener() {
    if (_controller2.offset >= _controller2.position.maxScrollExtent &&
        !_controller2.position.outOfRange) {
          _getMembersData();
      }
  }

  void _onItemTapped(int index) {

    switch(index) {
      case 0:
        _images.clear();
        _getRandomPhotosData();
        break;
      case 1:
        _members.clear();
        _currentMembersPage = 0;
        _getMembersData();
        break;
      case 2:
        break;
    }


    setState(() {
      _selectedTabIndex = index;
    });
  }


  void _getRandomPhotosData() async {
    log('_getData');
    String url = 'https://svanty.com/api/v1/photos/random';

    try {
      bool trustSelfSigned = true;
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => trustSelfSigned);
      IOClient ioClient = IOClient(httpClient);

      log('_getData 2');

      http.Response response = await ioClient
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      var data = json.decode(response.body) as List;

      setState(() {
        List<MyImage> images =
            data.map<MyImage>((json) => MyImage.fromJson(json)).toList();

        _images.addAll(images);

        log("count:" + _images.length.toString());
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      log(e.toString());
    }
  }


  void _getMembersData() async {
    _currentMembersPage++;
    log('_getMembersData page:' + _currentMembersPage.toString());
    String url = 'https://svanty.com/api/v1/members?page=' + _currentMembersPage.toString();

    try {
      bool trustSelfSigned = true;
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
      IOClient ioClient = IOClient(httpClient);

      log('_getMembersData 2');

      http.Response response = await ioClient
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      var data = json.decode(response.body) as List;

      setState(() {
        List<MyMembers> members =
        data.map<MyMembers>((json) => MyMembers.fromJson(json)).toList();

        _members.addAll(members);

        log("count members:" + _members.length.toString());
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      log(e.toString());
    }
  }

  void _blockUser() {}

  _buildColors(int index) {
    List<Widget> children = <Widget>[];

    List<String> colors = _images[index].colors;

    colors.forEach((element) {
      log(element);

      children.add(
        Padding(
          padding: const EdgeInsets.only(
              left: 0.0, top: 0.0, right: 5.0, bottom: 0.0),
          child: CircleAvatar(
            backgroundColor:
                Color(int.parse("ff" + element.toString(), radix: 16)),
            radius: 10,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "Search by color will be implemented later");
              },
            ),
          ),
        ),
      );
    });

    return children;
  }

  _buildPrice(index) {
    if (_images[index].price > 0) {
      return Row(children: [
        Padding(
            padding: const EdgeInsets.only(
                left: 13.0, top: 0.0, right: 3.0, bottom: 0.0),
            child: Text(_images[index].price.toString() + " \$",
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green))),

      ]);
    } else {
      return Row(children: const [
        Padding(
            padding:
                EdgeInsets.only(left: 13.0, top: 0.0, right: 5.0, bottom: 0.0),
            child: Text("FREE",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green))),
      ]);
    }
  }

  _buildContentRow(int index) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
      child: Container(
          child: Wrap(
        spacing: 0, // gap between adjacent chips
        runSpacing: 0, // gap between lines
        children: <Widget>[
          Container(
            height: 51,
            padding: const EdgeInsets.only(
                left: 5.0, top: 0.0, right: 0.0, bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  GestureDetector(
                  onTap: () {
                    int id = _images[index].user.id;

                    Navigator.of(context).pushNamed(
                      routeDeviceSetupStart,
                        arguments: ScreenAccountArguments(id),
                    );
                  },
                    child: Container(
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(31.0),
                            child: Image.network(
                              _images[index].user.avatar,
                              height: 31.0,
                              width: 31.0,
                            ),
                          ),
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 7.0, top: 0.0, right: 0.0, bottom: 1.5),
                    child: Text(_images[index].user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 1.9, top: 0.0, right: 0.0, bottom: 2.0),
                      child: const Icon(
                        Icons.verified,
                        size: 13,
                        color: Colors.blue,
                      )),
                ]),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 7.0, top: 5.1, right: 0.0, bottom: 0.0),
                      child: IconButton(
                        color: Colors.black26,
                        icon: const Icon(Icons.home_repair_service),
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg:
                                  "Personal service list will be implemented later");
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 0.0, top: 5.1, right: 0.0, bottom: 0.0),
                      child: IconButton(
                        color: Colors.black26,
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 480,
                                // color: Colors.amber,
                                child: ListView(
                                  children: [
                                    Card(
                                      child: ListTile(
                                        leading: const Icon(
                                            Icons.messenger_outline_rounded),
                                        iconColor: Colors.black,
                                        title: const Text("Send message"),
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "The messenger will be implemented later");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Card(
                                        child: ListTile(
                                      leading: const Icon(Icons.block),
                                      iconColor: Colors.red,
                                      onTap: () {
                                        // set up the button
                                        Widget okButton = TextButton(
                                          child: const Text("Block"),
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "The user has been blocked");
                                            Navigator.pop(context);
                                          },
                                        );
                                        Widget cancelButton = TextButton(
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                        // set up the AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          title: const Text("Block the user"),
                                          content: const Text(
                                              "Please, confirm blocking of the current user."),
                                          actions: [
                                            cancelButton,
                                            okButton,
                                          ],
                                        );
                                        // show the dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      },
                                      title: const Text("Block current user"),
                                    )),
                                    Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.copyright),
                                        iconColor: Colors.red,
                                        title: const Text(
                                            "Report the copyright issue"),
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "The report about the copyright issue has been sent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.people),
                                        iconColor: Colors.red,
                                        title: const Text(
                                            "Report the model release issue"),
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "The report about the model release issue has been sent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.heart_broken),
                                        iconColor: Colors.red,
                                        title: const Text("I don't like it"),
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg: "The dislike has been sent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        leading:
                                            const Icon(Icons.content_paste),
                                        iconColor: Colors.red,
                                        title: const Text(
                                            "Report potential violating content"),
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "The report about potential violating content has been sent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                  padding: EdgeInsets.all(10),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 300.0,
              minWidth: 100.0,
            ),
            child: Image.network(_images[index].preview,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 1.9,
                width: MediaQuery.of(context).size.width,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return child;
            }, loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: LikeWidget()),
                Row(children: [
                  Container(
                    child: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.tag),
                      onPressed: () async {
                        Fluttertoast.showToast(msg: "Search by tags will be implemented later");
                      },
                    ),
                  ),
                  Container(
                    child: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () async {
                        Fluttertoast.showToast(msg: "EXIF data will be implemented later");
                      },
                    ),
                  ),
                  Container(
                    child: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.share),
                      onPressed: () async {
                        final imageurl = _images[index].preview;
                        final uri = Uri.parse(imageurl);
                        final response = await http.get(uri);
                        final bytes = response.bodyBytes;
                        final temp = await getTemporaryDirectory();
                        final path = '${temp.path}/image.jpg';
                        File(path).writeAsBytesSync(bytes);

                        await Share.shareFiles([path], text: 'Image Shared');
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Container(

            height: 45,
            padding:
                EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 1.0),
            // decoration: const BoxDecoration(
            //   border: Border(
            //     top: BorderSide(
            //       color: Colors.black26,
            //       width: 1,
            //     ),
            //   ),
            // ),
            child: Center(
                child: Text(_images[index].title,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black87))),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black26,
                  width: 1,
                ),
              ),
            ),
            height: 45,
            padding:
            EdgeInsets.only(left: 5.0, top: 0.0, right: 6.5, bottom: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [_buildPrice(index)],
                ),
                Row(
                  children: _buildColors(index),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  _buildMemberRow(int index) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 0.0, top: 15.0, right: 0.0, bottom: 0.0),
      child: Container(
          child: Wrap(
            spacing: 0, // gap between adjacent chips
            runSpacing: 0, // gap between lines
            children: <Widget>[
              Container(
                height: 69,
                padding: const EdgeInsets.only(
                    left: 25.0, top: 0.0, right: 0.0, bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45.0),
                        child: Image.network(
                          _members[index].avatar,
                          height: 45.0,
                          width: 45.0,
                        ),
                      )
                    ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 7.0, top: 17.0, right: 0.0, bottom: 0),
                            child: Text(_members[index].username,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 7.0, top: 5.1, right: 3.0, bottom: 0.0),
                              child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 13.0,),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 2.0, top: 5.1, right: 3.0, bottom: 0.0),
                              child: const Icon(Icons.account_box_outlined, color: Colors.black, size: 13.0),
                            ),
                          ],)

                        ],
                      )
                    ]),
                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.only(
                              left: 0.0, top: 0, right: 2.0, bottom: 0.0),
                          child: const Text("120EUR 6h"),
                        ),

                        Container(
                          padding: const EdgeInsets.only(
                              left: 0.0, top: 0, right: 0.0, bottom: 0.0),
                          child: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.home_repair_service),
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 280,
                                    // color: Colors.amber,
                                    child: ListView(
                                      children: [
                                        Card(
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt_outlined),
                                            iconColor: Colors.grey,
                                            title: const Text("Wedding 340EUR 5h"),
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "The messenger will be implemented later");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt_outlined),
                                            iconColor: Colors.grey,
                                            title: const Text("Love story 120EUR 2h"),
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "The messenger will be implemented later");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt_outlined),
                                            iconColor: Colors.grey,
                                            title: const Text("Family 80EUR 3h"),
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "The messenger will be implemented later");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                      padding: EdgeInsets.all(10),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 0.0, top: 0, right: 0.0, bottom: 0.0),
                          child: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 280,
                                    // color: Colors.amber,
                                    child: ListView(
                                      children: [
                                        Card(
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.messenger_outline_rounded),
                                            iconColor: Colors.black,
                                            title: const Text("Send message"),
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "The messenger will be implemented later");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.call),
                                            iconColor: Colors.black,
                                            title: const Text("Call"),
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "The messenger will be implemented later");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Card(
                                            child: ListTile(
                                              leading: const Icon(Icons.block),
                                              iconColor: Colors.red,
                                              onTap: () {
                                                // set up the button
                                                Widget okButton = TextButton(
                                                  child: const Text("Block"),
                                                  onPressed: () {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        "The user has been blocked");
                                                    Navigator.pop(context);
                                                  },
                                                );
                                                Widget cancelButton = TextButton(
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  title: const Text("Block the user"),
                                                  content: const Text(
                                                      "Please, confirm blocking of the current user."),
                                                  actions: [
                                                    cancelButton,
                                                    okButton,
                                                  ],
                                                );
                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                              title: const Text("Block current user"),
                                            )),
                                      ],
                                      padding: EdgeInsets.all(10),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Image.asset('assets/images/logo.png', height: 35),
        backgroundColor: Colors.white,
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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _selectedTabIndex == 0 ?
            ListView.builder(
              controller: _controller1,
              itemCount: _images.length,
              itemBuilder: (context, index) => _buildContentRow(index)
            ) :
            _selectedTabIndex == 1 ?
                ListView.builder(
                  controller: _controller2,
                  itemCount: _members.length,
                  itemBuilder: (context, index) => _buildMemberRow(index)
                ) :
                  AccountWidget(args: ScreenAccountArguments(2)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Content',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.redAccent,
        onTap: _onItemTapped,
      ),


    );
  }
}
