import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/event/event.dart';
import 'package:travel_world/foundation/foundation.dart';
import 'package:travel_world/gallery/gallery.dart';
import 'package:travel_world/manual/manual.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/news/news.dart';
import 'package:travel_world/privileges/privilege.dart';
import 'package:travel_world/profile/profile.dart';
import 'package:travel_world/settings/settings.dart';

class Navigation extends StatefulWidget {
  final String currentUserId;

  Navigation({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => NavigationState(currentUserId: currentUserId);
}

class NavigationState extends State<Navigation> {
  NavigationState({Key key, @required this.currentUserId});

  final String currentUserId;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  @override
  void initState() {
    super.initState();

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
                      height: 25,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => News()),
                              );
                            },
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image(
                                    image: AssetImage('images/fire.png'),
                                    width: 450,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 220, 0.0, 0.0),
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
                                                builder: (context) => News(
                                                    currentUserId:
                                                        currentUserId)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Events(
                                        currentUserId: currentUserId,
                                      )),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: AssetImage('images/fire.jpg'),
                                  width: 450,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 210.0, 0.0, 0.0),
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
                                              builder: (context) => Events(
                                                    currentUserId:
                                                        currentUserId,
                                                  )),
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
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Privilege()),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: AssetImage('images/privileges.png'),
                                  width: 450,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 220.0, 0.0, 0.0),
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
                                              builder: (context) => Privilege(
                                                  currentUserId:
                                                      currentUserId)),
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
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Foundation(
                                        currentUserId: currentUserId,
                                      )),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: AssetImage('images/foundation.png'),
                                  width: 450,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 210.0, 0.0, 0.0),
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
                                              builder: (context) => Foundation(
                                                    currentUserId:
                                                        currentUserId,
                                                  )),
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
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Gallery(currentUserId: currentUserId)),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: AssetImage('images/gallery.png'),
                                  width: 450,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 240.0, 0.0, 0.0),
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
                                              builder: (context) => Gallery(
                                                  currentUserId:
                                                      currentUserId)),
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
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Settings(currentUserId: currentUserId)),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: AssetImage('images/settings.png'),
                                  width: 450,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 240.0, 0.0, 0.0),
                                child: Center(
                                  child: ButtonTheme(
                                    minWidth: 80,
                                    height: 30,
                                    child: RaisedButton(
                                      color: Color(0xffc67608),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xffc67608)),
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
                                              builder: (context) => Settings(
                                                  currentUserId:
                                                      currentUserId)),
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
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Manual(currentUserId: currentUserId)),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: AssetImage('images/manual.png'),
                                  width: 450,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 255.0, 0.0, 0.0),
                                child: Center(
                                  child: ButtonTheme(
                                    minWidth: 80,
                                    height: 30,
                                    child: RaisedButton(
                                      color: Color(0xffc67608),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xffc67608)),
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
                                              builder: (context) => Manual(
                                                  currentUserId:
                                                      currentUserId)),
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
                color: Colors.orangeAccent,
              ),
              onPressed: () {},
            ),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.vpn_lock,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Meetup(
                            currentUserId: currentUserId,
                          )),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.perm_identity,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                            currentUserId: currentUserId,
                          )),
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
