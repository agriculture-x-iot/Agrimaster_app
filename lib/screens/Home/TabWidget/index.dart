import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:agrimaster_app/screens/Home/Home.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';


class Temp extends StatefulWidget {
    @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid;

  @override
  void initState(){

    super.initState();

    //get();
  }

  void get() async{
    FirebaseUser user = await _auth.currentUser();
    
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
  if(uid == null){
    get();
  }

    return  Scaffold(
      body:  Center(
        child:  Column(
          children: <Widget>[

            Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                    .collection('Users')
                    .document(uid)
                    .collection('HouseData')
                    .orderBy('date', descending: true)
                    .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData){
                        return Text('Loading...');
                      } else{
                        DateTime date = snapshot.data.documents[0]['date'].toDate();
                        var date2 = DateFormat('yyyy/MM/dd HH:mm').format(date);
                        return Text(date2.toString() + ' 時点');
                      }
                    },
                  ),
            ),

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
                    .document(uid)
                    .collection('HouseData')
                    .orderBy('date', descending: true)
                    .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) 
                      return Text('Loading...');
                      return Text('${snapshot.data.documents[0]['tmp']}' + '℃',
                      style: TextStyle(fontSize: 40)
                      );
                    },
                  ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: const Text('湿度',
              style: TextStyle(fontSize: 20)),
            ),

            Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 40.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                    .collection('Users')
                    .document(uid)
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
          ]
        ),
      ),
    );
  }
}