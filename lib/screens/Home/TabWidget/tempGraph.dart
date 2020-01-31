import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'temp.dart';

class TempGraph extends StatefulWidget {
  @override
  _GraphState createState() {
    return _GraphState();
  }
}

class _GraphState extends State<TempGraph> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid;

  void get() async{
    FirebaseUser user = await _auth.currentUser();
    
    if(mounted){
      setState(() {
        uid = user.uid;
      });
    }
  }

  List<charts.Series<Sales, DateTime>> _seriesBarData;
  List<Sales> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Sales, DateTime>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => sales.date.toDate(),   // X軸
        measureFn: (Sales sales, _) => sales.tmp,   // Y軸
        colorFn: (Sales sales, _) =>  charts.ColorUtil.fromDartColor(Colors.green),
        id: 'Sales',
        data: mydata,
        labelAccessorFn: (Sales row, _) => "${row.date}",
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {

    if(uid == null){
    get();
   }

    print(uid);

    return StreamBuilder<QuerySnapshot>(
      
      stream: Firestore.instance
      .collection('Users')
      .document(uid)
      .collection('HouseData')
      .orderBy('date', descending: true)
      .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }
        if (snapshot.hasError) {
          return LinearProgressIndicator();
        } else {
          print(snapshot);
          List<Sales> graphTmp = snapshot.data.documents
              .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, graphTmp);
        }
      },
    );
  }
  
  Widget _buildChart(BuildContext context, List<Sales> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '過去の温度データ',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.TimeSeriesChart(_seriesBarData,
                    animate: true,
                    animationDuration: Duration(seconds:1),

                    defaultRenderer: charts.LineRendererConfig(),

                    customSeriesRenderers: [
                      charts.PointRendererConfig(
                        // ID used to link series to this renderer.
                        customRendererId: 'sales')
                    ],

                     behaviors: [
                      charts.ChartTitle('時間',
                        behaviorPosition: charts.BehaviorPosition.bottom,
                        titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                      charts.ChartTitle('温度(℃)',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                     ]

                     /*behaviors: [
                      new charts.DatumLegend(
                        entryTextStyle: charts.TextStyleSpec(
                            //color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],*/
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}