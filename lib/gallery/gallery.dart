import 'package:flutter/material.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Gallery extends StatefulWidget {
  final String currentUserId;

  Gallery({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => GalleryState(currentUserId: currentUserId);
}

class GalleryState extends State<Gallery> {
  GalleryState({Key key, @required this.currentUserId});

  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                Container(
                  width: 330,
                  height: 50,
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        labelText: "Search",
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/gal3.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              child: Text("View"),
                              textColor: Colors.black,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 180.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Dubai 2019 Trip',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 230, 0.0, 0.0),
                        child: Text(
                          'Pictures and videos from the PNA Dubai 2019 trip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 65,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/gal5.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              child: Text("View"),
                              textColor: Colors.black,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 180.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'PNA Brunch Pictures',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 230, 0.0, 0.0),
                        child: Text(
                          'Pictures and videos from the PNA Brunch',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 65,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/gal7.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              child: Text("View"),
                              textColor: Colors.black,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 180.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'PNA Lifestyle Events at Hilton',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 230, 0.0, 0.0),
                        child: Text(
                          'Pictures and videos from the PNA Lifestyle event at Hilton',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
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
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ChatScreen()),
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
