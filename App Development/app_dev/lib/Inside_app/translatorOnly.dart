import 'package:app_dev/Inside_app/home.dart';
import 'package:app_dev/Inside_app/ocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:translator/translator.dart';
import '../style/theme.dart' as Theme;
import 'camera_or_gallery.dart';

class TranslatorOnly extends StatefulWidget {
  @override
  _TranslatorOnlyState createState() => _TranslatorOnlyState();
}

class _TranslatorOnlyState extends State<TranslatorOnly> {
  String outputLanguage = "English";
  String inputLanguage = "English";
  String languagein = "English";
  String languageout = "English";
  String text = "Type in your language";
  Translation output;

  final List<String> lang = ["English", "Nepali", "Hindi", "Punjabi"];

  language() async {
    if (languagein == "English") {
      if (languageout == "Hindi") {
        setState(() {
          inputLanguage = "en";
          outputLanguage = "hi";
        });
      }
      if (languageout == "Nepali") {
        setState(() {
          inputLanguage = "en";
          outputLanguage = "ne";
        });
      }
      if (languageout == "Punjabi") {
        setState(() {
          inputLanguage = "en";
          outputLanguage = "pa";
        });
      }
    }
    /////////////////////////////////////////////////////////////////////
    if (languagein == "Hindi") {
      if (languageout == "Nepali") {
        setState(() {
          inputLanguage = "hi";
          outputLanguage = "ne";
        });
      }
      if (languageout == "Punjabi") {
        setState(() {
          inputLanguage = "hi";
          outputLanguage = "pa";
        });
      }
      if (languageout == "English") {
        setState(() {
          inputLanguage = "hi";
          outputLanguage = "en";
        });
      }
    }
    ////////////////////////////////////////////////////////////
    if (languagein == "Nepali") {
      if (languageout == "Hindi") {
        setState(() {
          inputLanguage = "ne";
          outputLanguage = "hi";
        });
      }
      if (languageout == "Punjabi") {
        setState(() {
          inputLanguage = "ne";
          outputLanguage = "pa";
        });
      }
      if (languageout == "English") {
        setState(() {
          inputLanguage = "ne";
          outputLanguage = "en";
        });
      }
    }
    ///////////////////////////////////////////////////////////////////////////
    if (languagein == "Punjabi") {
      if (languageout == "Hindi") {
        setState(() {
          inputLanguage = "pa";
          outputLanguage = "hi";
        });
      }
      if (languageout == "Nepali") {
        setState(() {
          inputLanguage = "pa";
          outputLanguage = "ne";
        });
      }
      if (languageout == "English") {
        setState(() {
          inputLanguage = "pa";
          outputLanguage = "en";
        });
      }
    }

    final translator = GoogleTranslator();
    var translation = await translator.translate(text,
        from: inputLanguage, to: outputLanguage);
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
                    MaterialPageRoute(builder: (ctx) => TranslatorOnly()));
              },
              icon: Icon(Icons.refresh),
              label: Text(''))
        ],
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              "Select Input Language",
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
                    languagein = val;
                  });
                }),
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
            TextFormField(
              initialValue: text,
              decoration: InputDecoration(hasFloatingPlaceholder: true),
              validator: (input) {
                if (input.isEmpty) {
                  return "Type";
                }
              },
              onChanged: (val) {
                setState(() => text = val);
              },
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Input Text is: ",
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
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.emoji_emotions),
            backgroundColor: Colors.blue,
            label: "OCR",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => OCR()));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.change_history),
            backgroundColor: Colors.green,
            label: 'Object Detection',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => Options()));
            },
          ),
        ],
      ),
    );
  }
}
