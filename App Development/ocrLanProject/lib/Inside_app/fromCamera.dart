import 'dart:io';

import 'package:ocrLanProject/Inside_app/connection.dart';

import './camera_or_gallery.dart';
import './ocr.dart';
import './translator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

const String ssd = "SSD MobileNet";

class Camera extends StatefulWidget {
  final String uid;
  Camera({this.uid});
  @override
  _CameraState createState() => _CameraState(uid: uid);
}

class _CameraState extends State<Camera> {
  final String uid;
  _CameraState({this.uid});
  String objectText = "Nothing";

  String _model = ssd;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/tflite/ssd_mobilenet.tflite",
        labels: "assets/tflite/ssd_mobilenet.txt",
      );
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  language() {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             Translator(text: objectText, uid: uid, filePath: _image.path)));
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: 1000,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child:
                  Connection(uid: uid, text: objectText, filePath: _image.path),
            ),
          );
        });
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    File cameraCropped = await ImageCropper.cropImage(
        sourcePath: image.path,
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
    if (cameraCropped == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(cameraCropped);
  }

  predictImage(File image) async {
    if (image == null) return;
    await ssdMobileNet(image);

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color blue = Colors.red;

    return _recognitions.map((re) {
      for (var i = 0; i < _recognitions.length; i++) {
        if (_recognitions[i]["confidenceInClass"] > 0.60) {
          objectText = _recognitions[i]["detectedClass"];

          return Positioned(
            left: _recognitions[i]["rect"]["x"] * factorX,
            top: _recognitions[i]["rect"]["y"] * factorY,
            width: _recognitions[i]["rect"]["w"] * factorX,
            height: _recognitions[i]["rect"]["h"] * factorY,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: blue,
                width: 3,
              )),
              child: Text(
                "${_recognitions[i]["detectedClass"]} ${(_recognitions[i]["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  background: Paint()..color = blue,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: blue,
              width: 3,
            )),
            child: Text(
              "Couldn't recognize",
              style: TextStyle(
                background: Paint()..color = blue,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          );
        }
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: _image == null
              ? Center(child: Text("No Image Selected"))
              : Center(
                  child: Image.file(_image),
                ),
        ),
      ),
    );

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Object Detection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Camera(uid: uid)));
              },
              icon: Icon(Icons.refresh),
              label: Text('Refresh'))
        ],
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Options(uid: uid)));
            }),
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
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.red,
              label: 'Capture',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                selectFromImagePicker();
              }),
          SpeedDialChild(
            child: Icon(Icons.translate),
            backgroundColor: Colors.blue,
            label: "Translate",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              language();
            },
          ),
        ],
      ),
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
