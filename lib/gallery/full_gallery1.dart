import 'package:flutter/material.dart';

class Full_gallery1 extends StatefulWidget {
  String image;
  Full_gallery1({this.image});

  _Full_gallery1State createState() => _Full_gallery1State();
}

class _Full_gallery1State extends State<Full_gallery1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.image,
                child: Image.network(widget.image),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
