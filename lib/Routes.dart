import 'package:flutter/material.dart';
import 'package:agrimaster_app/screens/Login/index.dart';
import 'package:agrimaster_app/screens/SignUp/index.dart';
import 'package:agrimaster_app/screens/Home/index.dart';
import 'package:agrimaster_app/screens/Splash/index.dart';
import 'package:agrimaster_app/screens/Splash/token.dart';
import 'package:agrimaster_app/screens/Settings/index.dart';
//import 'package:agrimaster_app/theme/style.dart';

class Routes {

  var routes = <String, WidgetBuilder>{
      '/Splash': (BuildContext context) => Splash(),
      '/login': (BuildContext context) => Login(),
      '/token': (BuildContext context) => Token(),
      '/registration': (BuildContext context) => Registration(),
      '/home': (BuildContext context) => Home(),
      '/setting': (BuildContext context) => Setting(),
      };

  Routes() {
    runApp(MaterialApp(
      home: Splash(),
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