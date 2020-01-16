import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 1))
        .then((value) => _catheLogin());
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

    // ログイン画面へ
    Navigator.of(context).pushReplacementNamed("/login");
  }

  Future<Null> _catheLogin() async{

    print(_auth);

    FirebaseUser user = await _auth.currentUser();


    print("\n\n\n\n");
    print(user);

    if(user != null){
      Navigator.of(context).pushReplacementNamed("/home");
    }else{
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }
}
