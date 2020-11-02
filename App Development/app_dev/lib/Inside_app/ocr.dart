import 'dart:ui';

import 'package:app_dev/Inside_app/camera_or_gallery.dart';
import 'package:app_dev/Inside_app/translatorOnly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:translator/translator.dart';

class OCR extends StatefulWidget {
  @override
  _OCRState createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  bool fordec = false;
  String outputText = "Nothing";
  String languagein = 'eng';
  String selectLan;
  String languageout = 'eng';
  String inputLanguage = "";
  String outputLanguage = "";
  Translation output;
  final List<String> lang = ["English", "Nepali", "Hindi", "Punjabi"];
  File imPth;
  static const String TESS_DATA_CONFIG = 'assets/tessdata_config.json';
  static const String TESS_DATA_PATH = 'assets/tessdata';
  static const MethodChannel _channel = const MethodChannel('tesseract_ocr');

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
    var translation = await translator.translate(_extractText,
        from: inputLanguage, to: outputLanguage);
    setState(() {
      output = translation;
    });
  }

  static Future<String> extractText(String imagePath, String language) async {
    assert(await File(imagePath).exists(), true);
    final String tessData = await _loadTessData();
    final String extractText =
        await _channel.invokeMethod('extractText', <String, dynamic>{
      'imagePath': imagePath,
      'tessData': tessData,
      'language': language,
    });
    return extractText;
  }

  static Future<String> _loadTessData() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String tessdataDirectory = join(appDirectory.path, 'tessdata');

    if (!await Directory(tessdataDirectory).exists()) {
      await Directory(tessdataDirectory).create();
    }
    await _copyTessDataToAppDocumentsDirectory(tessdataDirectory);
    return appDirectory.path;
  }

  static Future _copyTessDataToAppDocumentsDirectory(
      String tessdataDirectory) async {
    final String config = await rootBundle.loadString(TESS_DATA_CONFIG);
    Map<String, dynamic> files = jsonDecode(config);
    for (var file in files["files"]) {
      if (!await File('$tessdataDirectory/$file').exists()) {
        final ByteData data = await rootBundle.load('$TESS_DATA_PATH/$file');
        final Uint8List bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File('$tessdataDirectory/$file').writeAsBytes(bytes);
      }
    }
  }

  getImage(ImageSource source) async {
    File img = await ImagePicker.pickImage(source: source);
    if (img != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarTitle: "Adjust Image",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white));
      return cropped;
    }
    setState(() {
      imPth = img;
    });
  }

  bool _scanning = false;
  String _extractText = '';
  int _scanTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optical Character Recognition'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text("Input Language"),
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
            Text("Output Language"),
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  onPressed: () async {
                    if (fordec == false) {
                      if (languagein == "English") {
                        setState(() {
                          fordec = true;
                          selectLan = "eng";
                        });
                      }
                      if (languagein == "Hindi") {
                        setState(() {
                          fordec = true;
                          selectLan = "hin";
                        });
                      }
                      if (languagein == "Nepali") {
                        setState(() {
                          fordec = true;
                          selectLan = "nep";
                        });
                      }
                      if (languagein == "Punjabi") {
                        setState(() {
                          fordec = true;
                          selectLan = "pan";
                        });
                      }
                    } else {
                      File img = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      File cameraCropped = await ImageCropper.cropImage(
                          sourcePath: img.path,
                          compressQuality: 100,
                          maxHeight: 500,
                          maxWidth: 900,
                          compressFormat: ImageCompressFormat.jpg,
                          androidUiSettings: AndroidUiSettings(
                              showCropGrid: true,
                              toolbarColor: Colors.deepOrange,
                              toolbarTitle: "Adjust Image",
                              statusBarColor: Colors.deepOrange.shade900,
                              backgroundColor: Colors.white));
                      _scanning = true;
                      setState(() {});

                      var watch = Stopwatch()..start();
                      _extractText =
                          await extractText(cameraCropped.path, selectLan);
                      _scanTime = watch.elapsedMilliseconds;

                      _scanning = false;
                      fordec = false;
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  color: Colors.deepPurple,
                  label: Text(
                    "Camera",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () async {
                    if (fordec == false) {
                      if (languagein == "English") {
                        setState(() {
                          fordec = true;
                          selectLan = "eng";
                        });
                      }
                      if (languagein == "Hindi") {
                        setState(() {
                          fordec = true;
                          selectLan = "hin";
                        });
                      }
                      if (languagein == "Nepali") {
                        setState(() {
                          fordec = true;
                          selectLan = "nep";
                        });
                      }
                      if (languagein == "Punjabi") {
                        setState(() {
                          fordec = true;
                          selectLan = "pan";
                        });
                      }
                    } else {
                      File img = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      File cameraCropped = await ImageCropper.cropImage(
                          sourcePath: img.path,
                          compressQuality: 100,
                          maxHeight: 500,
                          maxWidth: 900,
                          compressFormat: ImageCompressFormat.jpg,
                          androidUiSettings: AndroidUiSettings(
                              showCropGrid: true,
                              toolbarColor: Colors.deepOrange,
                              toolbarTitle: "Adjust Image",
                              statusBarColor: Colors.deepOrange.shade900,
                              backgroundColor: Colors.white));
                      _scanning = true;
                      setState(() {});

                      var watch = Stopwatch()..start();
                      _extractText =
                          await extractText(cameraCropped.path, selectLan);
                      _scanTime = watch.elapsedMilliseconds;

                      _scanning = false;
                      fordec = false;
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    Icons.file_upload,
                    color: Colors.white,
                    size: 30,
                  ),
                  color: Colors.blueAccent,
                  label: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

                // It doesn't spin, because scanning hangs thread for now
                _scanning
                    ? SpinKitCircle(
                        color: Colors.black,
                      )
                    : Icon(Icons.done),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Scanning took $_scanTime ms',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
                child: SelectableText(
              _extractText,
              style: TextStyle(color: Colors.deepOrange, fontSize: 20),
            )),
            SizedBox(
              height: 15,
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
              "$output",
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
            child: Icon(Icons.translate),
            backgroundColor: Colors.blue,
            label: "Language Translate",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => TranslatorOnly()));
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
