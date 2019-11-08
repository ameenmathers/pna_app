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
    var data =
        await http.get("http://www.playnetworkafrica.com/public/api/gallery");

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

  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });

    _getGallerys();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        child: AppBar(
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
          flexibleSpace: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 330,
                    height: 50,
                    child: TextField(
                      controller: searchController,
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
                ],
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(150.0),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _getGallerys(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.data == null) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
                  ),
                ),
              ],
            ));
          } else {
            return Container(
              child: RefreshIndicator(
                onRefresh: _getGallerys,
                child: SingleChildScrollView(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return filter == null || filter == ""
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                RaisedButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GalleryDetail(
                                              snapshot.data[index])),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: new Image.network(
                                              snapshot.data[index].image,
                                              gaplessPlayback: true,
                                              width: 450,
                                              height: 230,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 225.0, 0.0, 0.0),
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(40.0),
                                                    ),
                                                  ),
                                                  child: Text("View"),
                                                  textColor: Colors.black,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GalleryDetail(
                                                                  snapshot.data[
                                                                      index])),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              snapshot.data[index].name,
                                              textAlign: TextAlign.center,
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
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : snapshot.data[index].name
                                  .toLowerCase()
                                  .contains(filter.toLowerCase())
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RaisedButton(
                                        color: Colors.black,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GalleryDetail(
                                                        snapshot.data[index])),
                                          );
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: new Image.network(
                                                    snapshot.data[index].image,
                                                    gaplessPlayback: true,
                                                    width: 450,
                                                    height: 230,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 225.0, 0.0, 0.0),
                                                  child: Center(
                                                    child: ButtonTheme(
                                                      minWidth: 80,
                                                      height: 30,
                                                      child: RaisedButton(
                                                        color:
                                                            Color(0xffc67608),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xffc67608),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                40.0),
                                                          ),
                                                        ),
                                                        child: Text("View"),
                                                        textColor: Colors.black,
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    GalleryDetail(
                                                                        snapshot
                                                                            .data[index])),
                                                          );
                                                        },
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
                                                      const EdgeInsets.fromLTRB(
                                                          15.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    snapshot.data[index].name,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : new Container();
                    },
                  ),
                ),
              ),
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
                color: Color(0xffc67608),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: new Image.network(
                    gallery.image,
                    gaplessPlayback: true,
                    width: 450,
                    height: 230,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: new Image.network(
                    gallery.image2,
                    gaplessPlayback: true,
                    width: 450,
                    height: 230,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: new Image.network(
                    gallery.image3,
                    gaplessPlayback: true,
                    width: 450,
                    height: 230,
                    fit: BoxFit.fill,
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
                color: Color(0xffc67608),
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

class Gallery {
  final int gid;
  final String name;
  final String desc;
  final String image;
  final String image2;
  final String image3;

  Gallery(this.gid, this.name, this.desc, this.image, this.image2, this.image3);
}
