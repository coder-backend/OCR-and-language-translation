import 'package:ocrLanProject/Databases/urlData.dart';
import 'package:ocrLanProject/Inside_app/ocr.dart';

import '../Databases/databases.dart';
import '../Databases/user.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  final String uid;
  Test({this.uid});
  @override
  _TestState createState() => _TestState(uid: uid);
}

class _TestState extends State<Test> {
  final String uid;
  _TestState({this.uid});
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
                            builder: (context) =>
                                OCR(uid: uid, url: userDataURL.url)));
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
