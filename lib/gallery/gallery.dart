import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => new _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Future<List<Gallery>> _getGallerys() async {
    var data = await http.get("http://localhost:8000/api/gallery");

    var jsonData = json.decode(data.body);

    List<Gallery> gallerys = [];

    for (var u in jsonData) {
      Gallery gallery = Gallery(
          u["gid"], u["name"], u["desc"], u["image"], u["image2"], u["image3"]);

      gallerys.add(gallery);
    }

    print(gallerys.length);

    return gallerys;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
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
      body: FutureBuilder(
        future: _getGallerys(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.data == null) {
            return SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
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
                  height: 40,
                ),
                SizedBox(
                  height: 65,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Column(
                    children: <Widget>[
                      Stack(
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
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Dubai 2019 Trip',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Pictures and videos from the PNA Dubai 2019 trip',
                          textAlign: TextAlign.left,
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
                  child: Column(
                    children: <Widget>[
                      Stack(
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
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'PNA Brunch Pictures',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Pictures and videos from the PNA Brunch',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
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
                  child: Column(
                    children: <Widget>[
                      Stack(
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'PNA Lifestyle Events at Hilton',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Pictures and videos from the PNA Lifestyle event at Hilton',
                          textAlign: TextAlign.left,
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
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        color: Colors.black,
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Image(
                                  image:
                                      NetworkImage(snapshot.data[index].image),
                                  gaplessPlayback: true,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    snapshot.data[index].name,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                snapshot.data[index].desc,
                                textAlign: TextAlign.left,
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
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('images/gal3.png'),
                                  gaplessPlayback: true,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Dubai 2019 Trip',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Pictures and videos from the PNA Dubai 2019 trip',
                                textAlign: TextAlign.left,
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
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('images/gal5.png'),
                                  gaplessPlayback: true,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'PNA Brunch Pictures',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Pictures and videos from the PNA Brunch',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
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
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('images/gal7.png'),
                                  gaplessPlayback: true,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'PNA Lifestyle Events at Hilton',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Pictures and videos from the PNA Lifestyle event at Hilton',
                                textAlign: TextAlign.left,
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
                );
              },
            );
          }
        },
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

class GalleryDetail extends StatelessWidget {
  final Gallery gallery;

  GalleryDetail(this.gallery);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          gallery.name,
          style: TextStyle(
            fontSize: 22,
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
              MaterialPageRoute(builder: (context) => GalleryPage()),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image(
                      image: NetworkImage(gallery.image),
                      gaplessPlayback: true,
                    ),
                    Image(
                      image: NetworkImage(gallery.image2),
                      gaplessPlayback: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Image(
                  image: NetworkImage(gallery.image3),
                  gaplessPlayback: true,
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
                Icons.people,
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

class Gallery {
  final int gid;
  final String name;
  final String desc;
  final String image;
  final String image2;
  final String image3;

  Gallery(this.gid, this.desc, this.name, this.image, this.image2, this.image3);
}
