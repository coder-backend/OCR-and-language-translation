import 'package:app_dev/Inside_app/home.dart';
import 'package:flutter/material.dart';
import './ui/login_page.dart';


void main() async {

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TheGorgeousLogin',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:new LoginPage(), 
    );
  }
}
