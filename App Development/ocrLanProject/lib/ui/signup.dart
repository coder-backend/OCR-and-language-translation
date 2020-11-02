import '../Databases/databases.dart';
//import 'package:app_dev/Inside_app/home.dart';
//import 'package:app_dev/helper/functions.dart';
import 'package:flutter/material.dart';
import '../Inside_app/home.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../style/theme.dart' as Theme;
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  String _emailSignup, _passwordSignup;

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;
  bool _isLoading = false;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  Color left = Colors.black;
  Color right = Colors.white;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool trueInput = false;
  String id;
  Future<void> signUp() async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();
      setState(() {
        _isLoading = true;
      });

      try {
        auth.UserCredential userCredential = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailSignup,
                password: _passwordSignup); //as FirebaseUser;
        //Navigate to new page
        auth.User user = userCredential.user;
        id = user.uid;

        print(user.uid);
        if (user != null) {
          await DatabaseService(uid: user.uid).updateUserData(
            'Your name',
            'Your phoneNo',
            'Your gender',
          );

          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        uid: user.uid,
                      )));
        }
      } catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                //padding: EdgeInsets.only(top: 23.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Card(
                            elevation: 2.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: 300.0,
                              height: 360.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodeEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.envelope,
                                          color: Colors.black,
                                        ),
                                        hintText: "Email Address",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 16.0),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "please type email";
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _emailSignup = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodePassword,
                                      obscureText: _obscureTextSignup,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.black,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 16.0),
                                        suffixIcon: GestureDetector(
                                          onTap: _toggleSignup,
                                          child: Icon(
                                            _obscureTextSignup
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.length < 8) {
                                          return "Password must be minimum 8 digits or number";
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _passwordSignup = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextFormField(
                                      focusNode: myFocusNodePassword,
                                      obscureText: _obscureTextSignupConfirm,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.black,
                                        ),
                                        hintText: "Confirmation",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 16.0),
                                        suffixIcon: GestureDetector(
                                          onTap: _toggleSgnupConfirm,
                                          child: Icon(
                                            _obscureTextSignupConfirm
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (_passwordSignup != value) {
                                          return "Password Does not match";
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 340.0),
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.Colors.loginGradientStart,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: Theme.Colors.loginGradientEnd,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                              ],
                              gradient: new LinearGradient(
                                  colors: [
                                    Theme.Colors.loginGradientEnd,
                                    Theme.Colors.loginGradientStart
                                  ],
                                  begin: const FractionalOffset(0.2, 0.2),
                                  end: const FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: MaterialButton(
                                highlightColor: Colors.transparent,
                                splashColor: Theme.Colors.loginGradientEnd,
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 42.0),
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontFamily: "WorkSansBold"),
                                  ),
                                ),
                                onPressed: () {
                                  signUp();
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSgnupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
