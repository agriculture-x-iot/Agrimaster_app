//現在の天気を表示する為のウィジェット

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:agrimaster_app/screens/Home/TabWidget/models/WeatherData.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(weather.name, style: new TextStyle(color: Colors.black)),
        Text(weather.description, style: new TextStyle(color: Colors.black, fontSize: 32.0)),
        Text('${weather.temp.toString()}°C',  style: new TextStyle(color: Colors.black)),
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
        Text(new DateFormat('yyyy年MM月dd日').format(weather.date), style: new TextStyle(color: Colors.black)),
        Text(new DateFormat.Hm().format(weather.date), style: new TextStyle(color: Colors.black)),
      ],
    );
  }
}

//initializeDateFormatting('ja');
//new DateFormat.yMMMd('ja');
// var date = format.format(new DateTime.now());