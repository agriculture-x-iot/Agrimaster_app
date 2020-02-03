import 'package:agrimaster_app/screens/Home/TabWidget/index.dart';
import 'package:agrimaster_app/screens/Home/TabWidget/WeatherSystem.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'TabWidget/tempGraph.dart';
import 'TabWidget/humGraph.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
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
                tabs: <Widget>[
                  Tab(icon: Icon(FontAwesomeIcons.cloudSun)),
                  Tab(icon: Icon(FontAwesomeIcons.thermometerFull)),
                  Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                  Tab(icon: Icon(FontAwesomeIcons.chartLine))
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
              TempGraph(),
              HumGraph()
            ]
        )
        )
    );
  }
}