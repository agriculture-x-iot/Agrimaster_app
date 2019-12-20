import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => new _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final nameInputController = new TextEditingController();
  final emailInputController = new TextEditingController();
  final passwordInputController = new TextEditingController();
  final passwordConfirmController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text("新規登録"),
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
                  controller: nameInputController,
                  maxLength: 30,
                  maxLengthEnforced: true,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'ユーザ名',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  controller: emailInputController,
                  maxLength: 30,
                  maxLengthEnforced: true,
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
                  maxLengthEnforced: true,
                  decoration: new InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'パスワード',
                  ),
                  validator: _validatePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  controller: passwordConfirmController,
                  maxLength: 16,
                  maxLengthEnforced: true,
                  decoration: new InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'パスワード確認',
                  ),
                  validator: _validatePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                new Center(
                  child: new RaisedButton(
                    child: const Text('新規登録'),
                    onPressed: () {

                      // TODO: 新規登録処理

                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();// TextFormFieldのonSavedが呼び出される
                      }

                      var name = nameInputController.text;
                      var email = emailInputController.text;
                      var inputPassword = passwordInputController.text;
                      var confirmPassword = passwordConfirmController.text;

                      Future<FirebaseUser> _user = _createUser(name, email, inputPassword, confirmPassword)
                          .then((FirebaseUser user) => _displaySuccess(context))
                          .catchError((e) => _displayError(context, e));
                      print(_user);

                    },

                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: new RaisedButton(
                  child: const Text("戻る"),
                  onPressed: () {
                    // ログイン画面へ戻る
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/login");
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

  Future<FirebaseUser> _createUser(String name, String email, String inputPassword, String confirmPassword) async {

    FirebaseUser user;
    String errorMessage;

    try {

      if(inputPassword == confirmPassword){
        user = (await _auth.createUserWithEmailAndPassword(
            email: email,
            password: inputPassword
        )).user;

        Firestore.instance.collection("Users").document(user.uid).setData(
            {
              "name": name,
              "e-mail": email,
              "password": inputPassword
            });

        Firestore.instance.collection("Users").document(user.uid)
            .collection("HouseData").add({"hum": "", "temp": "", "date": ""});

        Firestore.instance.collection("Users").document(user.uid)
            .setData(
            {"name": name, "e-mail": email, "password": inputPassword, "place": ""});
      }else if(inputPassword != confirmPassword){
        print(inputPassword != confirmPassword);
        errorMessage = "パスワードが一致しません。";
        return Future.error(errorMessage);
      }


    }catch(error){
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
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "このメールアドレスは既に登録されています。";
          break;
        default:
          print(error);
          errorMessage = "登録エラー";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user;

  }

  String _validateName(String value){
    if(value.isEmpty)
      return '名前を入力してください。';

    return null;
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

  _displaySuccess(BuildContext context) async{
    final snackBar = SnackBar(content: Text('登録しました。'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    await new Future.delayed(new Duration(seconds: 3));
    Navigator.of(context).pushReplacementNamed("/login");
  }

  _displayError(BuildContext context, String e) async{
    final snackBar = SnackBar(content: Text(e)]);
    
    screen.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
