import 'package:flutter/material.dart';

import 'form/form1.dart';
import 'home/home.dart';
import 'lastview/lastview.dart';
import 'preview/preview.dart';
import 'view/view1.dart';
import 'view/view2.dart';
import 'view/view3.dart';

void main() => runApp(MyApp());

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
    return PageView.builder(
      itemCount: pages.length,
      itemBuilder: (context, position) => pages[position],
    );
  }
}
