import 'dart:async';
import 'dart:io';
import 'package:agrimaster_app/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Token extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Token> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();


  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );

    Future.delayed(const Duration(seconds: 1))
        .then((value) => handleTimeout());
  }

  @override
    void dispose() {
      if (iosSubscription != null) iosSubscription.cancel();
      super.dispose();
    }


    /// Get the token, save it to the database for current user
    _saveDeviceToken() async {
    // Get the current user
      String uid = 'apple';
      //TODO: ユーザー名入れる場所
      // FirebaseUser user = await _auth.currentUser();

      // Get the token for this device
      String fcmToken = await _fcm.getToken();

      // Save it to Firestore
      if (fcmToken != null) {
        var tokens = _db
            .collection('users')
            .document(uid)
            .collection('tokens')
            .document(fcmToken);

          await tokens.setData({
            'token': fcmToken,
            'createdAt': FieldValue.serverTimestamp(), // optional
            'platform': Platform.operatingSystem // optional
          });
      }
    }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        body: new Center(
          // TODO: スプラッシュアニメーション
          child: const CircularProgressIndicator(),
        ),
      );
    }

    void handleTimeout() {
      // home画面へ
      Navigator.of(context).pushReplacementNamed("/home");
    }
}