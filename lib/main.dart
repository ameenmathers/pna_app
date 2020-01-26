import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'form/form1.dart';
import 'home/home.dart';
import 'lastview/lastview.dart';
import 'navigation/navigation.dart';
import 'preview/preview.dart';
import 'view/view1.dart';
import 'view/view2.dart';
import 'view/view3.dart';

void main() async {
  await Future.delayed(Duration(seconds: 3));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) async {
      user != null
          ? setState(() {
              loggedIn = true;
            })
          : setState(() {
              loggedIn = false;
            });
    });
  }

  List<Widget> pages = [
    HomePage(),
    PreviewPage(),
    View1(),
    View2(),
    View3(),
    LastviewPage(),
    Form1(),
  ];

  @override
  Widget build(BuildContext context) {
    return loggedIn
        ? Navigation()
        : PreloadPageView.builder(
            itemCount: pages.length,
            preloadPagesCount: 7,
            itemBuilder: (context, position) => pages[position],
          );
  }
}
