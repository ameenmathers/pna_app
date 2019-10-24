import 'package:flutter/material.dart';
import 'package:travel_world/form/form1.dart';

class LastviewPage extends StatefulWidget {
  @override
  _LastviewPageState createState() => _LastviewPageState();
}

class _LastviewPageState extends State<LastviewPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'images/ban3.png',
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
                      "Enjoy Exclusive Deals on Luxury Products and Services",
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
                      "Fancy discounts on a 5-star hotel in Abuja? A spa package in Cape Town? or nights out in the most exclusive clubs & bars? Join us!",
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
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text("Next Step"),
                            Icon(Icons.arrow_right),
                          ],
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Form1()),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
