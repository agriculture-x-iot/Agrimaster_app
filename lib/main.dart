import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,  //デバッグリボン非表示
    title: 'Navigation with Routes',
    routes: <String, WidgetBuilder>{
      '/': (_) => new Splash(),
      '/login': (_) => new Login(),
      '/registration': (_) => new Registration(),
      '/home': (_) => new Home(),
      '/setting': (_) => new Setting(),
    },
  ));
}

// --------------
// スプラッシュ画面
// --------------
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
}

// -----------
// ログイン画面
// -----------
class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("AGRIMASTERにログイン"),
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
                    child: const Text('ログイン'),
                    onPressed: () {
                      // TODO: ログイン処理
                      // ホーム画面へ
                      Navigator.of(context).pushReplacementNamed("/home");
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
}

// ---------
// 登録画面
// ---------

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

// ---------
// ホーム画面
// ---------
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
        child: new RaisedButton(
          child: const Text("設定"),
          onPressed: () {
            // 設定画面へ
            Navigator.of(context).pushNamed("/setting");
          },
        ),
      ),
    );
  }
}

// ---------
// 設定画面
// ---------
class Setting extends StatefulWidget {
  @override
  _SettingState createState() => new _SettingState();
}

class _SettingState extends State<Setting> {

  bool _active = false;
  void _changeSwitch(bool e) => setState(() => _active = e);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("設定"),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            /*const SizedBox(height: 24.0),
            new RaisedButton(
              child: const Text("次の画面"),
              onPressed: () {
                // その他の画面へ
                Navigator.of(context).pushNamed("/next");
              },
            ),*/

            new SwitchListTile(
            value: _active,
            activeColor: Colors.orange,
            activeTrackColor: Colors.red,
            inactiveThumbColor: Colors.blue,
            inactiveTrackColor: Colors.grey,
            title: Text('通知'),
            onChanged: _changeSwitch,
          ),

          const Text("温度設定"),
          const Text("下限"),
          const Text("上限"),

          const SizedBox(height: 24.0),
          new RaisedButton(
              child: const Text("ホーム"),
              onPressed: () {
                // ホーム画面へ戻る　
                Navigator.popUntil(context, ModalRoute.withName("/home"));
              },
            ),
          const SizedBox(height: 24.0),
          new RaisedButton(
              child: const Text("ログアウト"),
              onPressed: () {
                // 確認ダイアログ表示
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      content: const Text('ログアウトしてもよろしいですか？'),
                      actions: <Widget>[
                        new FlatButton(
                          child: const Text('いいえ'),
                          onPressed: () {
                            // 引数をfalseでダイアログ閉じる
                            Navigator.of(context).pop(false);
                          },
                        ),
                        new FlatButton(
                          child: const Text('はい'),
                          onPressed: () {
                            // 引数をtrueでダイアログ閉じる
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                ).then<void>((aBool) {
                  // ダイアログがYESで閉じられたら...
                  if (aBool) {
                    // 画面をすべて除いてスプラッシュを表示
                    Navigator.pushAndRemoveUntil(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Splash()),
                        (_) => false);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}