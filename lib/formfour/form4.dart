import 'package:flutter/material.dart';
import 'package:travel_world/navigation/navigation.dart';

class Form4 extends StatefulWidget {
  @override
  _Form4State createState() => _Form4State();
}

class _Form4State extends State<Form4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "PLAY NETWORK AFRICA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 20.0, 0.0),
                      child: Text(
                        "To apply or log in, use your phone number",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
                      child: TextField(
                        maxLines: 14,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tell Us Abit About Yourself',
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade700,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          focusColor: Colors.white,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 20.0, 0.0),
                      child: ButtonTheme(
                        minWidth: 350.0,
                        height: 60.0,
                        child: RaisedButton(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.amber,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Text("Submit Application"),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(
                        "By clicking sign up you agree to the following",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 10.0),
                      child: Text(
                        'Terms and Conditions without reservation',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
