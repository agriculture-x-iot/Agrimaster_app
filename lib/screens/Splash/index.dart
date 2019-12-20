import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 3))
        .then((value) => handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
     return new Scaffold(
       backgroundColor: Colors.brown[700],
      body: new Center(
        // TODO: スプラッシュアニメーション
        child: Image.asset('lib/images/AGRIMASTERwhite.png'),
//        child: const CircularProgressIndicator(),
      ),
    );
  }

  void handleTimeout() {
    // ログイン画面へ
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
