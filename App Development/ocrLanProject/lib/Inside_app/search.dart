import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: TextField(
            onChanged: (val) => initiateSearch(val),
          ),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.search_rounded),
                label: Text(''))
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: name != "" && name != null
              ? FirebaseFirestore.instance
                  .collection('Users')
                  .where("name", isEqualTo: name)
                  .snapshots()
              : FirebaseFirestore.instance.collection("Users").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');

              default:
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Card(
                        child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        new Text(
                          document.data()['name'],
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontFamily: "Roboto-Light"),
                        ),
                        new ListTile(
                          title: new Text(document.data()['gender']),
                          subtitle: new Text(document.data()['phoneNo']),
                        ),
                      ],
                    ));
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toUpperCase().trim();
    });
  }
}
