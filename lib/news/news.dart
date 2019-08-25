import 'package:flutter/material.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/notifications/notifications.dart';
import 'package:travel_world/profile/profile.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  var url = 'http://localhost:8000/api/events';
  var events = "empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                        'News',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 33,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 230,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 5.0, 0.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/person1.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Moriah Chaiwe',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: Colors.black,
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
                      height: 400,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                        child: new Image.asset(
                          'images/news.png',
                          width: 380,
                          height: 400,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 5.0, 0.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/person2.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Bill Rolling',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: Colors.black,
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
                      height: 400,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                        child: new Image.asset(
                          'images/news.png',
                          width: 380,
                          height: 400,
                          fit: BoxFit.fill,
                        ),
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
