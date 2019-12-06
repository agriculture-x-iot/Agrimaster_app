import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:agrimaster_app/screens/Splash/index.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class DisableKeybord extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _SettingState extends State<Setting> {

  bool _active = false;
  void _changeSwitch(bool e) => setState(() => _active = e);

  var _start = '';
  var _end = '';
  var _rangeValues = RangeValues(10.0, 30.0);

  _updateLabels(RangeValues values) {
    _start = '${_rangeValues.start.round()}';
    _end = '${_rangeValues.end.round()}';
  }

  var _humstart = '';
  var _humend = '';
  var _humrangeValues = RangeValues(10.0, 80.0);

  _humupdateLabels(RangeValues values) {
    _humstart = '${_humrangeValues.start.round()}';
    _humend = '${_humrangeValues.end.round()}';
  }

  @override
  void initState() {
    _updateLabels(_rangeValues);

    _humupdateLabels(_humrangeValues);

    isPasswordVisible = false;
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
                        labels: RangeLabels(_start, _end),
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
                                  '$_start℃',
                                    style: TextStyle(fontSize: 40),
                                ),
                                Text('下限'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '$_end℃',
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
                        labels: RangeLabels(_humstart, _humend),
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
                                  '$_humstart%',
                                    style: TextStyle(fontSize: 40),
                                ),
                                Text('下限'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '$_humend%',
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
                  child: TextFormField(
                    initialValue: 'test@mail.com',
                    focusNode: DisableKeybord(),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'メールアドレス',
                      icon: Icon(
                        Icons.mail,
                        color: Colors.grey,
                      )
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
                  child: TextFormField(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    focusNode: DisableKeybord(),
                    maxLines: 1,
                    initialValue: 'testPasswordDAYO!',
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
                  ),
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