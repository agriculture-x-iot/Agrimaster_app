import 'package:agrimaster_app/screens/Home/TabWidget/index.dart';
import 'package:agrimaster_app/screens/Home/TabWidget/WeatherSystem.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'TabWidget/graph.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
            elevation: 0.7,
            title: const Text('ホーム'),

        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.settings), onPressed:(){
            Navigator.of(context).pushNamed("/setting");
          } ),
        ],

            bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.orange,
                tabs: <Widget>[
                  Tab(icon: Icon(FontAwesomeIcons.cloudSun)),
                  Tab(icon: Icon(FontAwesomeIcons.thermometerFull)),
                  Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                ]
            )
        ),

        //画面タップ時にキーボードをしまうようにする処理
        body: GestureDetector(
            onHorizontalDragCancel: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
      
        child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              WeatherSystem(),
              Temp(),
              Graph(),
            ]
        )
      )
    );
  }
}