import 'package:flutter/material.dart';
import 'package:travel_world/privileges/privilege.dart';

class Hotel extends StatefulWidget {
  final String currentUserId;

  Hotel({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HotelState(currentUserId: currentUserId);
}

class HotelState extends State<Hotel> {
  HotelState({Key key, @required this.currentUserId});

  final String currentUserId;
  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'Discount for Hilton Opened.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(40.0, 20.0, 20.0, 20.0),
                ),
                Text(
                  'DISCOUNT CODE[ N00-@1450]',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'PLEASE DISPLAY THIS CODE TO AN APPROPIRATE STAFF TO APPLY YOUR DISCOUNT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

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
                MaterialPageRoute(
                    builder: (context) =>
                        Privilege(currentUserId: currentUserId)),
              );
            },
          )),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage("images/hotel.png"),
            ),
            Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'For the second time in a row, the award-winning Transcorp Hilton Abuja has emerged the winner of the Best City Hotel(West & Central Africa).',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 32.0, 16.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 30,
                                )),
                            Text(
                              'Swipe up',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        child: Column(
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/hotel1.png'),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 20.0, 0.0),
                              child: ButtonTheme(
                                minWidth: 350.0,
                                height: 60.0,
                                child: RaisedButton(
                                  color: Color(0xffc67608),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xffc67608),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Text("VIEW DISCOUNT"),
                                  textColor: Colors.white,
                                  onPressed: _showModalSheet,
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
          ],
        ),
      ),
    );
  }
}
