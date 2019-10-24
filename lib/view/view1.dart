import 'package:flutter/material.dart';

class View1 extends StatefulWidget {
  @override
  _View1State createState() => _View1State();
}

class _View1State extends State<View1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'images/bany11.jpg',
              gaplessPlayback: true,
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "PLAY NETWORK AFRICA",
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      color: Colors.white,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                    child: Text(
                      "Valuable connection building",
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        color: Colors.white,
                        fontSize: 30,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                    child: Text(
                      "Networking and partnership opportunities in business and luxury lifestyle across Africa.",
                      style: TextStyle(
                        fontFamily: 'SFProText',
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          child: Image(
                            image: AssetImage("images/person1.png"),
                            gaplessPlayback: true,
                          ),
                          height: 45,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage("images/person2.png"),
                            gaplessPlayback: true,
                          ),
                          height: 45,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage("images/person3.png"),
                            gaplessPlayback: true,
                          ),
                          height: 45,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage("images/person4.png"),
                            gaplessPlayback: true,
                          ),
                          height: 45,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage("images/person5.png"),
                            gaplessPlayback: true,
                          ),
                          height: 45,
                        ),
                        SizedBox(
                          child: Image(
                            image: AssetImage("images/person6.png"),
                            gaplessPlayback: true,
                          ),
                          height: 45,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 65,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
