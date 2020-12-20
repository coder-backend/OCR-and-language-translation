import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ocrLanProject/Inside_app/search.dart';
import 'package:ocrLanProject/Inside_app/test.dart';
import 'package:ocrLanProject/Inside_app/updateInfo.dart';
import 'package:ocrLanProject/ui/login_page.dart';

import './camera_or_gallery.dart';
import './ocr.dart';
import './translatorOnly.dart';
import '../Team_Member/ex.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:particles_flutter/particles_flutter.dart';

class HomePage extends StatefulWidget {
  final String uid;
  HomePage({this.uid});
  @override
  _HomePageState createState() => _HomePageState(uid: uid);
}

class _HomePageState extends State<HomePage> {
  final String uid;
  _HomePageState({this.uid});
  var _alignment = Alignment.bottomCenter;
  nextpage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connect People",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[300],
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.logout),
              label: Text(''))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0
            ? MediaQuery.of(context).size.height
            : 775.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/nice2.jpg"), fit: BoxFit.cover),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  height: 50,
                  width: 250,
                  color: Colors.redAccent,
                  child: FlatButton.icon(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => OCR(uid: uid)));
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Container(
                                height: 1000,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 60.0),
                                child: Test(uid: uid),
                              ),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: 30,
                    ),
                    color: Colors.lightGreen,
                    label: Text(
                      "Optical Char Recog.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "RobotLight",
                      ),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  width: 250,
                  color: Colors.tealAccent,
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Options(uid: uid)));
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                      size: 30,
                    ),
                    color: Colors.lightBlue,
                    label: Text(
                      "Object Detection",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "RobotLight"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 50,
                  width: 250,
                  color: Colors.tealAccent,
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TranslatorOnly(uid: uid)));
                    },
                    icon: Icon(
                      Icons.translate,
                      color: Colors.white,
                      size: 30,
                    ),
                    color: Colors.grey,
                    label: Text(
                      "Language Trans.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "RobotLight"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.person_search),
            backgroundColor: Colors.blue,
            label: "Informations",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _updateInfo(context, uid);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.person),
            backgroundColor: Colors.green,
            label: 'Team Member',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => MyHomePage()));
            },
          ),
        ],
      ),
    );
  }

  void _updateInfo(context, uid) {
    if (uid == "zwLjDmRp5IhwY0FUbk1dvjOJOOw2") {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => Search()));
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                height: 1000,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: SettingForm(uid: uid),
              ),
            );
          });
    }
  }
}
