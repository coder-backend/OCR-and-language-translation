import 'dart:ui';

import './camera_or_gallery.dart';
import './translatorOnly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class OCR extends StatefulWidget {
  String uid, url;
  OCR({this.uid, this.url});
  @override
  _OCRState createState() => _OCRState(uid: uid, url: url);
}

class _OCRState extends State<OCR> {
  String uid, url;
  _OCRState({this.uid, this.url});
  bool fordec = false;
  String outputText = "Nothing";
  String languagein = 'eng';
  String selectLan;
  String languageout = 'eng';
  String inputLanguage = "";
  String outputLanguage = "";
  Translation output;
  final List<String> lang = ["Nepali", "Hindi", "Punjabi"];
  File imPth;
  bool _scanning = false;
  var _extractText;
  int _scanTime = 0;

  void _uploadFile(filePath, lang) async {
    // Get base file name

    try {
      FormData formData =
          FormData.fromMap({"image": await MultipartFile.fromFile(filePath)});

      Response response =
          await Dio().post(url + "upload/ocr/" + lang, data: formData);
      print("File upload response: $response");

      // Show the incoming message in snakbar

      setState(() {
        _extractText = response;
        //_isLoading =true;
      });

      //_showSnakBarMsg(response.data['message']);
    } catch (e) {
      print("Exception Caught: $e");
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  onPressed: () async {
                    if (fordec == false) {
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
                      _uploadFile(cameraCropped.path, selectLan);
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "RobotLight"),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () async {
                    if (fordec == false) {
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
                      _uploadFile(cameraCropped.path, selectLan);
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "RobotLight"),
                  ),
                ),

                // It doesn't spin, because scanning hangs thread for now
                _scanning
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
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
              "${_extractText}",
              style: TextStyle(color: Colors.deepOrange, fontSize: 20),
            )),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
