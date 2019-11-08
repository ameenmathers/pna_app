import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  Image image1;

  @override
  void initState() {
    super.initState();
    image1 = Image.asset(
      "images/ban8.jpg",
      fit: BoxFit.fill,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: image1,
              height: size.height,
              width: size.width,
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "MEMBERSHIP PAYMENT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                        child: Text(
                          "ANNUAL MEMBERSHIP FEE OF 60 USD PER YEAR",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                        child: ButtonTheme(
                          minWidth: 350.0,
                          height: 60.0,
                          child: RaisedButton(
                            color: Color(0xffc67608),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffc67608),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Text("Pay Now"),
                            textColor: Colors.white,
                            onPressed: _launchURL,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_launchURL() async {
  const url = 'https://paystack.com/buy/PROD_oqy8geod3gg96y5';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
