import 'package:ocrLanProject/ui/login_page.dart';

import './camera_or_gallery.dart';
import './ocr.dart';
import './translatorOnly.dart';
import '../Team_Member/ex.dart';
import '../main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage({this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid;
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
            "Welcome",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey,
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
                image: AssetImage("assets/img/home.jpg"), fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Column(
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => OCR()));
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
                                    builder: (context) => Options()));
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
                                    builder: (context) => TranslatorOnly()));
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
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blueGrey,
            onPressed: () {
              setState(() {
                _alignment = Alignment.center;
              });
            },
            icon: Icon(Icons.airplanemode_active),
            label: GestureDetector(
                onTap: () => nextpage(context),
                child: Text(
                  "Team Member",
                  style: TextStyle(fontFamily: "RobotLight"),
                ))));
  }
}
