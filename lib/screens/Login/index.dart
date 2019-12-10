import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

    @override
  void initState() {
    isPasswordVisible = false;
    super.initState();
  }

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AGRIMASTERにログイン"),
      ),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailInputController,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'メールアドレス',
                    icon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          )
                  ),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordInputController,
                  maxLength: 16,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                          hintText: 'パスワード',
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible =
                                      !isPasswordVisible;
                                  });
                                },
                          ),
                          icon: Icon(Icons.lock)
                        ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: RaisedButton(
                    child: const Text('ログイン'),
                    onPressed: () {
                      // TODO: ログイン処理
                      // ホーム画面へ
                      var email = emailInputController.text;
                      var password = passwordInputController.text;
                      Future<FirebaseUser> _user = _signIn(email, password)
                          .then((FirebaseUser user) => Navigator.of(context).pushReplacementNamed("/home"))
                          .catchError((e) => print(e));
                      print(_user);
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: RaisedButton(
                  child: const Text("新規登録"),
                  onPressed: () {
                    // 登録画面へ
                    Navigator.of(context).pushNamed("/registration");
                  },
                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _signIn(String email, String password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
        )).user;
    print("User id is ${user.uid}");

    return user;
  }

}

