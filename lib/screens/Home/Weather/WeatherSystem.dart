import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:agrimaster_app/screens/Home/Weather/widget/Weather.dart';
import 'package:agrimaster_app/screens/Home/Weather/models/WeatherData.dart';

//void main() => runApp(new MyApp());

class WeatherSystem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeatherState();
  }
}

class WeatherState extends State<WeatherSystem> {
  bool isLoading = false;
  WeatherData weatherData;
  String _cityname;
  TextEditingController _textEditingController = TextEditingController();

  void save(String cityData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', cityData);
  }

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
    return MaterialApp(
      title: 'Agri Weather App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
//          backgroundColor: Colors.blu,
          appBar: AppBar(
            title: Text('Agri Weather App'),
          ),
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Expanded(
                  child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.0),
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
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(_cityname, style: new TextStyle(color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: weatherData != null
                            ? Weather(weather: weatherData)
                            : Container(),
                      ),
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
                ),
              ]))),
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
