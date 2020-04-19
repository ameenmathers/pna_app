import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_world/formsec/form2.dart';
import 'package:travel_world/login/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String key1 = '1zh';

  String _error;

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  bool checkboxValue = false;

  final _photo =
      'https://firebasestorage.googleapis.com/v0/b/play-2f9e6.appspot.com/o/2QlcuNr.png?alt=media&token=a709eb8a-db7f-4696-a641-bec24590701a';

  bool showSpinner = false;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController aboutMeInputController;
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
                          showAlert(),
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
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                            child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Container(
                                width: 330,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffc67608),
                                  ),
                                  color: Colors.black,
                                ),
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.black,
                                  ),
                                  child: DropdownButtonHideUnderline(
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
                                        '🇦🇺  Australia',
                                        '🇦🇹  Austria',
                                        '🇦🇷  Argentina',
                                        '🇦🇴  Angola',
                                        '🇩🇿  Algeria',
                                        '🇧🇸  Bahamas',
                                        '🇧🇩  Bangladesh',
                                        '🇧🇧  Barbados',
                                        '🇧🇪  Belgium',
                                        '🇧🇯  Benin Republic',
                                        '🇧🇷  Brazil',
                                        '🇧🇼  Botswana',
                                        '🇧🇬  Bulgaria',
                                        '🇧🇫  Burkina Faso',
                                        '🇨🇦  Canada',
                                        '🇨🇲  Cameroon',
                                        '🇨🇱  Chile',
                                        '🇨🇳  China',
                                        '🇨🇴  Colombia',
                                        '🇨🇬  Congo',
                                        '🇨🇷  Costa Rica',
                                        "🇨🇮  Cote d'Ivoire",
                                        '🇭🇷  Croatia',
                                        '🇨🇾  Cyprus',
                                        '🇩🇰  Denmark',
                                        '🇪🇨  Ecuador',
                                        '🇪🇬  Egypt',
                                        '🇬🇶  Equatorial Guinea',
                                        '🇪🇪  Estonia',
                                        '🇪🇹  Ethopia',
                                        '🇫🇮  Finland',
                                        '🇫🇷  France',
                                        '🇬🇦  Gabon',
                                        '🇬🇲  Gambia',
                                        '🇩🇪  Germany',
                                        '🇬🇭  Ghana',
                                        '🇬🇷  Greece',
                                        '🇬🇹  Guatemala',
                                        '🇬🇳  Guinea',
                                        '🇭🇹  Haiti',
                                        '🇭🇺  Hungary',
                                        '🇮🇸  Iceland',
                                        '🇮🇳  India',
                                        '🇮🇩  Indonesia',
                                        '🇮🇪  Ireland',
                                        '🇮🇱  Israel',
                                        '🇮🇹  Italy',
                                        '🇯🇲  Jamaica',
                                        '🇯🇵  Japan',
                                        '🇯🇴  Jordan',
                                        '🇰🇪  Kenya',
                                        '🇰🇼  Kuwait',
                                        '🇱🇧  Lebanon',
                                        '🇱🇷  Liberia',
                                        '🇱🇹  Lithuania',
                                        '🇱🇺  Luxembourg',
                                        '🇲🇬  Madagascar',
                                        '🇲🇼  Malawi',
                                        '🇲🇾  Malaysia',
                                        '🇲🇻  Maldives',
                                        '🇲🇱  Mali',
                                        '🇲🇺  Mauritius',
                                        '🇲🇽  Mexico',
                                        '🇲🇨  Monaco',
                                        '🇲🇦  Morocco',
                                        '🇲🇿  Mozambique',
                                        '🇳🇦  Namibia',
                                        '🇳🇵  Nepal',
                                        '🇳🇱  Netherlands',
                                        '🇳🇿  New Zealand',
                                        '🇳🇪  Niger',
                                        '🇳🇬  Nigeria',
                                        '🇳🇴  Norway',
                                        '🇵🇦  Panama',
                                        '🇵🇾  Paraguay',
                                        '🇵🇪  Peru',
                                        '🇵🇭  Philippines',
                                        '🇵🇱  Poland',
                                        '🇵🇹  Portugal',
                                        '🇶🇦  Qatar',
                                        '🇷🇴  Romania',
                                        '🇷🇺  Russia',
                                        '🇷🇼  Rwanda',
                                        '🇸🇳  Senegal',
                                        '🇸🇨  Seychelles',
                                        '🇸🇱  Sierra Leone',
                                        '🇸🇬  Singapore',
                                        '🇸🇰  Slovakia',
                                        '🇿🇦  South Africa',
                                        '🇰🇷  South Korea',
                                        '🇪🇸  Spain',
                                        '🇱🇰  Sri Lanka',
                                        '🇸🇪  Sweden',
                                        '🇨🇭  Switzerland',
                                        '🇹🇼  Taiwan',
                                        '🇹🇿  Tanzania',
                                        '🇹🇭  Thailand',
                                        '🇹🇬  Togo',
                                        '🇹🇷  Turkey',
                                        '🇺🇬  Uganda',
                                        '🇺🇦  Ukraine',
                                        '🇦🇪  UAE',
                                        '🇬🇧  United Kingdom',
                                        '🇺🇸  United States',
                                        '🇺🇾  Uruguay',
                                        '🇻🇪  Venezuela',
                                        '🇿🇲  Zambia',
                                        '🇿🇼  Zimbabwe',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(
                                            value,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
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
                                  hintText: 'Profession',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  hintText: 'Gender',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  hintText: 'Tell Us More About Yourself',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  hintText: 'Why do you want to join?',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 65,
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white,
                                    ),
                                    child: new CheckboxListTile(
                                        title: new Text(
                                          "I agree to the Play Network Africa's Terms (EULA) and Conditions",
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
                                InkWell(
                                  splashColor: Colors.white,
                                  highlightColor: Colors.lightBlue,
                                  child: Text(
                                    "Click here to view our EULA Terms and Conditions",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onTap: () async {
                                    if (await canLaunch(
                                        "http://www.playnetworkafrica.com/public/terms")) {
                                      await launch(
                                          "http://www.playnetworkafrica.com/public/terms");
                                    }
                                  },
                                ),
                              ],
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

                                    try {
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
                                              backgroundColor:
                                                  Color(0xffc67608),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          if (pwdInputController.text ==
                                              confirmPwdInputController.text) {
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                    email: emailInputController
                                                        .text,
                                                    password:
                                                        pwdInputController.text)
                                                .then((currentUser) => Firestore
                                                    .instance
                                                    .collection("users")
                                                    .document(
                                                        currentUser.user.uid)
                                                    .setData({
                                                      "uid":
                                                          currentUser.user.uid,
                                                      'blockedUsers':
                                                          FieldValue.arrayUnion(
                                                              [key1]),
                                                      "name":
                                                          nameInputController
                                                              .text,
                                                      "aboutMe":
                                                          aboutMeInputController
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
                                                    })
                                                    .then((result) => {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Login()),
                                                              (_) => false),
                                                          nameInputController
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
                                                .catchError(
                                                    (err) => print(err));

                                            setState(() {
                                              showSpinner = false;
                                            });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                    } catch (e) {
                                      print(e);

                                      setState(() {
                                        showSpinner = false;
                                        _error = e.message;
                                      });
                                    }
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
