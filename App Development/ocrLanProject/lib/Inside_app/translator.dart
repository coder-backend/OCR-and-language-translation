import './translatorOnly.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../style/theme.dart' as Theme;
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class Translator extends StatefulWidget {
  var filePath;
  String text, urlLink;
  final String uid;
  Translator({this.text, this.uid, this.filePath, this.urlLink});
  @override
  _TranslatorState createState() => _TranslatorState(
      text: text, uid: uid, filePath: filePath, urlLink: urlLink);
}

class _TranslatorState extends State<Translator> {
  var filePath;
  final String uid, urlLink;
  String outputLanguage = "English";
  String languageout = "English";
  var output;
  String text;
  final List<String> lang = ["Nepali", "Hindi", "Punjabi"];
  _TranslatorState({this.text, this.uid, this.filePath, this.urlLink});

  language() async {
    if (languageout == "Nepali") {
      setState(() {
        outputLanguage = "nep";
      });
    }
    if (languageout == "Hindi") {
      setState(() {
        outputLanguage = "hin";
      });
    }
    if (languageout == "Punjabi") {
      setState(() {
        outputLanguage = "pan";
      });
    }
    try {
      FormData formData =
          FormData.fromMap({"image": await MultipartFile.fromFile(filePath)});

      Response response = await Dio()
          .post(urlLink + "upload/detect/" + outputLanguage, data: formData);
      print("File upload response: $response");

      // Show the incoming message in snakbar

      setState(() {
        output = response;
        //_isLoading =true;
      });

      //_showSnakBarMsg(response.data['message']);
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Language Translation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Select Output Language",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButtonFormField(
                items: lang.map((ln) {
                  return DropdownMenuItem(
                    value: ln,
                    child: Text('$ln'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    languageout = val;
                  });
                }),
            SizedBox(
              height: 35,
            ),
            Text(
              "Object Name in English is: ",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.deepOrange, fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton.icon(
              onPressed: () {
                language();
              },
              icon: Icon(
                Icons.translate,
                color: Colors.white,
                size: 30,
              ),
              color: Colors.blueAccent,
              label: Text(
                "Translate",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Output Text is: ",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '$output',
              style: TextStyle(color: Colors.deepOrange, fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
