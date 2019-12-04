import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => new _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("新規登録"),
      ),
      body: new Center(
        child: new Form(
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new TextFormField(
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'ユーザ名',
                  ),
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'メールアドレス',
                  ),
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  maxLength: 16,
                  decoration: new InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'パスワード',
                  ),
                ),
                const SizedBox(height: 24.0),
                new Center(
                  child: new RaisedButton(
                    child: const Text('新規登録'),
                    onPressed: () {
                      // TODO: 新規登録処理

                      // ホーム画面へ
                      Navigator.of(context).pushReplacementNamed("/login");
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: new RaisedButton(
                  child: const Text("戻る"),
                  onPressed: () {
                    // ログイン画面へ戻る
                    Navigator.of(context).pop();
                    //Navigator.of(context).pushNamed("/login");
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
}