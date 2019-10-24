import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'images/ban2.png',
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "PLAY NETWORK AFRICA",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFProDisplay',
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
                      "Enjoy Access to Exclusive Business and Lifestyle Events",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProDisplay',
                        fontSize: 30,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                    child: Text(
                      "We host the most exclusive parties, networking events and musical concerts across metropolitan cities in Africa.",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProText',
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
