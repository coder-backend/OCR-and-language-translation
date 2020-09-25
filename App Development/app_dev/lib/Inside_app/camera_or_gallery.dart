import 'package:app_dev/Inside_app/fromCamera.dart';
import 'package:app_dev/Inside_app/fromGallery.dart';
import 'package:app_dev/Team_Member/team.dart';
import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  @override
  OptionsState createState() {
    return new OptionsState();
  }
}

class OptionsState extends State<Options> {
  var _alignment = Alignment.bottomCenter;
  nextpage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TeamMember()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Welcome",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/robot.jpg"), fit: BoxFit.cover),
          ),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                padding: EdgeInsets.all(10.0),
                duration: Duration(milliseconds: 1000),
                alignment: _alignment,
                child: Container(
                  height: 50.0,
                  child: Icon(
                    Icons.airplanemode_active,
                    size: 50.0,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
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
                            width: 150,
                            color: Colors.redAccent,
                            child: FlatButton.icon(
                              onPressed: () {
                                selectfromCamera(context);
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                              color: Colors.deepPurple,
                              label: Text(
                                "Camera",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 150,
                          color: Colors.tealAccent,
                          child: FlatButton.icon(
                            onPressed: () {
                              selectFromGallery(context);
                            },
                            icon: Icon(
                              Icons.file_upload,
                              color: Colors.white,
                              size: 30,
                            ),
                            color: Colors.blueAccent,
                            label: Text(
                              "Gallery",
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

  selectFromGallery(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TfliteHome()));
  }

  selectfromCamera(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Camera()));
  }
}
