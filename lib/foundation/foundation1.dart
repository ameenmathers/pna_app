import 'package:flutter/material.dart';
import 'package:travel_world/foundation/foundation.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Foundation1 extends StatefulWidget {
  @override
  State createState() => Foundation1State();
}

class Foundation1State extends State<Foundation1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pray For Sudan',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
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
              MaterialPageRoute(builder: (context) => Foundations()),
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
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/sudan.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 220, 0.0, 0.0),
                        child: Center(
                          child: Text(
                            'Support the Removal of the conflicts in Sudan.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Center(
                    child: ButtonTheme(
                      minWidth: 200,
                      height: 50,
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
                        child: Text("Donate"),
                        textColor: Colors.black,
                        onPressed: () {},
                      ),
                    ),
                  ),
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
                  MaterialPageRoute(builder: (context) => Navigation()),
                );
              },
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
                color: Colors.orangeAccent,
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
                color: Colors.orangeAccent,
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
