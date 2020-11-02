import 'package:flutter/material.dart';

import '../main.dart';

class Sorry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorry'),
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              icon: Icon(Icons.power_settings_new),
              label: Text('Go Back')),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/sorry.jpg"), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
