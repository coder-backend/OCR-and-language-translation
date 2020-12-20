import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocrLanProject/Databases/urlData.dart';
import 'package:ocrLanProject/Inside_app/ocr.dart';
import 'package:ocrLanProject/Inside_app/translator.dart';

import '../Databases/databases.dart';
import '../Databases/user.dart';
import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  final String uid, text;
  var filePath;

  Connection({this.uid, this.text, this.filePath});
  @override
  _ConnectionState createState() =>
      _ConnectionState(uid: uid, text: text, filePath: filePath);
}

class _ConnectionState extends State<Connection> {
  final String uid, text;
  var filePath;
  _ConnectionState({this.uid, this.text, this.filePath});
  final _formKey = GlobalKey<FormState>();

  String _currentName;

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    return StreamBuilder<UserDataURL>(
      stream: DatabaseServiceURL(uid: "1").userDataURL,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserDataURL userDataURL = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('You will be Connecting with...',
                    style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 25),
                Text("${userDataURL.url}"),
                SizedBox(height: 15),
                FlatButton(
                  child: Text("Proceed"),
                  color: Color(0xFF4B9DFE),
                  textColor: Colors.white,
                  padding:
                      EdgeInsets.only(left: 38, right: 38, top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Translator(
                                uid: uid,
                                text: text,
                                filePath: filePath,
                                urlLink: userDataURL.url)));
                  },
                ),
              ],
            ),
          );
        } else {
          return Container(child: Text('you got an error'));
        }
      },
    );
  }
}
