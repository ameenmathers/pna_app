import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  DateTime now = DateTime.now();

  Future<List<New>> _getNews({bool useCache = true}) async {
    print('Loading events');

    String data;

    /// Do we have a cache we can use?
    var cache = await cacheExists();

    /// If the cache exists and it contains data use that, otherwise we call the API
    if (cache && useCache) {
      print('We have cached data');

      data = await readToFile();
    } else {
      print('No cache. Fetching from API');

      var apiData =
          await http.get("http://www.playnetworkafrica.com/public/api/news");

      data = apiData.body;

      /// Now save the fetched data to the cache
      await writeToFile(data);
    }

    var jsonData = json.decode(data);

    List<New> news = [];

    for (var u in jsonData.reversed) {
      New newws = New(
        u["nid"],
        u["name"],
        u["desc"],
        u["image"],
        u["image2"],
        u["createdat"],
      );

      news.add(newws);
    }

    print(news.length);

    return news;
  }

  Future<List<New>> _refreshNews({bool useCache = true}) async {
    print('Loading events');

    String data;

    /// Do we have a cache we can use?
    var cache = await cacheExists();

    /// If the cache exists and it contains data use that, otherwise we call the API
    if (cache && useCache) {
      print('We have cached data');

      var apiData =
          await http.get("http://www.playnetworkafrica.com/public/api/news");

      data = apiData.body;

      /// Now save the fetched data to the cache
      await writeToFile(data);
    }

    var jsonData = json.decode(data);

    List<New> news = [];

    for (var u in jsonData.reversed) {
      New newws = New(
        u["nid"],
        u["name"],
        u["desc"],
        u["image"],
        u["image2"],
        u["createdat"],
      );

      news.add(newws);
    }

    print(news.length);

    return news;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get myfile async {
    final path = await _localPath;
    return File('$path/news.txt');
  }

  static Future<bool> cacheExists() async {
    var file = await myfile;

    return file.exists();
  }

  static writeToFile(jsonData) async {
    final file = await myfile;
    file.writeAsString(jsonData);
  }

  static readToFile() async {
    try {
      final file = await myfile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {}
  }

  var myFile = new File('news.txt');

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

    _getNews();
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
            'NEWS',
            style: TextStyle(
              fontSize: 20,
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
                MaterialPageRoute(builder: (context) => Navigation()),
              );
            },
          ),
          flexibleSpace: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                width: 350,
                height: 50,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(140.0),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _getNews(),
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
                onRefresh: _refreshNews,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return filter == null || filter == ""
                        ? SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.black,
                                  highlightElevation: 8.0,
                                  splashColor: Colors.white12,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDetail(snapshot.data[index])),
                                    );
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            snapshot.data[index].image,
                                            width: 450,
                                            height: 230,
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 205.0, 0.0, 0.0),
                                        child: Center(
                                          child: ButtonTheme(
                                            minWidth: 80,
                                            height: 30,
                                            child: RaisedButton(
                                              color: Color(0xffc67608),
                                              highlightElevation: 8.0,
                                              splashColor: Colors.white,
                                              highlightColor: Colors.amber,
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Color(0xffc67608),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0),
                                                ),
                                              ),
                                              child: Text("Read More"),
                                              textColor: Colors.black,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsDetail(snapshot
                                                              .data[index])),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 250.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                        : snapshot.data[index].name
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.black,
                                      highlightElevation: 8.0,
                                      splashColor: Colors.white12,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewsDetail(
                                                  snapshot.data[index])),
                                        );
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                snapshot.data[index].image,
                                                width: 450,
                                                height: 230,
                                                fit: BoxFit.cover,
                                                gaplessPlayback: true,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 205.0, 0.0, 0.0),
                                            child: Center(
                                              child: ButtonTheme(
                                                minWidth: 80,
                                                height: 30,
                                                child: RaisedButton(
                                                  color: Color(0xffc67608),
                                                  highlightElevation: 8.0,
                                                  splashColor: Colors.white,
                                                  highlightColor: Colors.amber,
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: Color(0xffc67608),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(40.0),
                                                    ),
                                                  ),
                                                  child: Text("Read More"),
                                                  textColor: Colors.black,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewsDetail(
                                                                  snapshot.data[
                                                                      index])),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 250.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data[index].name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            : new Container();
                  },
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
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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

class NewsDetail extends StatelessWidget {
  final New newws;

  NewsDetail(this.newws);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newws.name.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
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
              MaterialPageRoute(builder: (context) => NewsPage()),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            newws.image,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Center(
                          child: Text(
                            newws.desc,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: newws.image2,
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
                color: Color(0xffc67608),
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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

class New {
  final int nid;
  final String name;
  final String desc;
  final String image;
  final String image2;
  final String createdat;

  New(this.nid, this.name, this.desc, this.image, this.image2, this.createdat);
}
