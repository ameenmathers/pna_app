import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_world/event/event.dart';
import 'package:travel_world/foundation/foundation.dart';
import 'package:travel_world/gallery/gallery.dart';
import 'package:travel_world/manual/manual.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/news/news.dart';
import 'package:travel_world/privileges/privilege.dart';
import 'package:travel_world/profile/profile.dart';
import 'package:travel_world/settings/settings.dart';

class Navigation extends StatefulWidget {
  @override
  State createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  @override
  void initState() {
    super.initState();
    image1 = Image.asset(
      "images/fire.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    image2 = Image.asset(
      "images/fire1.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    image3 = Image.asset(
      "images/privileges.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    image4 = Image.asset(
      "images/foundation.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    image5 = Image.asset(
      "images/gallery.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    image6 = Image.asset(
      "images/settings.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    image7 = Image.asset(
      "images/manual.jpg",
      fit: BoxFit.fill,
      width: 450,
      height: 230,
    );
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Image image1;
  Image image2;
  Image image3;
  Image image4;
  Image image5;
  Image image6;
  Image image7;

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'PLAY NETWORK AFRICA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsPage()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image1,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 205, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffc67608),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("News"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewsPage()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Events()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image2,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 205.0, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffc67608),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("Events"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Events()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivilegePage()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image3,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 205.0, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffc67608),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("Privileges"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivilegePage()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Foundations()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image4,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 205.0, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffc67608),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("Foundation"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Foundations()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GalleryPage()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image5,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 205.0, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffc67608),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("Gallery"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GalleryPage()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Settings()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image6,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 205.0, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xffc67608)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("Settings"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Settings()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Manual()),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: image7,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 205.0, 0.0, 0.0),
                            child: Center(
                              child: ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xffc67608)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40.0),
                                    ),
                                  ),
                                  child: Text("Help and Support"),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Manual()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            title: Text(''),
            icon: IconButton(
              icon: Icon(
                Icons.home,
                color: Color(0xffc67608),
              ),
              onPressed: () {},
            ),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.vpn_lock,
                color: Color(0xffc67608),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Meetup()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Color(0xffc67608),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Messages()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.perm_identity,
                color: Color(0xffc67608),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }
}
