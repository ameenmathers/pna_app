import 'package:flutter/material.dart';

class View1 extends StatefulWidget {
  @override
  _View1State createState() => _View1State();
}

class _View1State extends State<View1> {
  Image image1;
  Image image2;
  Image image3;
  Image image4;
  Image image5;
  Image image6;
  Image image7;

  @override
  void initState() {
    super.initState();
    image1 = Image.asset(
      "images/bany11.jpg",
      fit: BoxFit.fill,
    );
    image2 = Image.asset(
      "images/person1.png",
    );
    image3 = Image.asset(
      "images/person2.png",
    );
    image4 = Image.asset(
      "images/person3.png",
    );
    image5 = Image.asset(
      "images/person4.png",
    );
    image6 = Image.asset(
      "images/person5.png",
    );
    image7 = Image.asset(
      "images/person6.png",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
    precacheImage(image5.image, context);
    precacheImage(image6.image, context);
    precacheImage(image7.image, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: image1,
            height: size.height,
            width: size.width,
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
                          child: image2,
                          height: 45,
                        ),
                        SizedBox(
                          child: image3,
                          height: 45,
                        ),
                        SizedBox(
                          child: image4,
                          height: 45,
                        ),
                        SizedBox(
                          child: image5,
                          height: 45,
                        ),
                        SizedBox(
                          child: image6,
                          height: 45,
                        ),
                        SizedBox(
                          child: image7,
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
