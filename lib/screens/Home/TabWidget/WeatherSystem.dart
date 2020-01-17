import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:agrimaster_app/screens/Home/TabWidget/widget/Weather.dart';
import 'package:agrimaster_app/screens/Home/TabWidget/models/WeatherData.dart';

class WeatherSystem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeatherState();
  }
}

class WeatherState extends State<WeatherSystem> {
  bool isLoading = false;
  WeatherData weatherData;
  String _cityname = '八王子市';
  TextEditingController _textEditingController = TextEditingController();

  //検索した都市名を保存する処理
  void save(String cityData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', cityData);
  }

  //保存された都市名をロードし、且つその都市名の天気情報を検索
  void load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _textEditingController.text = (prefs.getString('city') ?? '');
      _cityname = (prefs.getString('city') ?? '');
      loadWeather();
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

//-----------------------------------------------------------------------------------------------------------------
//--------------------------------------------レイアウト-----------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Expanded(
              child: SingleChildScrollView(
                  child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      //都市検索用テキストエディタ
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          decoration: new InputDecoration(
                            labelText: '都市名を入力',
                          ),
                          controller: _textEditingController,
                          onChanged: (value){
                            setState(() {
                              _cityname = value;
                              loadWeather();
                              save(_textEditingController.text);
                            });
                          },
                        ),
                      ),

//                      Padding(
//                        padding: const EdgeInsets.all(0.0),
//                        child: Text(_cityname, style: new TextStyle(color: Colors.black)),
//                      ),

                    //Whether.dart表示処理
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: weatherData != null
                            ? Weather(weather: weatherData)
                            : Container(),
                      ),

                      //情報更新
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isLoading
                            ? CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                          new AlwaysStoppedAnimation(Colors.white),
                        )
                            : IconButton(
                          icon: new Icon(Icons.refresh),
                          tooltip: 'Refresh',
                          onPressed: loadWeather,
                          color: Colors.black,
                        ),
                      ),

                    ],
                  ),
                 )
                ),
              ])),
    );
  }

//-----------------------------------------------------------------------------------------------------------------
//--------------------------------------------レイアウト-----------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------

//天気読み込み
  loadWeather() async {
    setState(() {
      isLoading = true;
    });
    final city = _cityname;
    //       TextEditingController();  //都市名　　八王子市の座標
    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?APPID=f87a978b6d291a0b0df4308c9ed0c262&q=${city
            .toString()}&lang=ja&units=metric');        //現在の天気を取得するためのAPI接続URL

    if (weatherResponse.statusCode == 200)
    {
      return setState(() {
        weatherData = new WeatherData.fromJson(jsonDecode(weatherResponse.body));
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}
