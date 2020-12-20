import './fromCamera.dart';
import './fromGallery.dart';
import './home.dart';

import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';

class Options extends StatefulWidget {
  final String uid;
  Options({this.uid});
  @override
  OptionsState createState() {
    return new OptionsState(uid: uid);
  }
}

class OptionsState extends State<Options> {
  final String uid;
  OptionsState({this.uid});
  var _alignment = Alignment.bottomCenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Object Detection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage(uid: uid)));
            }),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0
            ? MediaQuery.of(context).size.height
            : 775.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/ob.jpg"), fit: BoxFit.cover),
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
                      width: 200,
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
                        color: Colors.grey,
                        label: Text(
                          "Camera",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 200,
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
                      color: Colors.lightBlue,
                      label: Text(
                        "Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectFromGallery(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TfliteHome(uid: uid)));
  }

  selectfromCamera(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Camera(uid: uid)));
  }
}
