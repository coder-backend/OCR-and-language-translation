import 'package:app_dev/Inside_app/camera_or_gallery.dart';
import 'package:app_dev/Inside_app/ocr.dart';
import 'package:app_dev/main.dart';
import 'package:flutter/material.dart';
import '../Team_Member/team.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _alignment = Alignment.bottomCenter;
  nextpage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TeamMember()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                icon: Icon(Icons.logout),
                label: Text(''))
          ],
        ),
        body: Container(
          height: 800,
          width: 800,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/home.jpeg"), fit: BoxFit.cover),
          ),
          child: Row(
            children: <Widget>[
              Container(
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
                            width: 300,
                            color: Colors.redAccent,
                            child: FlatButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OCR()));
                              },
                              icon: Icon(
                                Icons.emoji_emotions,
                                color: Colors.white,
                                size: 30,
                              ),
                              color: Colors.deepPurple,
                              label: Text(
                                "Optical Character Recog.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 300,
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
                            color: Colors.blueAccent,
                            label: Text(
                              "Object Detection",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              setState(() {
                _alignment = Alignment.center;
              });
            },
            icon: Icon(Icons.airplanemode_active),
            label: GestureDetector(
                onLongPress: () => nextpage(context),
                child: Text("Team Member"))));
  }
}
