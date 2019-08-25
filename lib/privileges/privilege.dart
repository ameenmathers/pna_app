import 'package:flutter/material.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/notifications/notifications.dart';
import 'package:travel_world/profile/profile.dart';

class Privilege extends StatefulWidget {
  @override
  _PrivilegeState createState() => _PrivilegeState();
}

class _PrivilegeState extends State<Privilege> {
  var url = 'http://localhost:8000/api/events';
  var events = "empty";

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
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
                      child: Text(
                        'Privileges',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 33,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: null),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                      color: Colors.white,
                    )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'PNA s Amazing Privileges',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Show all',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_right,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: null),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 110.0, 50.0, 0.0),
                                child: Text("Hotels",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view2.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 120.0, 30.0, 0.0),
                                child: Text("Flights",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 15.0, 0.0),
                                child: Text("1370 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view3.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 110.0, 10.0, 0.0),
                                child: Text("Restaurants",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view4.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 110.0, 10.0, 0.0),
                                child: Text("Discounts",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 25.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
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
        iconSize: 30,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Navigation()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.white,
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
                Icons.people,
                color: Colors.white,
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
                Icons.near_me,
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
