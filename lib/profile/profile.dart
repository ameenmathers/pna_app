import 'package:flutter/material.dart';
import 'package:travel_world/navigation/navigation.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Navigation()),
              );
            },
          )),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage("images/ban6.png"),
            ),
            Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 400,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 32.0, 16.0),
                        child: Text(
                          'Diana Princetone',
                          style: TextStyle(
                            fontSize: 55,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 240.0, 0.0),
                        child: ButtonTheme(
                          buttonColor: Colors.white,
                          height: 40.0,
                          child: RaisedButton(
                            onPressed: () {},
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.done,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Friends",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 1.0, 0.0),
                            child: ButtonTheme(
                              minWidth: 175.0,
                              height: 60.0,
                              child: RaisedButton(
                                color: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                child: Text(
                                  "Share Profile",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                textColor: Colors.black,
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: ButtonTheme(
                              minWidth: 175.0,
                              height: 60.0,
                              child: RaisedButton(
                                color: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                child: Text(
                                  "Scan Profile",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                textColor: Colors.black,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
