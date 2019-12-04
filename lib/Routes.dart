import 'package:flutter/material.dart';
import 'package:agrimaster_app/screens/Login/index.dart';
import 'package:agrimaster_app/screens/SignUp/index.dart';
import 'package:agrimaster_app/screens/Home/index.dart';
import 'package:agrimaster_app/screens/Splash/index.dart';
import 'package:agrimaster_app/screens/Settings/index.dart';
//import 'package:agrimaster_app/theme/style.dart';

class Routes {

  var routes = <String, WidgetBuilder>{
      '/Splash': (BuildContext context) => new Splash(),
      '/login': (BuildContext context) => new Login(),
      '/registration': (BuildContext context) => new Registration(),
      '/home': (BuildContext context) => new Home(),
      '/setting': (BuildContext context) => new Setting(),
      };

  Routes() {
    runApp(new MaterialApp(
      home: new Splash(),
      routes: routes,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(minWidth: 12),
        primarySwatch: Colors.green
    ),
    debugShowCheckedModeBanner: false,  //デバッグリボン非表示
    title: 'Agrimaster App',
  ));
  }
}