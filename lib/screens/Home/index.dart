import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("ホーム"),
        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.settings), onPressed:(){
            Navigator.of(context).pushNamed("/setting");
          } ),
        ], 
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: 70.0, bottom: 10.0),
              child: const Text('温度',
              style: TextStyle(fontSize: 20)),
            ),

            Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                    .collection('Users')
                    .document('User1')
                    .collection('HouseData')
                    .orderBy('date', descending: true)
                    .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) 
                      return Text('Loading...');
                      return Text('${snapshot.data.documents[0]['temp']}' + '℃',
                      style: TextStyle(fontSize: 40)
                      );
                    },
                  ),
            ),

            /*Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
              child: const Text('20℃',
              style: TextStyle(fontSize: 40)),
            ),*/

            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: const Text('湿度',
              style: TextStyle(fontSize: 20)),
            ),

            /*Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 40.0),
              child: const Text('50%',
              style: TextStyle(fontSize: 40)),
            ),*/

            Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 40.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                    .collection('Users')
                    .document('User1')
                    .collection('HouseData')
                    .orderBy('date', descending: true)
                    .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) 
                      return Text('Loading...');
                      return Text('${snapshot.data.documents[0]['hum']}' + '%',
                      style: TextStyle(fontSize: 40)
                      );
                    },
                  ),
            ),

            new RaisedButton(
            child: const Text("設定"),
            onPressed: () {
              // 設定画面へ
              Navigator.of(context).pushNamed("/setting");
              },
            ),
          ]
        ),
      ),
    );
  }
}
