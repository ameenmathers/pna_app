import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_world/home/home.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Settings extends StatefulWidget {
  final String currentUserId;

  Settings({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => SettingsState(currentUserId: currentUserId);
}

class SettingsState extends State<Settings> {
  SettingsState({Key key, @required this.currentUserId});

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

  bool isSwitched = true;
  bool isSwitched2 = true;
  bool isOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 33,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Navigation(
                        currentUserId: currentUserId,
                      )),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 45,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Login with Touch ID',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeTrackColor: Color(0xffc67608),
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.white70,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Enable 2FA',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                    ),
                    Switch(
                      value: isSwitched2,
                      onChanged: (value) {
                        setState(() {
                          isSwitched2 = value;
                        });
                      },
                      activeTrackColor: Color(0xffc67608),
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.white70,
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Share My Activity',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Make Me  Discoverable',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Switch(
                      value: isOff,
                      onChanged: (value) {
                        setState(() {
                          isOff = value;
                        });
                      },
                      activeTrackColor: Color(0xffc67608),
                      inactiveTrackColor: Colors.white70,
                      activeColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 105,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 145,
                    ),
                    ButtonTheme(
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
                        child: Icon(Icons.power_settings_new),
                        textColor: Colors.white70,
                        onPressed: () {
                          _auth.signOut();
                          Navigator.pop(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navigation(
                            currentUserId: currentUserId,
                          )),
                );
              },
            ),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.people,
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
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => Chat()),
//                );
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
