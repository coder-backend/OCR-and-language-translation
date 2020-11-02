import 'package:app_dev/Inside_app/camera_or_gallery.dart';
import 'package:app_dev/Inside_app/ocr.dart';
import 'package:app_dev/Inside_app/translatorOnly.dart';
import 'package:app_dev/Team_Member/ex.dart';
import 'package:app_dev/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage({this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String uid;
  //_HomePageState({this.uid});
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
                image: AssetImage("assets/img/home1.jpg"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
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
                              width: 280,
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
                                  "Optical Char Recog.",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 50,
                              width: 280,
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              height: 50,
                              width: 280,
                              color: Colors.tealAccent,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TranslatorOnly()));
                                },
                                icon: Icon(
                                  Icons.translate,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                color: Colors.deepOrange,
                                label: Text(
                                  "Language Trans.",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
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
                onTap: () => nextpage(context), child: Text("Team Member"))));
  }
}
