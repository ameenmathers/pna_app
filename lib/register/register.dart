import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_world/formsec/form2.dart';
import 'package:travel_world/register/pay.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  SharedPreferences prefs;
  String _date = "Not set";
  String _country;

  bool checkboxValue = false;

  final _photo1 =
      "https://www.familyvacationcritic.com/uploads/sites/19/2015/08/AtlantisParadiseIsland-OverviewImage.jpg";
  final _photo2 =
      "https://www.familyvacationcritic.com/uploads/sites/19/2015/08/AtlantisParadiseIsland-OverviewImage.jpg";
  final _photo3 =
      "https://www.familyvacationcritic.com/uploads/sites/19/2015/08/AtlantisParadiseIsland-OverviewImage.jpg";
  final _photo4 =
      "https://www.familyvacationcritic.com/uploads/sites/19/2015/08/AtlantisParadiseIsland-OverviewImage.jpg";

  final _photo =
      'https://cdn4.iconfinder.com/data/icons/business-conceptual-part1-1/513/business-man-512.png';

  final _status = "Available";

  bool showSpinner = false;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController aboutMeInputController;
  TextEditingController cityInputController;
  TextEditingController genderInputController;
  TextEditingController professionInputController;
  TextEditingController reasonInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    nameInputController = new TextEditingController();
    aboutMeInputController = new TextEditingController();
    cityInputController = new TextEditingController();
    genderInputController = new TextEditingController();
    professionInputController = new TextEditingController();
    reasonInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    image1 = Image.asset(
      "images/ban5.jpg",
      fit: BoxFit.fill,
      gaplessPlayback: true,
    );
    image2 = Image.asset(
      "images/ban8.jpg",
      fit: BoxFit.fill,
      gaplessPlayback: true,
    );
    image3 = Image.asset(
      "images/ban7.jpg",
      fit: BoxFit.fill,
      gaplessPlayback: true,
    );
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  bool _termsChecked = false;

  Image image1;
  Image image2;
  Image image3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                child: image1,
                height: size.height,
                width: size.width,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 800.0, 0.0, 0.0),
                child: Container(
                  child: image2,
                  height: size.height,
                  width: size.width,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 1300.0, 0.0, 0.0),
                child: Container(
                  child: image3,
                  height: size.height,
                  width: size.width,
                ),
              ),
              Container(
                color: Colors.transparent,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Form2()),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "PLAY NETWORK AFRICA",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              fontFamily: 'SFProDisplay',
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40.0, 0.0, 20.0, 0.0),
                            child: Text(
                              "To apply or log in, use your phone number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                controller: nameInputController,
                                validator: (value) {
                                  if (value.length < 3) {
                                    return "Please enter a valid name.";
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 32.0, 16.0),
                            child: Container(
                              width: 330,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffc67608),
                                ),
                                color: Colors.black,
                              ),
                              child: RaisedButton(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                elevation: 4.0,
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                      ),
                                      showTitleActions: true,
                                      minTime: DateTime(1960, 1, 1),
                                      maxTime: DateTime(2005, 12, 31),
                                      onConfirm: (date) {
                                    print('confirm $date');
                                    _date =
                                        '${date.year} - ${date.month} - ${date.day}';
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Container(
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 18.0,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  " $_date",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "Date of Birth",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 32.0, 16.0),
                            child: Container(
                              width: 330,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffc67608),
                                ),
                                color: Colors.black,
                              ),
                              padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                              child: new DropdownButton<String>(
                                iconEnabledColor: Colors.white,
                                value: _country,
                                hint: Text(
                                  'Country of Residence',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _country = newValue;
                                  });
                                },
                                items: <String>[
                                  'Seychelles',
                                  'Madagascar',
                                  'Nigeria',
                                  'Ghana',
                                  'South Africa',
                                  'Rwanda',
                                  'Botswana',
                                  'Kenya',
                                  'Cameroon',
                                  'Mauritius',
                                  'Benin Republic',
                                  'Ethopia',
                                  'Togo',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 32.0, 16.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'City',
                                filled: true,
                                fillColor: Colors.black,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffc67608))),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: cityInputController,
                              validator: (value) {
                                if (value.length < 3) {
                                  return "Please fill this field.";
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Profession',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: professionInputController,
                                validator: (value) {
                                  if (value.length < 3) {
                                    return "Please fill this field.";
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Gender',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: genderInputController,
                                validator: (value) {
                                  if (value.length < 3) {
                                    return "Please enter this field.";
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                maxLines: 14,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tell Us More About Yourself',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: aboutMeInputController,
                                validator: (value) {
                                  if (value.length < 3) {
                                    return "Please fill this field.";
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                maxLines: 14,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Why do you want to join?',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: reasonInputController,
                                validator: (value) {
                                  if (value.length < 3) {
                                    return "Please fill this field.";
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email Address',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: emailInputController,
                                keyboardType: TextInputType.emailAddress,
                                validator: emailValidator,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                controller: pwdInputController,
                                validator: pwdValidator,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Confirm Password',
                                  hintText: "********",
                                  filled: true,
                                  fillColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  focusColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc67608))),
                                ),
                                controller: confirmPwdInputController,
                                obscureText: true,
                                validator: pwdValidator,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 0.0, 16.0),
                              child: Container(
                                height: 65,
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: new CheckboxListTile(
                                      title: new Text(
                                        "I agree to the Play Network Africa's Terms and Conditions",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      value: _termsChecked,
                                      checkColor: Colors.white,
                                      activeColor: Colors.blue,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (bool value) => setState(
                                          () => _termsChecked = value)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 32.0, 16.0),
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
                                  child: Text("Sign Up"),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    if (_registerFormKey.currentState
                                        .validate()) {
                                      if (!_termsChecked) {
                                        // The checkbox wasn't checked
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please accept our terms and conditions",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIos: 1,
                                            backgroundColor: Color(0xffc67608),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        if (pwdInputController.text ==
                                            confirmPwdInputController.text) {
                                          FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email:
                                                      emailInputController.text,
                                                  password:
                                                      pwdInputController.text)
                                              .then((currentUser) => Firestore
                                                  .instance
                                                  .collection("users")
                                                  .document(
                                                      currentUser.user.uid)
                                                  .setData({
                                                    "uid": currentUser.user.uid,
                                                    "name": nameInputController
                                                        .text,
                                                    "aboutMe":
                                                        aboutMeInputController
                                                            .text,
                                                    "city": cityInputController
                                                        .text,
                                                    "country": _country,
                                                    "dob": _date,
                                                    "gender":
                                                        genderInputController
                                                            .text,
                                                    "profession":
                                                        professionInputController
                                                            .text,
                                                    "reaosn":
                                                        reasonInputController
                                                            .text,
                                                    "email":
                                                        emailInputController
                                                            .text,
                                                    "photoUrl": _photo,
                                                    "image1": _photo1,
                                                    "image2": _photo2,
                                                    "image3": _photo3,
                                                    "image4": _photo4,
                                                    "status": _status,
                                                  })
                                                  .then((result) => {
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Pay()),
                                                            (_) => false),
                                                        nameInputController
                                                            .clear(),
                                                        cityInputController
                                                            .clear(),
                                                        emailInputController
                                                            .clear(),
                                                        pwdInputController
                                                            .clear(),
                                                        confirmPwdInputController
                                                            .clear()
                                                      })
                                                  .catchError(
                                                      (err) => print(err)))
                                              .catchError((err) => print(err));

                                          setState(() {
                                            showSpinner = false;
                                          });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Error"),
                                                  content: Text(
                                                      "The passwords do not match"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                      }
                                    }

                                    setState(() {
                                      showSpinner = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Text(
                              "By clicking sign up you agree to the following",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child: Text(
                              'Terms and Conditions without reservation',
                              textAlign: TextAlign.center,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
