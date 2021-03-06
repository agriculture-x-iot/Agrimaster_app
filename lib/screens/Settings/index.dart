import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:agrimaster_app/screens/Splash/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class DisableKeybord extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _SettingState extends State<Setting> {

/*  static Future<String> _getUid() async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    print("IDIDID${user.uid}");

    return user.uid;
  }
  String uid =_getUid().toString();
  */

  var uid;
/*
  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = user.uid.toString();
    });
  }
  */
FirebaseAuth _auth = FirebaseAuth.instance;

  void get() async{
    FirebaseUser user = await _auth.currentUser();
    setState(() {
      uid = user.uid;
    });
  }

  bool _active = false;
  void _changeSwitch(bool e) => setState(() => _active = e);

  double _start;
  double _end;
  var _rangeValues = RangeValues(10.0, 30.0);

  void _savetmp() async {
    setState(() {
      _settmp();  // Shared Preferenceに値を保存する。
    });
  }

  // Shared Preferenceに値を保存されているデータを読み込んで_rangeValuesにセットする。
  _gettmp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下の「counter」がキー名。見つからなければ０を返す
    setState(() {
      _humrangeValues = RangeValues(prefs.getDouble('minhum'), prefs.getDouble('maxhum')) ?? RangeValues(10.0, 80.0);
      _humupdateLabels(_humrangeValues);
      _rangeValues = RangeValues(prefs.getDouble('mintmp'), prefs.getDouble('maxtmp')) ?? RangeValues(10.0, 30.0);
      _updateLabels(_rangeValues);
    });
  }

  // Shared Preferenceにデータを書き込む
  _settmp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下の「counter」がキー名。
    prefs.setDouble('mintmp', _start);
    prefs.setDouble('maxtmp', _end);
  }

  _updateLabels(RangeValues values) {
    _start = _rangeValues.start.roundToDouble();
    _end = _rangeValues.end.roundToDouble();
  }

  double _humstart;
  double _humend;
  var _humrangeValues = RangeValues(10.0, 80.0);
  

  void _savehum() async {
    setState(() {
      _sethum();  // Shared Preferenceに値を保存する。
    });
  }
/*
  // Shared Preferenceに値を保存されているデータを読み込んで_rangeValuesにセットする。
  _gethum() async {
    SharedPreferences prefsh = await SharedPreferences.getInstance();
    // 以下の「counter」がキー名。見つからなければ０を返す
    setState(() {
      _humrangeValues = RangeValues(prefsh.getDouble('minhum'), prefsh.getDouble('maxhum')) ?? RangeValues(0.0, 0.0);
      _humupdateLabels(_humrangeValues);
    });
  }
*/
  // Shared Preferenceにデータを書き込む
  _sethum() async {
    SharedPreferences prefsh = await SharedPreferences.getInstance();
    // 以下の「counter」がキー名。
    prefsh.setDouble('minhum', _humstart);
    prefsh.setDouble('maxhum', _humend);
  }


  _humupdateLabels(RangeValues values) {
    _humstart = _humrangeValues.start.roundToDouble();
    _humend = _humrangeValues.end.roundToDouble();
  }
/*
  pullmintmp() {
    StreamBuilder(
      stream: Firestore.instance
      .collection('Users')
      .document('$uid')
      .snapshots(),
      builder: (context, snapshot) {
        return _start = snapshot.data['mintmp'];
      },
    );
  }
  pullmaxtmp() {
    StreamBuilder(
      stream: Firestore.instance
      .collection('Users')
      .document('$uid')
      .snapshots(),
      builder: (context, snapshot) {
        return _end = snapshot.data['maxtmp'];
      },
    );
  }
  pullminhum() {
    StreamBuilder(
      stream: Firestore.instance
      .collection('Users')
      .document('$uid')
      .snapshots(),
      builder: (context, snapshot) {
        return _humstart = snapshot.data['minhum'];
      },
    );
  }
  pullmaxhum() {
    StreamBuilder(
      stream: Firestore.instance
      .collection('Users')
      .document('$uid')
      .snapshots(),
      builder: (context, snapshot) {
        return _humend = snapshot.data['maxhum'];
      },
    );
  }
  */

  pushtmp() {
    Firestore.instance
    .collection('Users')
    .document('$uid')
    .updateData({
      'mintmp': _start,
      'maxtmp': _end,
    });
  }

  pushhum() {
    Firestore.instance
    .collection('Users')
    .document('$uid')
    .updateData({
      'minhum': _humstart,
      'maxhum': _humend,
    });
  }

  @override
  void initState() {

    isPasswordVisible = false;

    //_gettmp();
    //_gethum();
    _updateLabels(_rangeValues);
    _humupdateLabels(_humrangeValues);

    get();
    //inputData();

    super.initState();
  }

  bool isPasswordVisible = false;

  GlobalKey<ScaffoldState> screen = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: screen,
      //key: _scaffoldstate,
        appBar: AppBar(
            title: const Text("設定"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 5),
                    child: MergeSemantics(
                      child: ListTile(
                        title: Text('通知',
                                style: TextStyle(fontSize:  23)),
                        trailing: CupertinoSwitch(
                          value: _active,
                          onChanged: _changeSwitch,
                        ),
                      ),
                    ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 35.0, left: 20),
                    child: Text("温度を設定", style: TextStyle(fontSize: 23)),
                  ),
                ),
                SliderTheme(
                    data: SliderThemeData(
                    activeTrackColor: Colors.green[250],
                    inactiveTrackColor: Colors.grey,
                    showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: RangeSlider(
                        labels: RangeLabels(_start.round().toString(), _end.round().toString()),
                        values: _rangeValues,
                        min: 0,
                        max: 60,
                        divisions: 60,
                        onChanged: (values) {
                          _rangeValues = values;
                          setState(() => _updateLabels(values));
                        },
                    ),
                ),

                Container(
                    padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  '${_start.round()}℃',
                                    style: TextStyle(fontSize: 40),
                                ),
                                Text('下限'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '${_end.round()}℃',
                                    style: TextStyle(fontSize: 40),
                                ),
                                Text('上限'),
                              ],
                            ),
                          ],
                      ),
                ),

                RaisedButton(
                  //color: Colors.blueAccent,
                  shape: StadiumBorder(),
                  onPressed: () {
                    pushtmp();
                    _savetmp();
                    //TODO:設定温度送信
                    screen.currentState.removeCurrentSnackBar();
                    screen.currentState
                        .showSnackBar(SnackBar(
                          content: Text('温度設定を確定しました！')));
                  },
                  child: Text('温度確定',
                            style: TextStyle(color: Colors.white)
                            ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 35.0, left: 20),
                    child: Text("湿度を設定", style: TextStyle(fontSize: 23)),
                  ),
                ),
                SliderTheme(
                    data: SliderThemeData(
                    activeTrackColor: Colors.green[250],
                    inactiveTrackColor: Colors.grey,
                    showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: RangeSlider(
                        labels: RangeLabels(_humstart.round().toString(), _humend.round().toString()),
                        values: _humrangeValues,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (values) {
                          _humrangeValues = values;
                          setState(() => _humupdateLabels(values));
                        },
                    ),
                ),

                Container(
                    padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  '${_humstart.round()}%',
                                    style: TextStyle(fontSize: 40),
                                ),
                                Text('下限'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '${_humend.round()}%',
                                    style: TextStyle(fontSize: 40),
                                ),
                                Text('上限'),
                              ],
                            ),
                          ],
                      ),
                ),

                RaisedButton(
                  //color: Colors.blueAccent,
                  shape: StadiumBorder(),
                  onPressed: () {
                    pushhum();
                    _savehum();
                    //TODO:設定湿度送信
                    screen.currentState.removeCurrentSnackBar();
                    screen.currentState
                        .showSnackBar(SnackBar(
                          content: Text('湿度設定を確定しました！')));
                  },
                  child: Text('湿度確定',
                            style: TextStyle(color: Colors.white)
                            ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text("アカウント", 
                            style: TextStyle(fontSize: 25)),
                ),

                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  child: StreamBuilder(
                    stream: Firestore.instance
                      .collection('Users')
                      .document('$uid')
                      .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                      return Text('Loading...');
                      } else {
                        print('----------'+uid+ '-----------');
                      return TextFormField(
                        initialValue: '${snapshot.data['e-mail'].toString()}',
                        focusNode: DisableKeybord(),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'メールアドレス',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          )
                        ),
                      );
                      }
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
                  child: StreamBuilder(
                    stream: Firestore.instance
                      .collection('Users')
                      .document('$uid')
                      .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) 
                      return Text('Loading...');
                      return TextFormField(
                        focusNode: DisableKeybord(),
                        maxLines: 1,
                        initialValue: '${snapshot.data['password'].toString()}',
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                    );
                    }),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: RaisedButton(
                      color: Colors.redAccent,
                      shape: StadiumBorder(),
                      child: const Text("ログアウト",
                                    style: TextStyle(color: Colors.white)),
                        onPressed: () {
                    // 確認ダイアログ表示
                            showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    content: const Text('ログアウトしてもよろしいですか？'),
                                    actions: <Widget>[
                                        RaisedButton(
                                            color: Colors.red,
                                            shape: StadiumBorder(),
                                            child: const Text('いいえ', 
                                                          style: TextStyle(color: Colors.white),),
                                            onPressed: () {
                                              // 引数をfalseでダイアログ閉じる
                                              Navigator.of(context).pop(false);
                                            },
                                        ),
                                        RaisedButton(
                                              color: Colors.blueAccent,
                                              shape: StadiumBorder(),
                                                child: const Text('はい', 
                                                            style: TextStyle(color: Colors.white),),
                                              onPressed: () {
                                                //TODO:ログアウト
                                                // 引数をtrueでダイアログ閉じる
                                                FirebaseAuth.instance.signOut();
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
                                          MaterialPageRoute(
                                              builder: (context) => Splash()),
                                              (_) => false
                                      );
                                    }
                                  });
                                },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
