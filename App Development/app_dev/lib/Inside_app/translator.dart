import 'package:app_dev/Inside_app/translatorOnly.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../style/theme.dart' as Theme;

class Translator extends StatefulWidget {
  String text;
  Translator({this.text});
  @override
  _TranslatorState createState() => _TranslatorState(text: text);
}

class _TranslatorState extends State<Translator> {
  String outputLanguage = "English";
  String languageout = "English";
  Translation output;
  String text;
  final List<String> lang = ["Nepali", "Hindi", "Punjabi"];
  _TranslatorState({this.text});

  language() async {
    if (languageout == "Nepali") {
      setState(() {
        outputLanguage = "ne";
      });
    }
    if (languageout == "Hindi") {
      setState(() {
        outputLanguage = "hi";
      });
    }
    if (languageout == "Punjabi") {
      setState(() {
        outputLanguage = "pa";
      });
    }
    final translator = GoogleTranslator();
    var translation =
        await translator.translate(text, from: 'en', to: outputLanguage);
    setState(() {
      output = translation;
    });
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
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TranslatorOnly()));
              },
              icon: Icon(Icons.g_translate),
              label: Text(''))
        ],
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
