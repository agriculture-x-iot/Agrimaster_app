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

  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("AGRIMASTERにログイン"),
      ),
      body: new Center(
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new TextFormField(
                  controller: emailInputController,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'メールアドレス',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  controller: passwordInputController,
                  maxLength: 16,
                  decoration: new InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'パスワード',
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24.0),
                new Center(
                  child: new RaisedButton(
                    child: const Text('ログイン'),
                    onPressed: () {
                      // TODO: ログイン処理
                      // ホーム画面へ

                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();// TextFormFieldのonSavedが呼び出される
                      }

                      var email = emailInputController.text;
                      var password = passwordInputController.text;

                      Future<FirebaseUser> _user = _signIn(email, password)
                          .then((FirebaseUser user) => Navigator.of(context).pushReplacementNamed("/home"))
                          .catchError((e) => _displayError(context, e));
                      print(_user);
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: new RaisedButton(
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

    FirebaseUser user;
    String errorMessage;

    try {
     user = (await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user;
      print("User id is ${user.uid}");
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "メールアドレスの形式が正しくありません。";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "正しいパスワードを入力してください。";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "ユーザーを登録してください。";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "このメールアドレスのユーザーは無効になっています。";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "時間をおいてください。";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "登録されていません。";
          break;
        default:
          errorMessage = "ログインエラー";
      }

    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user;
  }

  String _validateEmail(String value){
    if(value.isEmpty)
      return 'メールアドレスを入力してください。';

    return null;
  }

  String _validatePassword(String value){
    if(value.isEmpty)
      return 'パスワードを入力してください。';
    if(value.length < 6){
      return "パスワードを6文字以上入力してください。";
    }

    return null;
  }

  _displayError(BuildContext context, String e) async{
    final snackBar = SnackBar(content: Text(e));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}

