import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Graph extends StatefulWidget {
  final Widget child;

  Graph({Key key, this.child}) : super(key: key);

  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<charts.Series<TimeSeriesSales, DateTime>> _seriesLineData;

  Stream getStreamSnapshots(String snapshots)  {
  return Firestore.instance
  .collection('Users')
  .document('User1')
  .collection('HouseData')
  .orderBy('date', descending: true)
  .snapshots();
}

  _generateData() {

    var linesalesdata = [
      new TimeSeriesSales(new DateTime(2019, 12, 19, 12, 21), 21),
      new TimeSeriesSales(new DateTime(2019, 12, 19, 13, 21), 25),
      new TimeSeriesSales(new DateTime(2019, 12, 19, 14, 21), 31),
      new TimeSeriesSales(new DateTime(2019, 12, 19, 15, 21), 19),
      new TimeSeriesSales(new DateTime(2019, 12, 19, 16, 21), 14),
      new TimeSeriesSales(new DateTime(2019, 12, 19, 17, 21), 27),
      new TimeSeriesSales(new DateTime(2019, 12, 19, 18, 21), 13),
      new TimeSeriesSales(new DateTime(2019, 12, 20, 12, 21), 20),
      new TimeSeriesSales(new DateTime(2019, 12, 21, 14, 21), 13),
      new TimeSeriesSales(new DateTime(2019, 12, 22, 16, 21), 25),
      new TimeSeriesSales(new DateTime(2019, 12, 23, 18, 21), 13),
    ];
    /*var linesalesdata1 = [
      new Sales(0, 35),
      new Sales(1, 46),
      new Sales(2, 45),
      new Sales(3, 50),
      new Sales(4, 51),
      new Sales(5, 60),
    ];*/

    ///////折れ線グラフ///////

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.salesval,
      ),
    );
   /* _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );*/
  }

  ///////折れ線グラフ///////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<TimeSeriesSales, DateTime>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 200.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                            '過去1週間の温度データ',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.TimeSeriesChart(
                            _seriesLineData,
                            defaultRenderer: new charts.LineRendererConfig(
                              includePoints: true, includeArea: false, stacked: false),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                            new charts.ChartTitle('日時（日）',
                                behaviorPosition: charts.BehaviorPosition.bottom,
                                titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                            new charts.ChartTitle('温度（℃）',
                                behaviorPosition: charts.BehaviorPosition.start,
                                titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                            //new charts.ChartTitle('Departments',
                              //  behaviorPosition: charts.BehaviorPosition.end,
                              //  titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                              //  )   
                          ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          );
  }
}

class TimeSeriesSales {
  DateTime time;
  int salesval;

  TimeSeriesSales(this.time, this.salesval);
}
