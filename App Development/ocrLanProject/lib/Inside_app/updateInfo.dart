import '../Databases/databases.dart';
import '../Databases/user.dart';
import 'package:flutter/material.dart';

class SettingForm extends StatefulWidget {
  final String uid;
  SettingForm({this.uid});
  @override
  _SettingFormState createState() => _SettingFormState(uid: uid);
}

class _SettingFormState extends State<SettingForm> {
  final String uid;
  _SettingFormState({this.uid});

  final _formKey = GlobalKey<FormState>();

  int _currentSemester;
  String _currentName;
  String _currentGender;
  String _currentPhone;

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Update your Info...', style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 25),
                SizedBox(height: 15),
                TextFormField(
                  initialValue: userData.name,
                  decoration: InputDecoration(hasFloatingPlaceholder: true),
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Enter Name";
                    }
                  },
                  onChanged: (val) {
                    setState(() => _currentName = val.toUpperCase().trim());
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  initialValue: userData.gender,
                  decoration: InputDecoration(hasFloatingPlaceholder: true),
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Enter Gender";
                    }
                  },
                  onChanged: (val) {
                    setState(() => _currentGender = val);
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  initialValue: userData.phoneNo,
                  decoration: InputDecoration(hasFloatingPlaceholder: true),
                  validator: (input) {
                    if (input.isEmpty) {
                      return "Enter Phone";
                    }
                  },
                  onChanged: (val) {
                    setState(() => _currentPhone = val);
                  },
                ),
                SizedBox(height: 15),
                SizedBox(height: 15),
                FlatButton(
                  child: Text("Update"),
                  color: Color(0xFF4B9DFE),
                  textColor: Colors.white,
                  padding:
                      EdgeInsets.only(left: 38, right: 38, top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DatabaseService(uid: uid).updateUserData(
                        _currentName ?? userData.name,
                        _currentGender ?? userData.gender,
                        _currentPhone ?? userData.phoneNo,
                      );
                      Navigator.pop(context);
                    }
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
